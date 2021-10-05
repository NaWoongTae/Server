
-- �����ͺ��̽� ����
-- Schema��� ��
CREATE DATABASE GameDB;

USE GameDB;

-- ���̺� ����(CREATE)/����(DROP)/����(ALTER)
-- CREATE TABLE ���̺��(���̸� �ڷ��� [DEFAULT �⺻��] [NULL | NOT NULL], ... )

CREATE TABLE accounts(
	accountId INTEGER NOT NULL,
	accountName VARCHAR(10) NOT NULL,
	coins INTEGER DEFAULT 0,
	createdTime DATETIME
);

SELECT *
FROM accounts;

-- ���̺� ����
DROP TABLE accounts;

-- ���̺� ����(ALTER)
-- �� �߰�(ADD)/����(DROP)/����(ALTER)
ALTER TABLE accounts
ADD lastEnterTime DATETIME;

ALTER TABLE accounts
DROP COLUMNlastEnterTime;

ALTER TABLE accounts
ALTER COLUMN accountName VARCHAR(20) NOT NULL;

-- ����(CONSTRAINT) �߰�/����
-- NOT NULL
-- UNIQUE
-- PRIMARY KEY �١١�
-- FOREIGN KEY

ALTER TABLE accounts
ADD PRIMARY KEY(accountId);

ALTER TABLE accounts
ADD CONSTRAINT PK_account PRIMARY KEY (accountId); -- PRIMARY KEY�� �̸��� �����༭ �ش��̸����� ������ �� �ֵ�����

ALTER TABLE accounts
DROP CONSTRAINT PK_account; -- PRIMARY KEY ������ ���� �̸����� ��������


SELECT *
FROM accounts
WHERE accountId = 1111;

-- PRIMARY KEY�� C#�� ������ ����ϴ�
-- LIST<Account>
-- DIctionary<int, Account>

-- �ε��� CREATE INDEX / DROP INDEX

CREATE INDEX i1 ON accounts(accountName);
CREATE INDEX i1 ON accounts(accountName, coins);
CREATE UNIQUE INDEX i1 ON accounts(accountName);

DROP INDEX accounts.i1;

CREATE CLUSTERED INDEX i1 ON accounts(accountName);

INSERT INTO accounts 
Values (1, N'��', 10, CURRENT_TIMESTAMP);