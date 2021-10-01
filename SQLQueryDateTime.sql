/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [time]
  FROM [BaseballData].[dbo].[DateTimeTest]

SELECT CAST('2021-12-25 7:03:15' AS DATETIME)
-- ����
-- YYYYMMDD hh:mm:ss.nnn
-- YYYY-MM-DD hh:mm

-- ����ð�
SELECT GETDATE(); -- T-SQL
SELECT CURRENT_TIMESTAMP

SELECT *
FROM DateTimeTest
WHERE time >= '20050101'

-- GMT
SELECT GETUTCDATE()
-- ��¥ ���ϱ� -> �̷�
SELECT DATEADD(YEAR, 10, CURRENT_TIMESTAMP)
-- ��¥ ���� -> ����
SELECT DATEADD(YEAR, -10, CURRENT_TIMESTAMP)

-- ��¥ ����
SELECT DATEDIFF(DAY, '20140128', CURRENT_TIMESTAMP)

-- ��¥���� Ư����
SELECT DATEPART(DAY, CURRENT_TIMESTAMP)
SELECT DAY(CURRENT_TIMESTAMP)

-- ������ �߰� =================================================================
GO
INSERT INTO [dbo].[DateTimeTest]
           ([time])
     VALUES
           ('2002-04-23 14:30:00')
GO