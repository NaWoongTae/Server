
-- 데이터베이스 제작
-- Schema라고도 함
CREATE DATABASE GameDB;

USE GameDB;

-- 테이블 생성(CREATE)/삭제(DROP)/변경(ALTER)
-- CREATE TABLE 테이블명(열이름 자료형 [DEFAULT 기본값] [NULL | NOT NULL], ... )

CREATE TABLE accounts(
	accountId INTEGER NOT NULL,
	accountName VARCHAR(10) NOT NULL,
	coins INTEGER DEFAULT 0,
	createdTime DATETIME
);

SELECT *
FROM accounts;

-- 테이블 삭제
DROP TABLE accounts;

-- 테이블 변경(ALTER)
-- 열 추가(ADD)/삭제(DROP)/변경(ALTER)
ALTER TABLE accounts
ADD lastEnterTime DATETIME;

ALTER TABLE accounts
DROP COLUMNlastEnterTime;

ALTER TABLE accounts
ALTER COLUMN accountName VARCHAR(20) NOT NULL;

-- 제약(CONSTRAINT) 추가/삭제
-- NOT NULL
-- UNIQUE
-- PRIMARY KEY ☆☆☆
-- FOREIGN KEY

ALTER TABLE accounts
ADD PRIMARY KEY(accountId);

ALTER TABLE accounts
ADD CONSTRAINT PK_account PRIMARY KEY (accountId); -- PRIMARY KEY에 이름을 지어줘서 해당이름으로 삭제할 수 있도록함

ALTER TABLE accounts
DROP CONSTRAINT PK_account; -- PRIMARY KEY 생성시 정한 이름으로 삭제가능


SELECT *
FROM accounts
WHERE accountId = 1111;

-- PRIMARY KEY는 C#의 다음과 비슷하다
-- LIST<Account>
-- DIctionary<int, Account>

-- 인덱스 CREATE INDEX / DROP INDEX

CREATE INDEX i1 ON accounts(accountName);
CREATE INDEX i1 ON accounts(accountName, coins);
CREATE UNIQUE INDEX i1 ON accounts(accountName);

DROP INDEX accounts.i1;

CREATE CLUSTERED INDEX i1 ON accounts(accountName);

INSERT INTO accounts 
Values (1, N'가', 10, CURRENT_TIMESTAMP);

-- JOIN ===========================================================
-- JOIN(결합)

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

-- CROSS JOIN (교차 결합) : 데이터 전부 교차
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

-- INNER JOIN (두 개의 테이블을 가로로 결합 + 결합 기준을 ON으로)
-- 한쪽이라도 정보가 없으면 걸러진다.

SELECT *
FROM players
	INNER JOIN salaries
	ON players.playerID = salaries.playerID;

-- OUTER JOIN (외부 결합)
-- LEFT / RIGHT
-- 어느 한쪽에만 존재하는 데이터 -> 정책?

-- LEFT JOIN(두개의 테이블을 가로로 결합 + 결합 기준을 ON으로)
-- LEFT의 데이터에 RIGHT를 갖다 붙이기 -- 없으면 데이터는 NULL로 채움
SELECT *
FROM players
	LEFT JOIN salaries
	ON players.playerID = salaries.playerID;

-- RIGHT의 데이터에 LEFT를 갖다 붙이기 -- 없으면 데이터는 NULL로 채움
SELECT *
FROM players
	RIGHT JOIN salaries
	ON players.playerID = salaries.playerID;