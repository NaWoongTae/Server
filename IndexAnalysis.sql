USE Northwind;

-- DB 정보 살펴보기
EXEC sp_helpdb 'Northwind'

-- INDEX 구조

-- 임시 테이블 만들기 (인덱스 테스트용)
CREATE TABLE Test
(
	EmployeeID	INT NOT NULL,
	LastName	NVARCHAR(20) NULL,
	FirstName	NVARCHAR(20) NULL,
	HireDate	DATETIME NULL
);
GO

INSERT INTO Test
SELECT EmployeeID, LastName, FirstName, HireDate
FROM Employees;

SELECT *
FROM Test;

-- FILLFACTOR (리프 페이지 공간 1%만 사용) -> (테스트용) 강제로 저장공간을 축소해서 트리구조만들기
-- PAD_INDEX (FILLFACTOR 중간 페이지 적용)
CREATE INDEX Test_Index ON Test(LastName)
WITH (FILLFACTOR = 1, PAD_INDEX = ON);
GO

drop index Test_Index ON Test;

-- 인덱스 번호 찾기
SELECT index_id, name
FROM sys.indexes
WHERE object_id = object_id('Test');

-- 해당하는 2번 인덱스 정보 살펴보기
DBCC IND('Northwind', 'Test', 2);

-- indexLevel
-- Root(2) -> Branch(1) -> Leaf(0)

--  (2층)            849
--  (1층)      872         848       <-의 순서는 NextPageFID ~ PrevPagePID등의 정보로 추측할 수 있다.
--  (0층)   832   840   841

-- Table[ {Page} {Page} {Page} {Page} {Page} ]

-- HEAP RID([페이지주소(4)][파일ID(2)][슬롯번호(2)]) == 8byte  조합한 ROW 식별자. 테이블에서 정보 추출
DBCC PAGE('Northwind', 1/*파일번호*/, 832/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('Northwind', 1/*파일번호*/, 840/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('Northwind', 1/*파일번호*/, 841/*페이지번호*/, 3/*출력옵션*/);

DBCC PAGE('Northwind', 1/*파일번호*/, 849/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('Northwind', 1/*파일번호*/, 872/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('Northwind', 1/*파일번호*/, 848/*페이지번호*/, 3/*출력옵션*/);

-- Random Access (한건 읽기 위해 한 페이지씩 접근)
-- Bookmark Lookup (RID를 통해 행을 찾는다)