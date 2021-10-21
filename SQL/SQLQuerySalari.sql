USE BaseballData

-- INSERT DELETE UPDATE

SELECT *
FROM salaries
ORDER BY yearID DESC;

-- INSERT =================================
-- INSERT INTO [���̺��] VALUES [��, ...]

INSERT INTO salaries
VALUES (2021, 'KOR', 'NL', 'too', 650000);

-- ������ �������� ����
-- INSERT INTO [���̺��](��, ...) VALUES (��, ...)

INSERT INTO salaries(yearID, teamID, lgID, playerID)
VALUES (2021, 'KOR', 'NL', 'koo');

-- DELETE =================================
-- DELETE FROM [���̺��] -> ���̺� �ٳ���
-- DELETE FROM [���̺��] WHERE [����]

DELETE FROM salaries
WHERE playerID = 'koo';

-- UPDATE =================================
-- UPDATE [���̺��] SET [�� = ��, ] WHERE [����]

UPDATE salaries
SET salary = salary * 2
WHERE teamID = 'KOR';

-- DELETE vs UPDATE
-- �������� vs ������