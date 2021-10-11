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