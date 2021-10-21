USE BaseballData;

-- 윈도우 함수
-- 행들의 서브 집합을 대상으로, 각 행별로 계산을 해서 스칼라(단일 고정)값을 출력하는 함수

-- GROUPING과 비슷

-- ~OVER([PARTITION] [ORDER BY] [ROWS]) -> 3가지의 선택적 옵션이 있다.

-- 전체 데이터를 연봉순으로 나열, 순위 표기
SELECT *,
	ROW_NUMBER() OVER (ORDER BY salary DESC) AS ROW_NUMBER,	-- 행#번호
	RANK() OVER (ORDER BY salary DESC) AS RANK ,			-- 랭킹 : 공동순위시 다음순위는 안이어짐
	DENSE_RANK() OVER (ORDER BY salary DESC) AS DENSE_RANK,	-- 랭킹 : 공동순위시 다음순위는 이어짐
	NTILE(100) OVER (ORDER BY salary DESC) AS NTILE			-- 상위 몇%
FROM salaries

-- playerID 별 순위를 따로 하고 싶다면?
-- 연도별 홈런왕!

GO

SELECT * FROM (
SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY yearID ORDER BY HR DESC) AS ranking
FROM batting
) AS yearTable
WHERE ranking = 1
ORDER BY yearID DESC;

-- LAG(바로 이전), LEAD(바로 다음)
SELECT *,
	ROW_NUMBER() OVER (PARTITION BY yearID ORDER BY HR DESC) AS ranking,
	LAG(HR) OVER (PARTITION BY yearID ORDER BY HR DESC) AS prevHR,
	LEAD(HR) OVER (PARTITION BY yearID ORDER BY HR DESC) AS nextHR
FROM batting
ORDER BY yearID DESC

-- FIRST_VALUE, LAST_VALUE
-- FRAME : FIRST~CURRENT  -> 명시적으로 ROWS 를 표시하지 않으면 1번부터 현재행까지 범위
SELECT *,
	RANK() OVER (PARTITION BY yearID ORDER BY HR DESC) AS ranking,
	FIRST_VALUE(HR) OVER (PARTITION BY yearID ORDER BY HR DESC
							ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS best, -- 처음부터 나까지
	LAST_VALUE(HR) OVER (PARTITION BY yearID ORDER BY HR DESC 
							ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS worst -- 나부터 끝까지
FROM batting
ORDER BY yearID DESC