USE BaseballData;


-- 조인 원리
	-- 1) Nested Loop (NL) 조인
	-- 2) Merge (병합) 조인
	-- 3) Hash (해시) 조인

-- 2) Merge (병합) 조인
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;
	
-- 3) Hash (해시) 조인
SELECT *
FROM salaries AS s
	INNER JOIN teams AS t
	ON s.teamID = t.teamID;

-- 1) Nested Loop (NL) 조인
SELECT TOP 5 *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID

SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(LOOP JOIN); -- 강제

SELECT *
FROM salaries AS s
	INNER JOIN players AS p
	ON p.playerID = s.playerID
	OPTION(LOOP JOIN); -- 강제

SELECT *
FROM players AS p				--< OUTER
	INNER JOIN salaries AS s	--< INNER
	ON p.playerID = s.playerID
	OPTION(FORCE ORDER, LOOP JOIN); -- 강제

-- 결론 --
-- NL 특징
-- 먼저 엑세스한 (OUTER)테이블의 로우를 차례 차례 -> (INNER) 테이블에 랜덤 엑세스
-- (INNER) 테이블에 인덱스가 없으면 노답
-- 부분범위 처리에 좋다 (ex. TOP 5)


-- ===========================================================================
-- ===========================================================================

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- Merge(병합) 조인 = Sort Merge(정렬 병합) 조합

SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;

-- One-To-Many (outer가 unique해야함)
-- Merge 조인도 조건이 붙음
-- 일일히 Random Access -> Clustered Scan 후 정렬

SELECT *
FROM schools AS s
	INNER JOIN schoolsplayers AS p
	ON s.schoolID = p.schoolID;
		-- s.schoolID가 Primary Key로 이미 정렬됨ㅁ

-- 결론 --
-- Merge -> Sort Merge 조인
-- 1) 양쪽 집합을 Sort(정렬)하고 Merge(병합)한다
	-- 이미 정렬된 상태라면 Sort 생략 (특히, Clustered로 물리적 정렬된 상태라면 Best)
	-- 정렬할 데이터가 너무 많으면 GG -> Hash
-- 2) Random Access 위주로 수행되진 않는다.
-- 3) Many-to-Many(다대다)보다는 One-to-Many(일대다) 조인에 효과적
	-- PK, UNIQUE 효율


-- ===========================================================================
-- ===========================================================================
USE Northwind;

-- Hash(해시) 조인

SELECT * INTO quickTest03 FROM Orders;
SELECT * INTO quickTest04 FROM Customers;

SELECT * FROM quickTest03; -- 832
SELECT * FROM quickTest04; -- 93

-- 이전 복습

-- NL 사용시 문제점 : (inner 테이블에 인덱스가 없다)
SELECT *
FROM quickTest03 AS o
	INNER JOIN quickTest04 AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, LOOP JOIN);

-- Merge 사용시 문제점 : (outer, inner 모두 Sort 필요 => Many-To-Many)
SELECT *
FROM quickTest03 AS o
	INNER JOIN quickTest04 AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, MERGE JOIN);

-- ==================================

-- HASH - 아무런 인덱스가 없을때
SELECT *
FROM quickTest03 AS o				
	INNER JOIN quickTest04 AS c
	ON o.CustomerID = c.CustomerID;
	-- 더 적은 인덱스를 가진 테이블로 HashTable을 만들어서 나머지와 비교
	-- hashTable을 만드는것도 오버헤드 -> 테이블이 크면 그만큼 오버헤드 커짐

-- 결론 --

-- Hash 조인
	-- 1) 정렬이 필요하지 않다 -> 데이터가 너무 많아서 Merge가 부담스러울때, Hash가 대안이 될 수 있음
	-- 2) 인덱스 유무에 영향을 받지 않는다 *****
		-- NL/Merge에 비해 확실한 장점!
		-- HashTable 만드는 비용을 무시하면 안됨(수행빈도가 많으면 -> 결국 Index)
	-- 3) 랜덤 엑세스 위주로 수행되지 않음
	-- 4) 데이터가 적은 쪽을 HashTable로 만드는 것이 유리하다!

	
-- ===========================================================================
-- ===========================================================================

USE BaseballData;

-- Sorting (정렬)을 줄이자!

-- O(NLogN) -> DB는 데이터가 어마어마
-- 너무 용량이 커서 가용 메모리로 커버가 안 되면 -> 디스크까지 찾아가 저장하고 뭐하고~
-- Sorting이 언제 일어나는지 파악하고 있어야 함 *****

-- Sorting이 일어날 때
	-- 1) Sort Merge Join
		-- 원인) 알고리즘 특성상 Merge전 Sort를 해야함
	-- 2) ORDER BY
	-- 3) GROUP BY
	-- 4) DISTINCT
	-- 5) UNION
	-- 6) RANKING WINDOWS FUNCTION
	-- 7) MIN MAX

-- 1) 생략
-- 2) ORDER BY
	-- 원인) 순서대로 정렬 해야 하니까 Sort
SELECT *
FROM players
ORDER BY college;

SELECT *
FROM batting
ORDER BY playerID, yearID; -- 인덱스가 있기때문에 Sort하지않음

-- 3) GROUP BY
	-- 원인) 집계를 하기 위해
SELECT college, COUNT(college)
FROM players
WHERE college LIKE 'C%'
GROUP BY college;

-- 4) DISTINCT - 중복제거
	-- 원인) 중복제거를 위해
SELECT DISTINCT college
FROM players
WHERE college LIKE 'C%'

-- 5) UNION
	-- 원인) 첫째그룹과 둘째그룹의 요소가 겹칠경우 중복제거
SELECT college
FROM players
WHERE college LIKE 'C%'
UNION
SELECT college
FROM players
WHERE college LIKE 'D%'

-- 첫째그룹과 둘째그룹이 확실하게 겹치는 요소가 없다고 판단될때는 UNION ALL
SELECT college
FROM players
WHERE college LIKE 'C%'
UNION ALL
SELECT college
FROM players
WHERE college LIKE 'D%'

-- 6) RANKING WINDOWS FUNCTION
	-- 원인) 집계를 위해
SELECT ROW_NUMBER() OVER (ORDER BY college)
FROM players;

-- 7) MIN MAX
	-- 생략

-- 결론 --

-- INDEX를 잘 활용하면, Sorting을 굳이 하지 않아도 된다.

-- ===========================================================================
-- ===========================================================================

-- LOCK

-- 1) Shared
	-- READ (SELECT)
-- 2) Exclusive
	-- DML (INSERT, UPDATE, DELETE)
-- 3) Update
	-- Shared와 Exclusive 중간


-- LOCK 범위
	-- (<<- 락 범위가 작음(병렬처리에 이점))
	-- ROW - PAGE - INDEX - TABLE - DATABASE
	-- (->> 자원소모가 덜함)

-- SQL에서도 DEADLOCK 발생가능?
-- 가능
	-- 무한하게 대기하진 않고 한쪽이 롤백

-- TRANSACTION의 특성 ACID

-- 1) A (Atomicity)
	-- 원자성 - 전부되거나 전부 안되거나
	-- ex) 플레이어 골드 감소 + 아이템 인벤토리 추가

-- 2) C (Consistency) 
	-- 일관성 - 데이터간 일관성 보장 (데이터 인덱스 불일치 등)

-- 3) I (Isolation)
	-- 고립성 - 트랜잭션을 단독으로 실행하거나, 다른 트랜잭션과 같이 실행하거나 같은 결과

-- 4) D (Durability)  
	-- 지속성 - 장애가 발생하더라도 데이터는 반드시 복구가능
	-- 유사시를 대비해 로그를 남기자
	-- ex) 해야하는 로그도 남기고 어디까지 했는지도 남기고 비교 --> 어마어마한 로그


-- 1) 실제 데이터를 바로 하드디스크에 반영하진 않고, 로그를 이용
-- 2) REDO(before -> after) UNDO(after -> before)
-- 3) 미래로 간다 (Roll Forward)
-- 4) 과거로 간다 (Roll Back)
-- 5) 데이터비이스 장애 발생하더라도 로그를 이용해 복구/롤백