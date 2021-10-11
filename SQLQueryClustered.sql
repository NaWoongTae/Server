USE Northwind;

-- �ε��� ����
-- Clustered(���� ����) vs Non-Clustered(����)

-- Clustered
	-- Leaf Page = Data Page
	-- �����ʹ� Clustered Index Ű ������ ����

-- Non-Clustered ? (��� Clustered Index ������ ���� �ٸ��� ����)
-- 1) Clustered Index�� ���� ���
	-- Clustered Index�� ������ �����ʹ� Heap Table�̶�� ���� ����
	-- Heap RID -> Heap Table�� ���� ������ ����
	
-- 2) Clustered Index�� �ִ� ���
	-- Heap Table�� ����. Leaf Table�� ���� �����Ͱ� ���ִ�
	-- Clustered Index�� ���� Ű ���� ��� �ִ�

-- �ӽ� �׽�Ʈ ���̺��� ����� ������ ������
SELECT *
INTO TestOrderDetails
FROM [Order Details];

SELECT *
FROM TestOrderDetails;

-- �ε��� �߰�
CREATE INDEX Index_OrderDetails
ON TestOrderDetails(OrderID, ProductId);

-- �ε��� ����
EXEC sp_helpindex 'TestOrderDetails';
-- �ε��� ��ȣ ã��
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrderDetails');

-- ��ȸ
DBCC IND('Northwind', 'TestOrderDetails', 0);
DBCC IND('Northwind', 'TestOrderDetails', 1);
DBCC IND('Northwind', 'TestOrderDetails', 2);

-- Heap RID ([������ �ּ�(4)][����ID(2)][������(2)] Row)
DBCC PAGE('Northwind', 1, 944, 3);
-- PageType 1(DATA PAGE) 2(INDEX PAGE)

-- Clustered �ε��� �߰�
CREATE CLUSTERED INDEX Index_OrderDetails_Clustered
ON TestOrderDetails(OrderID);

DBCC PAGE('Northwind', 1, 1016, 3);

-- ��ȸ
DBCC IND('Northwind', 'TestOrderDetails', 1); -- root 968
DBCC PAGE('Northwind', 1, 968, 3);

DBCC PAGE('Northwind', 1, 930, 3);

-- ===================================================================================
-- ===================================================================================

-- �ε��� ���� ��� (Access)
-- Index Scan vs Index Seek

CREATE TABLE TestAccess
(
	id INT NOT NULL,
	name NCHAR(50) NOT NULL,
	dummy NCHAR(1000) NOT NULL
);
GO

CREATE CLUSTERED INDEX TestAccess_CI
ON TestAccess(id);
GO

CREATE NONCLUSTERED INDEX TestAccess_NCI
ON TestAccess(name);
GO

DECLARE @i INT;
SET @i = 1;

WHILE (@i <= 500)
BEGIN
	INSERT INTO TestAccess
	VALUES (@i, 'Name' + CONVERT(VARCHAR, @i), 'Hello World' + CONVERT(VARCHAR, @i * @i));
	SET @i = @i + 1;
END

-- ���̺�
SELECT * FROM TestAccess;

-- �ε��� ����
EXEC sp_helpindex 'TestAccess';

-- �ε��� ��ȣ
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestAccess');

-- ��ȸ
DBCC IND ('Northwind', 'TestAccess', 1);
DBCC IND ('Northwind', 'TestAccess', 2);

-- CLUSTERED(1) : id
-- 857
-- 856 ~ 1127

-- NON CLUSTERED(2) : name
-- 865
-- 864 ~ 1061

-- ���� �б� -> ���� �����͸� ã�� ���� ���� ��������
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- INDEX SCAN - ��ü 167��
SELECT * FROM TestAccess;

-- INDDEX SEEK
-- Ŭ�����͵� ��ȸ -> ��Ʈ(1) + ����(1) = ���� �б� 2��
SELECT * FROM TestAccess
WHERE id = 104;

-- INDDEX SEEK + KEY LOOKUP
-- �� Ŭ�����͵� ��ȸ -> Data?Index? Page ��Ʈ(1) + ����(1) => Ŭ�����͵� Ű ���� => Ŭ�����͵� ��ȸ -> ��Ʈ(1) + ����(1) = ���� �б� 4��
SELECT * FROM TestAccess
WHERE name = 'name104';

-- INDDEX SCAN + KEY LOOKUP
-- ORDER BY + TOP ���� ���� �б� Ƚ�� ����
SELECT TOP 5 * 
FROM TestAccess
ORDER BY name;