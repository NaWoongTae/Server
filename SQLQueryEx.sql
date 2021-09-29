
/* ������ �ּ� */
-- ���� �ּ�

-- SQL (RDBMS�� �����ϱ� ���� ��ɾ�)
-- +@ T-SQL

-- CRUD (Create-Read-Update-Delete)

SELECT *
FROM players
WHERE deathYear IS NULL

-- NULL�� IS NULL / IS NOT NULL

SELECT playerID as �̸�, birthYear, nameLast, birthCountry
FROM players
where birthCountry != 'USA' AND birthYear > 1980

-- SELECT -> FROM -> WHERE ����
-- ��ҹ��� ��� ����
-- AND OR - (AND�� �켱)

SELECT *
FROM players
WHERE nameLast LIKE 'A___'

-- % ������ ���ڿ�
-- _ ������ ���� 1�� (������ ����)