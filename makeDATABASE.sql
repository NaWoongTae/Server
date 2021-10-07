
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

-- JOIN ===========================================================
-- JOIN(����)

CREATE TABLE testA
(
	a INTEGER
)
CREATE TABLE testB
(
	b VARCHAR(10)
)

-- A(1,2,3)
INSERT INTO testA VALUES(1);
INSERT INTO testA VALUES(2);
INSERT INTO testA VALUES(3);
DELETE testA;
--B('A','B','C')
INSERT INTO testB VALUES('A');
INSERT INTO testB VALUES('B');
INSERT INTO testB VALUES('C');

SELECT *
FROM testA;
SELECT *
FROM testB;

-- CROSS JOIN (���� ����) : ������ ���� ����
SELECT *
FROM testA
	CROSS JOIN testB;
SELECT *
FROM testB;

-----------------------

USE BaseballData;

SELECT *
FROM players
ORDER BY playerID;
SELECT *
FROM salaries
ORDER BY playerID;

-- INNER JOIN (�� ���� ���̺��� ���η� ���� + ���� ������ ON����)
-- �����̶� ������ ������ �ɷ�����.

SELECT *
FROM players
	INNER JOIN salaries
	ON players.playerID = salaries.playerID;

-- OUTER JOIN (�ܺ� ����)
-- LEFT / RIGHT
-- ��� ���ʿ��� �����ϴ� ������ -> ��å?

-- LEFT JOIN(�ΰ��� ���̺��� ���η� ���� + ���� ������ ON����)
-- LEFT�� �����Ϳ� RIGHT�� ���� ���̱� -- ������ �����ʹ� NULL�� ä��
SELECT *
FROM players
	LEFT JOIN salaries
	ON players.playerID = salaries.playerID;

-- RIGHT�� �����Ϳ� LEFT�� ���� ���̱� -- ������ �����ʹ� NULL�� ä��
SELECT *
FROM players
	RIGHT JOIN salaries
	ON players.playerID = salaries.playerID;