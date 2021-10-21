USE BaseballData;

-- ������ �Լ�
-- ����� ���� ������ �������, �� �ະ�� ����� �ؼ� ��Į��(���� ����)���� ����ϴ� �Լ�

-- GROUPING�� ���

-- ~OVER([PARTITION] [ORDER BY] [ROWS]) -> 3������ ������ �ɼ��� �ִ�.

-- ��ü �����͸� ���������� ����, ���� ǥ��
SELECT *,
	ROW_NUMBER() OVER (ORDER BY salary DESC) AS ROW_NUMBER,	-- ��#��ȣ
	RANK() OVER (ORDER BY salary DESC) AS RANK ,			-- ��ŷ : ���������� ���������� ���̾���
	DENSE_RANK() OVER (ORDER BY salary DESC) AS DENSE_RANK,	-- ��ŷ : ���������� ���������� �̾���
	NTILE(100) OVER (ORDER BY salary DESC) AS NTILE			-- ���� ��%
FROM salaries

-- playerID �� ������ ���� �ϰ� �ʹٸ�?
-- ������ Ȩ����!

GO

SELECT * FROM (
SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY yearID ORDER BY HR DESC) AS ranking
FROM batting
) AS yearTable
WHERE ranking = 1
ORDER BY yearID DESC;

-- LAG(�ٷ� ����), LEAD(�ٷ� ����)
SELECT *,
	ROW_NUMBER() OVER (PARTITION BY yearID ORDER BY HR DESC) AS ranking,
	LAG(HR) OVER (PARTITION BY yearID ORDER BY HR DESC) AS prevHR,
	LEAD(HR) OVER (PARTITION BY yearID ORDER BY HR DESC) AS nextHR
FROM batting
ORDER BY yearID DESC

-- FIRST_VALUE, LAST_VALUE
-- FRAME : FIRST~CURRENT  -> ��������� ROWS �� ǥ������ ������ 1������ ��������� ����
SELECT *,
	RANK() OVER (PARTITION BY yearID ORDER BY HR DESC) AS ranking,
	FIRST_VALUE(HR) OVER (PARTITION BY yearID ORDER BY HR DESC
							ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS best, -- ó������ ������
	LAST_VALUE(HR) OVER (PARTITION BY yearID ORDER BY HR DESC 
							ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS worst -- ������ ������
FROM batting
ORDER BY yearID DESC