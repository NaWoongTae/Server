USE BaseballData;

/* 여러줄 주석 */
-- 한줄 주석

-- SQL (RDBMS를 조작하기 위한 명령어)
-- +@ T-SQL

-- CRUD (Create-Read-Update-Delete)

-- NULL 체크 ==========================================================================
SELECT *
FROM players
WHERE deathYear IS NULL

-- NULL비교 IS NULL / IS NOT NULL

SELECT playerID as 이름, birthYear, nameLast, birthCountry
FROM players
where birthCountry != 'USA' AND birthYear > 1980

-- SELECT -> FROM -> WHERE -> ORDER BY 사용순서
-- FROM -> WHERE -> SELECT -> ORDER BY 동작순서
-- 대소문자 상관 없음
-- AND OR - (AND문 우선)

-- 문자열 ==========================================================================
SELECT *
FROM players
WHERE nameLast LIKE 'A___'

-- % 임의의 문자열
-- _ 임의의 문자 1개 (여러개 가능)

-- 정렬 ==========================================================================
SELECT TOP 1 PERCENT *
FROM players
WHERE birthYear IS NOT NULL AND birthMonth IS NOT NULL AND birthDay IS NOT NULL
ORDER BY birthYear ASC, birthMonth, birthDay

-- ASC DESC (생략가능)

-- SELECT TOP 10 *           : 탑 N
-- SELECT TOP 1 PERCENT *    : 탑 N%
-- T SQL용 문법임

SELECT *
FROM players
ORDER BY lahmanID
OFFSET 100 ROWS FETCH NEXT 10 ROWS ONLY;

-- 중간 값만 가져오기
-- OFFSET 100부터 NEXT 10만큼
-- ORDER BY절 필수

-- 수치 연산 ==========================================================================
-- + - * / %
-- NULL과의 연산 = NULL
SELECT nameFirst, 2022 - birthYear AS koreanAge
FROM players
WHERE birthYear > 1950 AND deathYear IS NULL AND birthYear IS NOT NULL
ORDER BY koreanAge

SELECT 3 / 2 -- 1
SELECT 3.0 / 2 -- 1.5
SELECT 3 / 2.0 -- 1.5

-- 문자열 ==========================================================================

SELECT 'HELLO' -- ''사용시 문자 하나당 1Byte
SELECT N'안녕'  -- 유니코드 사용시 앞에 N

SELECT 'hello' + 'world'
SELECT SUBSTRING('20210929' ,1 ,4) -- 시작이 0이 아닌 1
SELECT TRIM('         SPACE             ') -- 스페이스 날리기

SELECT nameFirst + ' ' + nameLast AS fullName, 2022 - birthYear AS koreanAge
FROM players
WHERE nameFirst IS NOT NULL AND nameLast IS NOT NULL

-- DATETIME ==========================================================================
-- DATE 연/월/일
-- TIME 시/분/초
-- DATETIME 연/월/일/시/분/초
SELECT nameFirst + ' ' + nameLast AS fullName, debut, finalGame
FROM players