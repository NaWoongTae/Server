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

-- DATETIME ==========================================================================
-- DATE ��/��/��
-- TIME ��/��/��
-- DATETIME ��/��/��/��/��/��
SELECT nameFirst + ' ' + nameLast AS fullName, debut, finalGame
FROM players