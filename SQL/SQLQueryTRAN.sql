use GameDB;

-- TRANSACTION

SELECT *
FROM accounts;

-- BEGIN TRAN;
-- COMMIT;
-- ROLLBACK;

-- �ŷ�
-- A�� �κ����� �� ����
-- B�� �κ����� �� �߰�
-- B�� ��尨��

-- �ŷ�, ��ȭ�� ALL OR NOTHING
-- ���� �ǰų� ���� �ȵǾ���

-- TRAN ������� ������ �ڵ����� COMMIT
INSERT INTO accounts VALUES(9, N'��', 11, GETUTCDATE());

-- ���� BEGIN TRAN
-- �������ΰ� COMMIT;
-- ��� ROLLBACK;

-- ����/���� ���ο� ���� COMMIT (= COMMIT�� �������� �ϰڴ�)
BEGIN TRAN;
	INSERT INTO accounts VALUES(10, N'A', 12, GETUTCDATE());
ROLLBACK;

BEGIN TRAN;
	INSERT INTO accounts VALUES(11, N'B', 13, GETUTCDATE());
COMMIT;

-- ���� + TRY CATCH
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO accounts VALUES(13, N'D', 15, GETUTCDATE());
		INSERT INTO accounts VALUES(12, N'C', 14, GETUTCDATE());
	COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 -- ���� Ȱ��ȭ�� Ʈ����� ���� ��ȯ	
	PRINT(@@TRANCOUNT);
		ROLLBACK;
	PRINT('ROLLBACK����');
END CATCH

/*BEGIN TRAN;
	INSERT INTO accounts VALUES(14, N'E', 15, GETUTCDATE());
COMMIT;
ROLLBACK;*/

-- TRAN ������
-- TRAN �ȿ��� ��!! ���������� ����� �ֵ鸸 �־ ���

BEGIN TRAN;
	INSERT INTO accounts VALUES(17, N'G', 16, GETUTCDATE());
-- ROLLBACK; COMMIT; ���� Ʈ����Ǹ� �ɾ���� ���¿����� => �ٸ� �������� �����Ϳ� �����Ҽ�����.
-- ��ġ LOCK �ɾ� ������ ó���ȴ�. ���� ���������� �����ѰͰ���.

SELECT *
FROM accounts;