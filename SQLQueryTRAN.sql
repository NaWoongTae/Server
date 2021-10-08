use GameDB;

-- TRANSACTION

SELECT *
FROM accounts;

-- BEGIN TRAN;
-- COMMIT;
-- ROLLBACK;

-- 거래
-- A의 인벤에서 템 제거
-- B의 인벤에다 템 추가
-- B의 골드감소

-- 거래, 강화등 ALL OR NOTHING
-- 전부 되거나 전부 안되야함

-- TRAN 명시하지 않으면 자동으로 COMMIT
INSERT INTO accounts VALUES(9, N'자', 11, GETUTCDATE());

-- 메일 BEGIN TRAN
-- 보낼것인가 COMMIT;
-- 취소 ROLLBACK;

-- 성공/실패 여부에 따라 COMMIT (= COMMIT을 수동으로 하겠다)
BEGIN TRAN;
	INSERT INTO accounts VALUES(10, N'A', 12, GETUTCDATE());
ROLLBACK;

BEGIN TRAN;
	INSERT INTO accounts VALUES(11, N'B', 13, GETUTCDATE());
COMMIT;

-- 응용 + TRY CATCH
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO accounts VALUES(13, N'D', 15, GETUTCDATE());
		INSERT INTO accounts VALUES(12, N'C', 14, GETUTCDATE());
	COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 -- 현재 활성화된 트랜잭션 수를 반환	
	PRINT(@@TRANCOUNT);
		ROLLBACK;
	PRINT('ROLLBACK했음');
END CATCH

/*BEGIN TRAN;
	INSERT INTO accounts VALUES(14, N'E', 15, GETUTCDATE());
COMMIT;
ROLLBACK;*/

-- TRAN 주의점
-- TRAN 안에는 꼭!! 원자적으로 실행될 애들만 넣어서 사용

BEGIN TRAN;
	INSERT INTO accounts VALUES(17, N'G', 16, GETUTCDATE());
-- ROLLBACK; COMMIT; 없이 트랜잭션만 걸어놓은 상태에서는 => 다른 쿼리에서 데이터에 접근할수없다.
-- 마치 LOCK 걸어 놓은거 처럼된다. 같은 쿼리에서는 가능한것같다.

SELECT *
FROM accounts;