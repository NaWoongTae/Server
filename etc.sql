USE GameDB;

SELECT *
FROM accounts;

DROP INDEX accounts.i1;

ALTER TABLE accounts
DROP CONSTRAINT PK_ACC;

--CREATE UNIQUE CLUSTERED INDEX PK_ACC PRIMARY KEY(accountId);

ALTER TABLE accounts
ADD CONSTRAINT PK_2 PRIMARY KEY (accountName);

CREATE UNIQUE CLUSTERED INDEX PK_ACC ON accounts(accountId);
CREATE CLUSTERED INDEX PK_ACC ON accounts(accountId);
DROP INDEX accounts.PK_ACC;

EXEC sp_helpindex 'accounts';

-- PRIMARY KEY += UNIQUE

CREATE INDEX PK_3 ON accounts(accountId);
CREATE INDEX PK_ac2 ON accounts(accountName);

SELECT * FROM sys.indexes WHERE object_id = object_id('accounts');
SELECT * FROM sys.indexes WHERE type_desc = 'HEAP';
SELECT * FROM sys.indexes WHERE NAME IS NULL;

SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('accounts');

SELECT object_id('accounts');

DBCC IND('GameDB', 'accounts', 0); -- 0이랑 1이랑 결과 똑같음 / 왜지
DBCC IND('GameDB', 'accounts', 1); -- 89 280 // 앞의 숫자는 머임
DBCC IND('GameDB', 'accounts', 2); -- 118 432
DBCC IND('GameDB', 'accounts', 3); -- 119 440
DBCC IND('GameDB', 'accounts', 4); -- 120 448

SELECT * FROM sys.indexes WHERE object_id = object_id('accounts');
DBCC PAGE('GameDB', 1, 280, 3);
DBCC PAGE('GameDB', 1, 118, 3);
DBCC PAGE('GameDB', 1, 440, 3);

-- UNIQUE / PRIMARY KEY / 

SELECT *
INTO acc2
FROM [accounts];

SELECT * FROM acc2;

CREATE INDEX Ind1 ON acc2(accountId);
CREATE INDEX Ind2 ON acc2(accountName);
CREATE CLUSTERED INDEX cInd1 ON acc2(accountId);
ALTER TABLE acc2
ADD CONSTRAINT ac2Key PRIMARY KEY(accountId);
DROP INDEX acc2.cInd1;

EXEC sp_helpindex 'acc2';

SELECT * FROM sys.indexes WHERE object_id = object_id('acc2'); -- index_id (0 : Heap) (1 : CLUSTERED) (2~ : NON-CLUSTERED)

DBCC IND('GameDB', 'acc2', 0); -- 142 456
DBCC IND('GameDB', 'acc2', 1); -- 142 456
DBCC IND('GameDB', 'acc2', 2); -- 146 288 - index_id가 page type?

-- 145 456
-- 150 464

DBCC PAGE('GameDB', 1, 145, 3);
DBCC PAGE('GameDB', 1, 456, 3);
DBCC PAGE('GameDB', 1, 150, 3);
DBCC PAGE('GameDB', 1, 464, 3);

