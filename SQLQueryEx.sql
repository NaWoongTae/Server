
/* 여러줄 주석 */
-- 한줄 주석

-- SQL (RDBMS를 조작하기 위한 명령어)
-- +@ T-SQL

-- CRUD (Create-Read-Update-Delete)

SELECT *
FROM players
WHERE deathYear IS NULL

-- NULL비교 IS NULL / IS NOT NULL

SELECT playerID as 이름, birthYear, nameLast, birthCountry
FROM players
where birthCountry != 'USA' AND birthYear > 1980

-- SELECT -> FROM -> WHERE 순서
-- 대소문자 상관 없음
-- AND OR - (AND문 우선)

SELECT *
FROM players
WHERE nameLast LIKE 'A___'

-- % 임의의 문자열
-- _ 임의의 문자 1개 (여러개 가능)