USE BaseballData

-- INSERT DELETE UPDATE

SELECT *
FROM salaries
ORDER BY yearID DESC;

-- INSERT =================================
-- INSERT INTO [테이블명] VALUES [값, ...]

INSERT INTO salaries
VALUES (2021, 'KOR', 'NL', 'too', 650000);

-- 데이터 뺴먹으면 에러
-- INSERT INTO [테이블명](열, ...) VALUES (값, ...)

INSERT INTO salaries(yearID, teamID, lgID, playerID)
VALUES (2021, 'KOR', 'NL', 'koo');

-- DELETE =================================
-- DELETE FROM [테이블명] -> 테이블 다날라감
-- DELETE FROM [테이블명] WHERE [조건]

DELETE FROM salaries
WHERE playerID = 'koo';

-- UPDATE =================================
-- UPDATE [테이블명] SET [열 = 값, ] WHERE [조건]

UPDATE salaries
SET salary = salary * 2
WHERE teamID = 'KOR';

-- DELETE vs UPDATE
-- 물리삭제 vs 논리삭제