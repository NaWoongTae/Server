USE BaseballData;

-- ���� ========================================

DECLARE @i AS INT = 10;

DECLARE @j AS INT;
SET @J = 10;

-- ����) ���� �ְ� ������ ���� ���� �̸�?

DECLARE @firstName AS NVARCHAR(15);
DECLARE @lastName AS NVARCHAR(15);

SET @firstName = (	SELECT TOP 1 nameFirst
					FROM players AS p
						INNER JOIN salaries AS s
						ON p.playerID = s.playerID
					ORDER BY s.salary DESC);

SELECT @firstName;

-- SQL SERVER�� ����

DECLARE @firstName AS NVARCHAR(15);
DECLARE @lastName AS NVARCHAR(15);

SELECT TOP 1 @firstName = p.nameFirst, @lastName = p.nameLast
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
ORDER BY s.salary DESC;

SELECT @firstName, @lastName;

-- ��ġ ========================================
-- GO �� ���� ���� �ٽ� ���ڴ� - ������ ��ȿ���� ���� ���� {}
GO

DECLARE @i AS INT;

-- ��ġ�� �ϳ��� �������� �м��ǰ� ����Ǵ� ��ɾ� ����

SELECT *
FRM players;

GO -- ���Ʒ� �ѹ��� ������ѵ� �ٸ��ɷ� ħ

SELECT *
FROM salaries;

-- �帧���� ==============================================================

-- IF
GO
DECLARE @i AS INT = 10;

IF @i = 10 -- ���� ���ð� ���ٸ� ������ IF�� ���� ���ٸ� �����
BEGIN -- �߰�ȣ ���
	PRINT('YES');
END -- �߰�ȣ ���
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

-- ���̺� ���� ------------------------------
-- �ӽ÷� ����� ���̺��� ������ ����� �ִ�.
-- DECLARE�� ��� -> tempdb �����ͺ��̽��� �ӽ� ����

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

