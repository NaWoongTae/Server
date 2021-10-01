USE BaseballData;

-- TEST ==========================================================================

-- playerID(����ID)
-- yearID (����⵵)
-- teamID (����Ī, 'BOS'=������)
-- G_batting (������� + Ÿ��)

-- AB(Ÿ��)
-- H(��Ÿ)
-- R(���)
-- 2B(2��Ÿ)
-- 3B(3��Ÿ)
-- HR(Ȩ��)
-- BB(����)

SELECT *
FROM batting;

/*
1) ������ �Ҽ� �������� �����鸸 ��� ���
2) �������� ���İ� �������� ���� ���
3) ������ ���� 2004�⵵�� ģ Ȩ�� ����
4) ������ �� �Ҽ����� ���� �⵵ �ִ� Ȩ���� ģ ����� ����
*/

-- 1)
SELECT *
FROM batting
WHERE teamID = 'BOS'
ORDER BY yearID DESC;

-- 2)
SELECT COUNT(DISTINCT playerID)
FROM batting
WHERE teamID = 'BOS';

-- 3)
SELECT SUM(HR) AS '2004 HOMRUN'
FROM batting
WHERE teamID = 'BOS' AND yearID = 2004;

-- 4)
SELECT TOP 1 *
FROM batting
WHERE teamID = 'BOS'
ORDER BY HR DESC;