USE Northwind;

-- 북마크 룩업

-- Index Scan vs Index Seek
-- Index Scan이 항상 나쁜 것은 아니고
-- Index Seek이 항상 좋은 것은 아니다
-- 인덱스를 활용하는데 어떻게 느릴 수가 있을까?

-- NonClustered
--     1
-- 2 3 4 5 6

-- Clustered
--     1
-- 2 3 4 5 6

-- Heap Table[ {Page} {Page} ]

-- Clustered의 경우 Index Seek이 느릴 수가 없다
-- NonClustered의 경우, 데이터가 Leaf Page에 없다
-- 따라서 한 번 더 타고 가야함
		-- 1) RID -> Heap Table (Bookmark Lookup)
		-- 2) Key -> Clustered

SELECT *
INTO TestOrders
FROM Orders;

SELECT *
FROM TestOrders;

CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID);

-- 인덱스 번호
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrders');
-- 조회
DBCC IND('Northwind', 'TestOrders', 2);

DBCC PAGE('Northwind', 1, 1136, 3);

--      1168
-- 1128 1136 1137
-- Heap Table[ {Page} {Page} ]

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- 기본 탐색
SELECT *
FROM TestOrders
WHERE CustomerID = 'QUICK';

-- 기본 탐색(강제 인덱스 사용)
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK';

SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

DROP INDEX TestOrders.Orders_Index01;

-- 룩업을 줄이기 위한 시도 1 ==================================================================
-- Covered Index
CREATE NONCLUSTERED INDEX Orders_Index02
ON TestOrders(CustomerID, ShipVia);

-- 8번 룩업 시도 -> 8번 꽝없이 찾음
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index02))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- Q) 그럼 조건1 AND 조건2 필요하면, 무조건 INDEX(조건1, 조건2)를 추가해주면 장땡?
-- A) NO! 꼭 그렇지는 않다. --> 검색은 빠르지만 DML연산(Insert, Update, Delete) 작업 부하가 증가

DROP INDEX TestOrders.Orders_Index02;

-- 룩업을 줄이기 위한 시도 2 ==================================================================
CREATE NONCLUSTERED INDEX Orders_Index03
ON TestOrders(CustomerID) INCLUDE (ShipVia); -- Leaf Page에 ShipVia에 대한 정보는 들고 있겠다는 뜻
--     1
-- 2[(data1(ShipVia = 3), data2(ShipVia = 2), ... , data28)] 3 4 5 6 
-- 데이터 순서에 영향 X

SELECT *
FROM TestOrders WITH(INDEX(Orders_Index03))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- 위와 같은 노력에도 답이 없다면
-- Clustered Index 활용을 고려할 수 있다. -> 가장 효율좋은 애한테 걸어주는게 좋음
-- 하지만 Clustered Index는 테이블당 1개만 사용가능

-- 결론 --

-- NonClustered Index가 악영향을 주는 경우?
	-- 북마크 룩업이 심각한 부하를 야기할 때
-- 대안?
	-- 옵션 1) Covered Index (검색할 모든 컬럼을 포함)
	-- 옵션 2) Index에다가 Include로 힌트를 남긴다
	-- 옵션 3) Clustered 고려 (단, 1번만 가능) -> NonClustered 악영향을 줄 수 있음

	-- qq) RID는 검색1번에 논리1번이지만 seek은 전체도 1번?


	
SELECT *
INTO quickTest01
FROM Orders;

SELECT *
FROM quickTest01
WHERE CustomerID = 'QUICK';

SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('quickTest01');
-- 조회
DBCC IND('Northwind', 'quickTest01', 2);

DBCC PAGE('Northwind', 1, 1136, 3);