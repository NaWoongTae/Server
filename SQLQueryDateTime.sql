/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [time]
  FROM [BaseballData].[dbo].[DateTimeTest]

SELECT CAST('2021-12-25 7:03:15' AS DATETIME)
-- 권장
-- YYYYMMDD hh:mm:ss.nnn
-- YYYY-MM-DD hh:mm

-- 현재시간
SELECT GETDATE(); -- T-SQL
SELECT CURRENT_TIMESTAMP

SELECT *
FROM DateTimeTest
WHERE time >= '20050101'

-- GMT
SELECT GETUTCDATE()
-- 날짜 더하기 -> 미래
SELECT DATEADD(YEAR, 10, CURRENT_TIMESTAMP)
-- 날짜 빼기 -> 과거
SELECT DATEADD(YEAR, -10, CURRENT_TIMESTAMP)

-- 날짜 간격
SELECT DATEDIFF(DAY, '20140128', CURRENT_TIMESTAMP)

-- 날짜에서 특정값
SELECT DATEPART(DAY, CURRENT_TIMESTAMP)
SELECT DAY(CURRENT_TIMESTAMP)

-- 데이터 추가 =================================================================
GO
INSERT INTO [dbo].[DateTimeTest]
           ([time])
     VALUES
           ('2002-04-23 14:30:00')
GO