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

-- CASE ==========================================================================
-- 방식 1
SELECT birthYear, birthMonth, birthDay, 
	CASE birthMonth
		WHEN 1 THEN N'겨울'
		WHEN 2 THEN N'겨울'
		WHEN 3 THEN N'봄'
		WHEN 4 THEN N'봄'
		WHEN 5 THEN N'봄'
		WHEN 6 THEN N'여름'
		WHEN 7 THEN N'여름'
		WHEN 8 THEN N'여름'
		WHEN 9 THEN N'여름'
		WHEN 10 THEN N'가을'
		WHEN 11 THEN N'가을'
		WHEN 12 THEN N'겨울'
		ELSE N'제5계절'
	END AS birthSeason
FROM players;

-- 방식 2
SELECT birthYear, birthMonth, birthDay, 
	CASE 
		WHEN birthMonth <= 2 THEN N'겨울'
		WHEN birthMonth <= 5 THEN N'봄'
		WHEN birthMonth <= 9 THEN N'여름'
		WHEN birthMonth <= 11 THEN N'가을'
		WHEN birthMonth IS NULL THEN N'뭘까'
		ELSE N'겨울'
	END AS birthSeason
FROM players;

-- 집계 ==========================================================================
-- COUNT SUM AVG MIN MAX

SELECT COUNT(*) -- *를 사용할 수 있는 애는 COUNT만
FROM players

SELECT COUNT(birthYear)
FROM players

-- 집계함수는 집합이 null이면 무시

-- 중복제거
SELECT DISTINCT birthCity
FROM players
ORDER BY birthCity;

-- 여러개에 사용시 DISTINCT (birthYear, birthMonth, birthDay)와 같은 조합형식으로 중복을 체크한다.
SELECT DISTINCT birthYear, birthMonth, birthDay 
FROM players
ORDER BY birthYear;

-- 중복제거된 개수는? => 집계(DISTINCT)
SELECT COUNT(DISTINCT birthCity)
FROM players

-- 평균 weight
SELECT AVG(weight)
FROM players;

SELECT SUM(weight) / COUNT(weight)
FROM players;

-- NULL 데이터에 기본값을 적용
SELECT AVG
	(CASE 
		WHEN weight IS NULL THEN 0
		ELSE weight
	END)
FROM players;

-- MIN MAX - 날짜에도 가능
SELECT MIN(weight) AS minWeight, MAX(weight) AS maxWeight
FROM players