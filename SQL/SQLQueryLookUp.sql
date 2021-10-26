USE Northwind;

-- �ϸ�ũ ���

-- Index Scan vs Index Seek
-- Index Scan�� �׻� ���� ���� �ƴϰ�
-- Index Seek�� �׻� ���� ���� �ƴϴ�
-- �ε����� Ȱ���ϴµ� ��� ���� ���� ������?

-- NonClustered
--     1
-- 2 3 4 5 6

-- Clustered
--     1
-- 2 3 4 5 6

-- Heap Table[ {Page} {Page} ]

-- Clustered�� ��� Index Seek�� ���� ���� ����
-- NonClustered�� ���, �����Ͱ� Leaf Page�� ����
-- ���� �� �� �� Ÿ�� ������
		-- 1) RID -> Heap Table (Bookmark Lookup)
		-- 2) Key -> Clustered

SELECT *
INTO TestOrders
FROM Orders;

SELECT *
FROM TestOrders;

CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID);

-- �ε��� ��ȣ
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrders');
-- ��ȸ
DBCC IND('Northwind', 'TestOrders', 2);

DBCC PAGE('Northwind', 1, 1136, 3);

--      1168
-- 1128 1136 1137
-- Heap Table[ {Page} {Page} ]

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- �⺻ Ž��
SELECT *
FROM TestOrders
WHERE CustomerID = 'QUICK';

-- �⺻ Ž��(���� �ε��� ���)
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK';

SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

DROP INDEX TestOrders.Orders_Index01;

-- ����� ���̱� ���� �õ� 1 ==================================================================
-- Covered Index
CREATE NONCLUSTERED INDEX Orders_Index02
ON TestOrders(CustomerID, ShipVia);

-- 8�� ��� �õ� -> 8�� �ξ��� ã��
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index02))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- Q) �׷� ����1 AND ����2 �ʿ��ϸ�, ������ INDEX(����1, ����2)�� �߰����ָ� �嶯?
-- A) NO! �� �׷����� �ʴ�. --> �˻��� �������� DML����(Insert, Update, Delete) �۾� ���ϰ� ����

DROP INDEX TestOrders.Orders_Index02;

-- ����� ���̱� ���� �õ� 2 ==================================================================
CREATE NONCLUSTERED INDEX Orders_Index03
ON TestOrders(CustomerID) INCLUDE (ShipVia); -- Leaf Page�� ShipVia�� ���� ������ ��� �ְڴٴ� ��
--     1
-- 2[(data1(ShipVia = 3), data2(ShipVia = 2), ... , data28)] 3 4 5 6 
-- ������ ������ ���� X

SELECT *
FROM TestOrders WITH(INDEX(Orders_Index03))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- ���� ���� ��¿��� ���� ���ٸ�
-- Clustered Index Ȱ���� ������ �� �ִ�. -> ���� ȿ������ ������ �ɾ��ִ°� ����
-- ������ Clustered Index�� ���̺��� 1���� ��밡��

-- ��� --

-- NonClustered Index�� �ǿ����� �ִ� ���?
	-- �ϸ�ũ ����� �ɰ��� ���ϸ� �߱��� ��
-- ���?
	-- �ɼ� 1) Covered Index (�˻��� ��� �÷��� ����)
	-- �ɼ� 2) Index���ٰ� Include�� ��Ʈ�� �����
	-- �ɼ� 3) Clustered ���� (��, 1���� ����) -> NonClustered �ǿ����� �� �� ����

	-- qq) RID�� �˻�1���� ����1�������� seek�� ��ü�� 1��?


	
SELECT *
INTO quickTest01
FROM Orders;

SELECT *
FROM quickTest01
WHERE CustomerID = 'QUICK';

SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('quickTest01');
-- ��ȸ
DBCC IND('Northwind', 'quickTest01', 2);

DBCC PAGE('Northwind', 1, 1136, 3);


-- =================================================================================================
-- =================================================================================================

-- ���� �ε��� �÷� ����
-- Index(A, B, C)

-- NonClustered
--     1
-- 2 3 4 5 6

-- Clustered
--     1
-- 2 3 4 5 6

-- Heap Table[ {Page} {Page} ]

-- �ϸ�ũ ���
-- Leaf Page Ž���� ������ ����
-- [����, ����] �ε��� (56 ~ 60 �޸�) - ��ĵ���� �о�����

SELECT *
INTO quickTest02
FROM Orders;

DECLARE @i INT = 1;
DECLARE @emp INT;
SELECT @emp = MAX(EmployeeID) FROM Orders;

-- ���� ������ �ø���
WHILE (@i < 1000)
BEGIN
	INSERT INTO quickTest02(CustomerID, EmployeeID, OrderDate)
	SELECT CustomerID, @emp + @i, OrderDate
	FROM Orders;
	SET @i = @i + 1;
END

SELECT COUNT(*)
FROM quickTest02;

CREATE NONCLUSTERED INDEX idx_emp_ord
ON quickTest02(EmployeeID, OrderDate);

CREATE NONCLUSTERED INDEX idx_ord_emp
ON quickTest02(OrderDate, EmployeeID);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- �ΰ� ��
SELECT *
FROM quickTest02 WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate = '19970101';

SELECT *
FROM quickTest02 WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');

-- ���� ���캸��
SELECT *
FROM quickTest02
ORDER BY EmployeeID, OrderDate;

SELECT *
FROM quickTest02
ORDER BY OrderDate, EmployeeID;

-- ������ ã�´ٸ�?
SELECT *
FROM quickTest02 WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate >= '19970101' AND OrderDate <= '19970103';

SELECT *
FROM quickTest02 WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103';

-- [!] Index(a, b, c)�� �����Ǿ��� ��, ���࿡ between�� ����ϸ� => ������ �ε��� ����� ��������.
-- �׷� BETWEEN ���� �񱳰� �����ϸ� �ε��� ������ ������ �ٲ��ָ� OK? -> NO

-- BETWEEN ������ ���� �� ->IN - LIST�� ��ü�ϴ� ���� ����(��ǻ� ������ �񱳿���)
SET STATISTICS PROFILE ON;

SELECT *
FROM quickTest02 WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate IN('19970101' ,'19970102', '19970103');
-- ������ �������� ���� 1���� �˻��ϴ°� ������ �����°� ����

-- ��� --

-- 1) ���� �÷� �ε��� (����, ����) ������ ������ �� �� ����
-- 2) BETWEEN, �ε�ȣ ���࿡ ����, ������ �ε��� ��� ���
--		2�� ��Ȳ����) BETWEEN ������ ������ IN - LIST�� ��ü�ϸ� ���� ��쵵 �ִ�.
