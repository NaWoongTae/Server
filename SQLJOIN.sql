USE BaseballData;


-- ���� ����
	-- 1) Nested Loop (NL) ����
	-- 2) Merge (����) ����
	-- 3) Hash (�ؽ�) ����

-- 2) Merge (����) ����
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;
	
-- 3) Hash (�ؽ�) ����
SELECT *
FROM salaries AS s
	INNER JOIN teams AS t
	ON s.teamID = t.teamID;

-- 1) Nested Loop (NL) ����
SELECT TOP 5 *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID

SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(LOOP JOIN); -- ����

SELECT *
FROM salaries AS s
	INNER JOIN players AS p
	ON p.playerID = s.playerID
	OPTION(LOOP JOIN); -- ����

SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(FORCE ORDER, LOOP JOIN); -- ����

-- ��� --
-- NL Ư¡
-- ���� �������� (OUTER)���̺��� �ο츦 ���� ���� -> (INNER) ���̺� ���� ������
-- (INNER) ���̺� �ε����� ������ ���
-- �κй��� ó���� ���� (ex. TOP 5)