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
-- FROM -> WHERE -> GROUP BY-> SELECT -> ORDER BY 동작순서
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

-- SubQuery ==========================================================================
-- 서브쿼리/하위쿼리
-- SQL 명령문 안에 지정하는 하부 SELECT

-- 연봉이 역대급으로 높은 선수의 정보를 추출
SELECT TOP 1 *
FROM salaries
ORDER BY salary DESC;

-- 1등(rodrial101)을 찾고 -> 다시 1등의 정보를 찾아야함
SELECT *
FROM players
WHERE playerID = 'rodrial01';

-- 한번에 하려면? 
-- => 단일행 서브쿼리
SELECT *
FROM players
WHERE playerID = (SELECT TOP 1 playerID FROM salaries ORDER BY salary DESC); 

-- => 다중행 서브쿼리
SELECT *
FROM players
-- WHERE playerID = (SELECT TOP 20 playerID FROM salaries ORDER BY salary DESC); -- 단일 = 다중 비교
WHERE playerID IN (SELECT TOP 20 playerID FROM salaries ORDER BY salary DESC);

-- 서브쿼리는 WHERE에서 가장 많이 사용되지만 , 나머지 구문에서도 사용가능
SELECT (SELECT COUNT(*) FROM players) AS pCount, (SELECT COUNT(*) FROM batting) AS bCount;

-- INSERT에서도 가능
SELECT *
FROM salaries
ORDER BY yearID DESC;

-- INSERT INTO ~ VALUES / INSERT INTO ~ SELECT 비슷함
INSERT INTO salaries
VALUES (2021, 'JAP', 'NL', 'voo', (SELECT MIN(salary) FROM salaries));

INSERT INTO salaries
SELECT 2021, 'JAP', 'NL', 'roo', (SELECT MIN(salary) FROM salaries));

-- INSERT INTO ~ SELECT ~ 의 다른용도
SELECT *
FROM salaries_temp
ORDER BY yearID DESC;

INSERT INTO salaries_temp
SELECT yearID, playerID, salary FROM salaries;

-- 상관관계 서브쿼리
-- EXISTS, NOT EXISTS 존재 유무
-- 당장 자유자재로 사용은 못해도 되니까 -> 기억만

-- 포스트 시즌 타격에 참여한 선수들 목록
SELECT *
FROM players
WHERE playerID IN 
	(SELECT playerID FROM battingpost ); 

SELECT *
FROM players
WHERE EXISTS (SELECT playerID FROM battingpost WHERE battingpost.playerID = players.playerID); -- 상관관계에서는 단일행 실행불가

-- ctrl + L 성능비교

-- ===========================================================
-- RDBMS (Relational 관계형)
-- 데이터를 집합으로 간주

-- 복수의 테이블을 다루는 방법

-- 커리어 평균 연봉이 3000000 이상인 선수 playerID
SELECT playerID, AVG(salary)
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000

-- 12월에 태어난 선수들의 playerID
SELECT playerID, birthMonth
FROM players
WHERE birthMonth = 12;

-- [커리어 평균 연봉이 3000000 이상] || [12월에 태어난 선수]들의 playerID

-- UNION (자동 중복 제거) || OR
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000

UNION

SELECT playerID
FROM players
WHERE birthMonth = 12;

-- UNION ALL (중복 허용) || OR
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000

UNION ALL

SELECT playerID
FROM players
WHERE birthMonth = 12

ORDER BY playerID;

-- [커리어 평균 연봉이 3000000 이상] && [12월에 태어난 선수]들의 playerID

-- INTERSECT && AND
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000

INTERSECT

SELECT playerID
FROM players
WHERE birthMonth = 12

ORDER BY playerID;

-- [커리어 평균 연봉이 3000000 이상] - [12월에 태어난 선수]들의 playerID

-- EXCEPT A - B
SELECT playerID
FROM salaries
GROUP BY playerID
HAVING AVG(salary) >= 3000000

EXCEPT

SELECT playerID
FROM players
WHERE birthMonth = 12

ORDER BY playerID;

