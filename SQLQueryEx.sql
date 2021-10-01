USE BaseballData;

/* ������ �ּ� */
-- ���� �ּ�

-- SQL (RDBMS�� �����ϱ� ���� ��ɾ�)
-- +@ T-SQL

-- CRUD (Create-Read-Update-Delete)

-- NULL üũ ==========================================================================
SELECT *
FROM players
WHERE deathYear IS NULL

-- NULL�� IS NULL / IS NOT NULL

SELECT playerID as �̸�, birthYear, nameLast, birthCountry
FROM players
where birthCountry != 'USA' AND birthYear > 1980

-- SELECT -> FROM -> WHERE -> ORDER BY ������
-- FROM -> WHERE -> SELECT -> ORDER BY ���ۼ���
-- ��ҹ��� ��� ����
-- AND OR - (AND�� �켱)

-- ���ڿ� ==========================================================================
SELECT *
FROM players
WHERE nameLast LIKE 'A___'

-- % ������ ���ڿ�
-- _ ������ ���� 1�� (������ ����)

-- ���� ==========================================================================
SELECT TOP 1 PERCENT *
FROM players
WHERE birthYear IS NOT NULL AND birthMonth IS NOT NULL AND birthDay IS NOT NULL
ORDER BY birthYear ASC, birthMonth, birthDay

-- ASC DESC (��������)

-- SELECT TOP 10 *           : ž N
-- SELECT TOP 1 PERCENT *    : ž N%
-- T SQL�� ������

SELECT *
FROM players
ORDER BY lahmanID
OFFSET 100 ROWS FETCH NEXT 10 ROWS ONLY;

-- �߰� ���� ��������
-- OFFSET 100���� NEXT 10��ŭ
-- ORDER BY�� �ʼ�

-- ��ġ ���� ==========================================================================
-- + - * / %
-- NULL���� ���� = NULL
SELECT nameFirst, 2022 - birthYear AS koreanAge
FROM players
WHERE birthYear > 1950 AND deathYear IS NULL AND birthYear IS NOT NULL
ORDER BY koreanAge

SELECT 3 / 2 -- 1
SELECT 3.0 / 2 -- 1.5
SELECT 3 / 2.0 -- 1.5

-- ���ڿ� ==========================================================================

SELECT 'HELLO' -- ''���� ���� �ϳ��� 1Byte
SELECT N'�ȳ�'  -- �����ڵ� ���� �տ� N

SELECT 'hello' + 'world'
SELECT SUBSTRING('20210929' ,1 ,4) -- ������ 0�� �ƴ� 1
SELECT TRIM('         SPACE             ') -- �����̽� ������

SELECT nameFirst + ' ' + nameLast AS fullName, 2022 - birthYear AS koreanAge
FROM players
WHERE nameFirst IS NOT NULL AND nameLast IS NOT NULL

-- CASE ==========================================================================
-- ��� 1
SELECT birthYear, birthMonth, birthDay, 
	CASE birthMonth
		WHEN 1 THEN N'�ܿ�'
		WHEN 2 THEN N'�ܿ�'
		WHEN 3 THEN N'��'
		WHEN 4 THEN N'��'
		WHEN 5 THEN N'��'
		WHEN 6 THEN N'����'
		WHEN 7 THEN N'����'
		WHEN 8 THEN N'����'
		WHEN 9 THEN N'����'
		WHEN 10 THEN N'����'
		WHEN 11 THEN N'����'
		WHEN 12 THEN N'�ܿ�'
		ELSE N'��5����'
	END AS birthSeason
FROM players;

-- ��� 2
SELECT birthYear, birthMonth, birthDay, 
	CASE 
		WHEN birthMonth <= 2 THEN N'�ܿ�'
		WHEN birthMonth <= 5 THEN N'��'
		WHEN birthMonth <= 9 THEN N'����'
		WHEN birthMonth <= 11 THEN N'����'
		WHEN birthMonth IS NULL THEN N'����'
		ELSE N'�ܿ�'
	END AS birthSeason
FROM players;

-- ���� ==========================================================================
-- COUNT SUM AVG MIN MAX

SELECT COUNT(*) -- *�� ����� �� �ִ� �ִ� COUNT��
FROM players

SELECT COUNT(birthYear)
FROM players

-- �����Լ��� ������ null�̸� ����

-- �ߺ�����
SELECT DISTINCT birthCity
FROM players
ORDER BY birthCity;

-- �������� ���� DISTINCT (birthYear, birthMonth, birthDay)�� ���� ������������ �ߺ��� üũ�Ѵ�.
SELECT DISTINCT birthYear, birthMonth, birthDay 
FROM players
ORDER BY birthYear;

-- �ߺ����ŵ� ������? => ����(DISTINCT)
SELECT COUNT(DISTINCT birthCity)
FROM players

-- ��� weight
SELECT AVG(weight)
FROM players;

SELECT SUM(weight) / COUNT(weight)
FROM players;

-- NULL �����Ϳ� �⺻���� ����
SELECT AVG
	(CASE 
		WHEN weight IS NULL THEN 0
		ELSE weight
	END)
FROM players;

-- MIN MAX - ��¥���� ����
SELECT MIN(weight) AS minWeight, MAX(weight) AS maxWeight
FROM players