USE Northwind;

-- 주문 상세 정보를 살펴보자
SELECT *
FROM [Order Details] -- 이름이 명령어와 겹칠때는 [ 이름 ]
ORDER BY OrderID;

-- 임시 테스트 테이블을 만들고 데이터 복사
SELECT *
INTO TestOrderDetails
FROM [Order Details]; -- 바로 생성

SELECT *
FROM TestOrderDetails;

-- 복합 인덱스 추가
CREATE INDEX Index_TestOrderDetails
ON TestOrderDetails(OrderID, ProductID); --> OrderID로 Index검색을 하고 '필요한'경우 ProductID를 활용하는것이지, ProductID만 사용할 수 없음 (▼ 인덱스 적용테스트 4번)
                                         -- ex) OrderID : 1차 Key - ProductID : 2차 Key

-- 인덱스 정보 살펴보기
EXEC sp_helpindex 'TestOrderDetails'

-- (OrderId, ProductID)? OrderId? ProductID?
-- INDEX SCAN (INDEX FULL SCAN) -> BAD
-- INDEX SEEK -> GOOD

-- 인덱스 적용 테스트 1 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248 AND productID = 11;

-- 인덱스 적용 테스트 2 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE productID = 11 AND OrderID = 10248; -- 순서를 뒤바꾸는 정도는 내부적으로 알아서 최적화해서 실행

-- 인덱스 적용 테스트 3 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248;

-- 인덱스 적용 테스트 4 -> BAD -> INDEX 활용하지 않음
SELECT *
FROM TestOrderDetails
WHERE productID = 11;

--------------------------

-- INDEX 정보
DBCC IND('Northwind', 'TestOrderDetails', 2);

DBCC PAGE('Northwind', 1, 856, 3);

-- 따라서 인덱스(A,B) 사용중이라면
--		  A 검색시	-> 인덱스(A) 없어도 무방
-- 하지만 B 검색시	-> 인덱스(B)는 별도로 걸어줘야 함

-- 인덱스는 데이터가 추가/갱신/삭제 유지되어야 함

-- 데이터 50개를 강제로 넣어보자
-- 10248/11 20387/24

DECLARE @i INT = 0;
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES (10248,100+@i,10,1,0)
	SET @i = @i + 1;
END

DBCC PAGE('Northwind', 1, 888, 3);
--> 당연하지만 페이지에 데이터가 넘치게 되면 페이지를 새로 생성해서 페이지를 쪼갠다
-- 결론 : 페이지 여유공간이 없다면 -> 페이지 분할(SPLIT) 발생

-- 가공 테스트 ==================================================================
SELECT LastName
INTO TestEmployees
FROM Employees;

SELECT * FROM TestEmployees;

-- 인덱스 추가
CREATE INDEX Index_TestEmployees
ON TestEmployees(LastName);

-- INDEX SCAN -> BAD
SELECT *
FROM TestEmployees
WHERE SUBSTRING(LastName, 1, 2) = 'Bu'; -- INDEX 가공시 INDEX로 찾을 수 없음

-- INDEX SEEK
SELECT *
FROM TestEmployees
WHERE LastName LIKE 'Bu%';

-- 결론
-- 복합 인덱스 (A, B)를 사용할 때 순서 주의 (A -> B 순서 검색)
-- 인덱스 사용시, 데이터 추가로 인해 페이지 여유가 없으면 SPLIT
-- 키 가공시 주의
