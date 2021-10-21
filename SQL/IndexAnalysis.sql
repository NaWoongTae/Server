USE Northwind;

-- DB ���� ���캸��
EXEC sp_helpdb 'Northwind'

-- INDEX ����

-- �ӽ� ���̺� ����� (�ε��� �׽�Ʈ��)
CREATE TABLE Test
(
	EmployeeID	INT NOT NULL,
	LastName	NVARCHAR(20) NULL,
	FirstName	NVARCHAR(20) NULL,
	HireDate	DATETIME NULL
);
GO

INSERT INTO Test
SELECT EmployeeID, LastName, FirstName, HireDate
FROM Employees;

SELECT *
FROM Test;

-- FILLFACTOR (���� ������ ���� 1%�� ���) -> (�׽�Ʈ��) ������ ��������� ����ؼ� Ʈ�����������
-- PAD_INDEX (FILLFACTOR �߰� ������ ����)
CREATE INDEX Test_Index ON Test(LastName)
WITH (FILLFACTOR = 1, PAD_INDEX = ON);
GO

drop index Test_Index ON Test;

-- �ε��� ��ȣ ã��
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('Test');

-- �ش��ϴ� 2�� �ε��� ���� ���캸��
DBCC IND('Northwind', 'Test', 2);

-- indexLevel
-- Root(2) -> Branch(1) -> Leaf(0)

--  (2��)            849
--  (1��)      872         848       <-�� ������ NextPageFID ~ PrevPagePID���� ������ ������ �� �ִ�.
--  (0��)   832   840   841

-- Table[ {Page} {Page} {Page} {Page} {Page} ]

-- HEAP RID([�������ּ�(4)][����ID(2)][���Թ�ȣ(2)]) == 8byte  ������ ROW �ĺ���. ���̺��� ���� ����
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 832/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 840/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 841/*��������ȣ*/, 3/*��¿ɼ�*/);

DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 849/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 872/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 848/*��������ȣ*/, 3/*��¿ɼ�*/);

-- Random Access (�Ѱ� �б� ���� �� �������� ����)
-- Bookmark Lookup (RID�� ���� ���� ã�´�)