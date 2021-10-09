USE Northwind;

-- �ֹ� �� ������ ���캸��
SELECT *
FROM [Order Details] -- �̸��� ��ɾ�� ��ĥ���� [ �̸� ]
ORDER BY OrderID;

-- �ӽ� �׽�Ʈ ���̺��� ����� ������ ����
SELECT *
INTO TestOrderDetails
FROM [Order Details]; -- �ٷ� ����

SELECT *
FROM TestOrderDetails;

-- ���� �ε��� �߰�
CREATE INDEX Index_TestOrderDetails
ON TestOrderDetails(OrderID, ProductID); --> OrderID�� Index�˻��� �ϰ� '�ʿ���'��� ProductID�� Ȱ���ϴ°�����, ProductID�� ����� �� ���� (�� �ε��� �����׽�Ʈ 4��)
                                         -- ex) OrderID : 1�� Key - ProductID : 2�� Key

-- �ε��� ���� ���캸��
EXEC sp_helpindex 'TestOrderDetails'

-- (OrderId, ProductID)? OrderId? ProductID?
-- INDEX SCAN (INDEX FULL SCAN) -> BAD
-- INDEX SEEK -> GOOD

-- �ε��� ���� �׽�Ʈ 1 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248 AND productID = 11;

-- �ε��� ���� �׽�Ʈ 2 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE productID = 11 AND OrderID = 10248; -- ������ �ڹٲٴ� ������ ���������� �˾Ƽ� ����ȭ�ؼ� ����

-- �ε��� ���� �׽�Ʈ 3 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248;

-- �ε��� ���� �׽�Ʈ 4 -> BAD -> INDEX Ȱ������ ����
SELECT *
FROM TestOrderDetails
WHERE productID = 11;

--------------------------

-- INDEX ����
DBCC IND('Northwind', 'TestOrderDetails', 2);

DBCC PAGE('Northwind', 1, 856, 3);

-- ���� �ε���(A,B) ������̶��
--		  A �˻���	-> �ε���(A) ��� ����
-- ������ B �˻���	-> �ε���(B)�� ������ �ɾ���� ��

-- �ε����� �����Ͱ� �߰�/����/���� �����Ǿ�� ��

-- ������ 50���� ������ �־��
-- 10248/11 20387/24

DECLARE @i INT = 0;
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES (10248,100+@i,10,1,0)
	SET @i = @i + 1;
END

DBCC PAGE('Northwind', 1, 888, 3);
--> �翬������ �������� �����Ͱ� ��ġ�� �Ǹ� �������� ���� �����ؼ� �������� �ɰ���
-- ��� : ������ ���������� ���ٸ� -> ������ ����(SPLIT) �߻�

-- ���� �׽�Ʈ ==================================================================
SELECT LastName
INTO TestEmployees
FROM Employees;

SELECT * FROM TestEmployees;

-- �ε��� �߰�
CREATE INDEX Index_TestEmployees
ON TestEmployees(LastName);

-- INDEX SCAN -> BAD
SELECT *
FROM TestEmployees
WHERE SUBSTRING(LastName, 1, 2) = 'Bu'; -- INDEX ������ INDEX�� ã�� �� ����

-- INDEX SEEK
SELECT *
FROM TestEmployees
WHERE LastName LIKE 'Bu%';

-- ���
-- ���� �ε��� (A, B)�� ����� �� ���� ���� (A -> B ���� �˻�)
-- �ε��� ����, ������ �߰��� ���� ������ ������ ������ SPLIT
-- Ű ������ ����
