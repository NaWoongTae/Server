USE BaseballData;

-- 변수 ========================================

DECLARE @i AS INT = 10;

DECLARE @j AS INT;
SET @J = 10;

-- 예제) 역대 최고 연봉을 받은 선수 이름?

DECLARE @firstName AS NVARCHAR(15);
DECLARE @lastName AS NVARCHAR(15);

SET @firstName = (	SELECT TOP 1 nameFirst
					FROM players AS p
						INNER JOIN salaries AS s
						ON p.playerID = s.playerID
					ORDER BY s.salary DESC);

SELECT @firstName;

-- SQL SERVER만 가능

DECLARE @firstName AS NVARCHAR(15);
DECLARE @lastName AS NVARCHAR(15);

SELECT TOP 1 @firstName = p.nameFirst, @lastName = p.nameLast
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
ORDER BY s.salary DESC;

SELECT @firstName, @lastName;

-- 배치 ========================================
-- GO 이 위로 끊고 다시 가겠다 - 변수의 유효범위 설정 가능 {}
GO

DECLARE @i AS INT;

-- 배치는 하나의 묶음으로 분석되고 실행되는 명령어 집합

SELECT *
FRM players;

GO -- 위아래 한번에 실행시켜도 다른걸로 침

SELECT *
FROM salaries;

-- 흐름제어 ==============================================================

-- IF
GO
DECLARE @i AS INT = 10;

IF @i = 10 -- 별도 지시가 없다면 무조건 IF문 밑의 한줄만 실행됨
BEGIN -- 중괄호 대신
	PRINT('YES');
END -- 중괄호 대신
ELSE
	PRINT('NO');

-- WHILE
GO

DECLARE @i AS INT = 0;
WHILE @i <= 10
BEGIN
	PRINT(@i);
	SET @i = @i + 1;
	IF @i = 3CONTINUE;
	IF @i > 6 BREAK;
END

-- 테이블 변수 ------------------------------
-- 임시로 사용할 테이블을 변수로 만들수 있다.
-- DECLARE를 사용 -> tempdb 데이터베이스에 임시 저장

GO

DECLARE @test AS TABLE
(
	name VArchar(50) NOT NULL,
	salary INT NOT NULL
);

INSERT INTO @test
SELECT p.nameLast + ' ' + p.nameFirst, s.salary
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;

SELECT *
FROM @test;

