USE Northwind;

-- 인덱스 종류
-- Clustered(영한 사전) vs Non-Clustered(색인)

-- Clustered
	-- Leaf Page = Data Page
	-- 데이터는 Clustered Index 키 순서로 정렬

-- Non-Clustered ? (사실 Clustered Index 유무에 따라서 다르게 동작)
-- 1) Clustered Index가 없는 경우
	-- Clustered Index가 없으면 데이터는 Heap Table이라는 곳에 저장
	-- Heap RID -> Heap Table에 접근 데이터 추출
	
-- 2) Clustered Index가 있는 경우
	-- Heap Table이 없음. Leaf Table에 실제 데이터가 ㅇ있다
	-- Clustered Index의 실제 키 값을 들고 있다

-- 임시 테스트 테이블을 만들고 데이터 ㅂ복사
SELECT *
INTO TestOrderDetails
FROM [Order Details];

SELECT *
FROM TestOrderDetails;

-- 인덱스 추가
CREATE INDEX Index_OrderDetails
ON TestOrderDetails(OrderID, ProductId);

-- 인덱스 정보
EXEC sp_helpindex 'TestOrderDetails';
-- 인덱스 번호 찾기
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestOrderDetails');

-- 조회
DBCC IND('Northwind', 'TestOrderDetails', 0);
DBCC IND('Northwind', 'TestOrderDetails', 1);
DBCC IND('Northwind', 'TestOrderDetails', 2);

-- Heap RID ([페이지 주소(4)][파일ID(2)][슬ㄹ롯(2)] Row)
DBCC PAGE('Northwind', 1, 944, 3);
-- PageType 1(DATA PAGE) 2(INDEX PAGE)

-- Clustered 인덱스 추가
CREATE CLUSTERED INDEX Index_OrderDetails_Clustered
ON TestOrderDetails(OrderID);

DBCC PAGE('Northwind', 1, 1016, 3);

-- 조회
DBCC IND('Northwind', 'TestOrderDetails', 1); -- root 968
DBCC PAGE('Northwind', 1, 968, 3);

DBCC PAGE('Northwind', 1, 930, 3);

-- ===================================================================================
-- ===================================================================================

-- 인덱스 접근 방식 (Access)
-- Index Scan vs Index Seek

CREATE TABLE TestAccess
(
	id INT NOT NULL,
	name NCHAR(50) NOT NULL,
	dummy NCHAR(1000) NOT NULL
);
GO

CREATE CLUSTERED INDEX TestAccess_CI
ON TestAccess(id);
GO

CREATE NONCLUSTERED INDEX TestAccess_NCI
ON TestAccess(name);
GO

DECLARE @i INT;
SET @i = 1;

WHILE (@i <= 500)
BEGIN
	INSERT INTO TestAccess
	VALUES (@i, 'Name' + CONVERT(VARCHAR, @i), 'Hello World' + CONVERT(VARCHAR, @i * @i));
	SET @i = @i + 1;
END

-- 테이블
SELECT * FROM TestAccess;

-- 인덱스 정보
EXEC sp_helpindex 'TestAccess';

-- 인덱스 번호
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('TestAccess');

-- 조회
DBCC IND ('Northwind', 'TestAccess', 1);
DBCC IND ('Northwind', 'TestAccess', 2);

-- CLUSTERED(1) : id
-- 857
-- 856 ~ 1127

-- NON CLUSTERED(2) : name
-- 865
-- 864 ~ 1061

-- 논리적 읽기 -> 실제 데이터를 찾기 위해 읽은 페이지수
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- INDEX SCAN - 전체 167번
SELECT * FROM TestAccess;

-- INDDEX SEEK
-- 클러스터드 조회 -> 루트(1) + 리프(1) = 논리적 읽기 2번
SELECT * FROM TestAccess
WHERE id = 104;

-- INDDEX SEEK + KEY LOOKUP
-- 논 클러스터드 조회 -> Data?Index? Page 루트(1) + 리프(1) => 클러스터드 키 추출 => 클러스터드 조회 -> 루트(1) + 리프(1) = 논리적 읽기 4번
SELECT * FROM TestAccess
WHERE name = 'name104';

-- INDDEX SCAN + KEY LOOKUP
-- ORDER BY + TOP 으로 논리적 읽기 횟수 감소
SELECT TOP 5 * 
FROM TestAccess
ORDER BY name;