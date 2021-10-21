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
FROM players AS p				--< OUTER
	INNER JOIN salaries AS s	--< INNER
	ON p.playerID = s.playerID
	OPTION(FORCE ORDER, LOOP JOIN); -- ����

-- ��� --
-- NL Ư¡
-- ���� �������� (OUTER)���̺��� �ο츦 ���� ���� -> (INNER) ���̺� ���� ������
-- (INNER) ���̺� �ε����� ������ ���
-- �κй��� ó���� ���� (ex. TOP 5)


-- ===========================================================================
-- ===========================================================================

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- Merge(����) ���� = Sort Merge(���� ����) ����

SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID;

-- One-To-Many (outer�� unique�ؾ���)
-- Merge ���ε� ������ ����
-- ������ Random Access -> Clustered Scan �� ����

SELECT *
FROM schools AS s
	INNER JOIN schoolsplayers AS p
	ON s.schoolID = p.schoolID;
		-- s.schoolID�� Primary Key�� �̹� ���ĵʤ�

-- ��� --
-- Merge -> Sort Merge ����
-- 1) ���� ������ Sort(����)�ϰ� Merge(����)�Ѵ�
	-- �̹� ���ĵ� ���¶�� Sort ���� (Ư��, Clustered�� ������ ���ĵ� ���¶�� Best)
	-- ������ �����Ͱ� �ʹ� ������ GG -> Hash
-- 2) Random Access ���ַ� ������� �ʴ´�.
-- 3) Many-to-Many(�ٴ��)���ٴ� One-to-Many(�ϴ��) ���ο� ȿ����
	-- PK, UNIQUE ȿ��


-- ===========================================================================
-- ===========================================================================
USE Northwind;

-- Hash(�ؽ�) ����

SELECT * INTO quickTest03 FROM Orders;
SELECT * INTO quickTest04 FROM Customers;

SELECT * FROM quickTest03; -- 832
SELECT * FROM quickTest04; -- 93

-- ���� ����

-- NL ���� ������ : (inner ���̺� �ε����� ����)
SELECT *
FROM quickTest03 AS o
	INNER JOIN quickTest04 AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, LOOP JOIN);

-- Merge ���� ������ : (outer, inner ��� Sort �ʿ� => Many-To-Many)
SELECT *
FROM quickTest03 AS o
	INNER JOIN quickTest04 AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, MERGE JOIN);

-- ==================================

-- HASH - �ƹ��� �ε����� ������
SELECT *
FROM quickTest03 AS o				
	INNER JOIN quickTest04 AS c
	ON o.CustomerID = c.CustomerID;
	-- �� ���� �ε����� ���� ���̺�� HashTable�� ���� �������� ��
	-- hashTable�� ����°͵� ������� -> ���̺��� ũ�� �׸�ŭ ������� Ŀ��

-- ��� --

-- Hash ����
	-- 1) ������ �ʿ����� �ʴ� -> �����Ͱ� �ʹ� ���Ƽ� Merge�� �δ㽺���ﶧ, Hash�� ����� �� �� ����
	-- 2) �ε��� ������ ������ ���� �ʴ´� *****
		-- NL/Merge�� ���� Ȯ���� ����!
		-- HashTable ����� ����� �����ϸ� �ȵ�(����󵵰� ������ -> �ᱹ Index)
	-- 3) ���� ������ ���ַ� ������� ����
	-- 4) �����Ͱ� ���� ���� HashTable�� ����� ���� �����ϴ�!

	
-- ===========================================================================
-- ===========================================================================

USE BaseballData;

-- Sorting (����)�� ������!

-- O(NLogN) -> DB�� �����Ͱ� ��
-- �ʹ� �뷮�� Ŀ�� ���� �޸𸮷� Ŀ���� �� �Ǹ� -> ��ũ���� ã�ư� �����ϰ� ���ϰ�~
-- Sorting�� ���� �Ͼ���� �ľ��ϰ� �־�� �� *****

-- Sorting�� �Ͼ ��
	-- 1) Sort Merge Join
		-- ����) �˰��� Ư���� Merge�� Sort�� �ؾ���
	-- 2) ORDER BY
	-- 3) GROUP BY
	-- 4) DISTINCT
	-- 5) UNION
	-- 6) RANKING WINDOWS FUNCTION
	-- 7) MIN MAX

-- 1) ����
-- 2) ORDER BY
	-- ����) ������� ���� �ؾ� �ϴϱ� Sort
SELECT *
FROM players
ORDER BY college;

SELECT *
FROM batting
ORDER BY playerID, yearID; -- �ε����� �ֱ⶧���� Sort��������

-- 3) GROUP BY
	-- ����) ���踦 �ϱ� ����
SELECT college, COUNT(college)
FROM players
WHERE college LIKE 'C%'
GROUP BY college;

-- 4) DISTINCT - �ߺ�����
	-- ����) �ߺ����Ÿ� ����
SELECT DISTINCT college
FROM players
WHERE college LIKE 'C%'

-- 5) UNION
	-- ����) ù°�׷�� ��°�׷��� ��Ұ� ��ĥ��� �ߺ�����
SELECT college
FROM players
WHERE college LIKE 'C%'
UNION
SELECT college
FROM players
WHERE college LIKE 'D%'

-- ù°�׷�� ��°�׷��� Ȯ���ϰ� ��ġ�� ��Ұ� ���ٰ� �Ǵܵɶ��� UNION ALL
SELECT college
FROM players
WHERE college LIKE 'C%'
UNION ALL
SELECT college
FROM players
WHERE college LIKE 'D%'

-- 6) RANKING WINDOWS FUNCTION
	-- ����) ���踦 ����
SELECT ROW_NUMBER() OVER (ORDER BY college)
FROM players;

-- 7) MIN MAX
	-- ����

-- ��� --

-- INDEX�� �� Ȱ���ϸ�, Sorting�� ���� ���� �ʾƵ� �ȴ�.

-- ===========================================================================
-- ===========================================================================

-- LOCK

-- 1) Shared
	-- READ (SELECT)
-- 2) Exclusive
	-- DML (INSERT, UPDATE, DELETE)
-- 3) Update
	-- Shared�� Exclusive �߰�


-- LOCK ����
	-- (<<- �� ������ ����(����ó���� ����))
	-- ROW - PAGE - INDEX - TABLE - DATABASE
	-- (->> �ڿ��Ҹ� ����)

-- SQL������ DEADLOCK �߻�����?
-- ����
	-- �����ϰ� ������� �ʰ� ������ �ѹ�

-- TRANSACTION�� Ư�� ACID

-- 1) A (Atomicity)
	-- ���ڼ� - ���εǰų� ���� �ȵǰų�
	-- ex) �÷��̾� ��� ���� + ������ �κ��丮 �߰�

-- 2) C (Consistency) 
	-- �ϰ��� - �����Ͱ� �ϰ��� ���� (������ �ε��� ����ġ ��)

-- 3) I (Isolation)
	-- ���� - Ʈ������� �ܵ����� �����ϰų�, �ٸ� Ʈ����ǰ� ���� �����ϰų� ���� ���

-- 4) D (Durability)  
	-- ���Ӽ� - ��ְ� �߻��ϴ��� �����ʹ� �ݵ�� ��������
	-- ����ø� ����� �α׸� ������
	-- ex) �ؾ��ϴ� �α׵� ����� ������ �ߴ����� ����� �� --> ���� �α�


-- 1) ���� �����͸� �ٷ� �ϵ��ũ�� �ݿ����� �ʰ�, �α׸� �̿�
-- 2) REDO(before -> after) UNDO(after -> before)
-- 3) �̷��� ���� (Roll Forward)
-- 4) ���ŷ� ���� (Roll Back)
-- 5) �����ͺ��̽� ��� �߻��ϴ��� �α׸� �̿��� ����/�ѹ�