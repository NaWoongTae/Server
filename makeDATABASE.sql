
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