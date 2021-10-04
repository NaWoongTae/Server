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

-- 4-2) (������ �� �Ҽ�����) �⵵�� �ִ� Ȩ���� ģ ����� ����
SELECT teamID, yearID, HR
FROM batting
WHERE teamID = 'BOS'
GROUP BY teamID, yearID, HR
HAVING HR = MAX(HR)
ORDER BY yearID;

-- 5) 2004�⵵�� ���� ���� Ȩ���� ��������? ----- Grouping
SELECT teamID, COUNT(teamID) AS playerCount, SUM(HR) AS homeRuns
FROM batting
WHERE yearID = 2004
GROUP BY teamID
ORDER BY homeRuns DESC;

--6) 2004�� 200Ȩ�� �̻� ���� ���� ���
-- FROM -> WHERE -> (GROUP BY-> (HAVING)) -> SELECT -> ORDER BY
-- HAVING : �׷���� WHERE
SELECT teamID, COUNT(teamID) AS playerCount, SUM(HR) AS homeRuns
FROM batting
WHERE yearID = 2004
GROUP BY teamID
HAVING SUM(HR) >= 200
ORDER BY homeRuns DESC;