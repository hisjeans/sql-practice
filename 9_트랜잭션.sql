-- transaction 
-- 실제 데이터를 특정 시점으로 되돌린다 
-- PostgreSQL은 기본적으로 오토 커밋이 켜진 상태로 동작한다
-- INSERT, UPDATE, DELETE를 실행하면 무조건 COMMIT이 들어가 데이터가 영구적으로 저장된다
-- 명시적으로 트랜잭션을 시작하려면 BEGIN 또는 START TRANSACTION을 사용한다

SELECT * FROM dept; -- 이전 시점으로 되돌아갈 수 없다
-- COMMIT 후에는 VALUES가 들어가 있고, 커밋 이전 시점으로 절대 돌아갈 수 없다 

BEGIN; -- 1. 트랜잭션 시작(수동 트랜잭션 관리), 먼저 실행 후 작성해야 한다, 다시 트랜잭션을 열고 싶을 때는 다시 실행해야 한다 

INSERT INTO dept
	(dept_name, loca, dept_bonus, man_gender)
VALUES 
	('test4', 1900, 4000000, 'M'); 
	
INSERT INTO dept
	(dept_name, loca, dept_bonus, man_gender)
VALUES 
	('test5', 2000, 3000000, 'F');
-- 영구저장되지 않는다 
-- 언제든지 롤백에 의해서 취소될 가능성 있다 

DELETE FROM dept
WHERE dept_no = 4;


-- 보류 중인 모든 데이터 변경상황을 취소(폐기)하고 트랜잭션 종료
ROLLBACK; 

-- 보류 중인 모든 데이터 변경사항을 영구적으로 적용하면서 트랜잭션 종료
COMMIT;


BEGIN;

-- 세이브포인트: 커밋은 아니지만, 특정 데이터베이스 시점을 저장하고 싶을 때 사용
-- 트랜잭션이 열려 있을 때만 사용 가능 
SAVEPOINT insert_test4;


SELECT * FROM dept;

-- 현재 test4, 5는 확정된 상태가 아니기 때문에 rollback을 하면 전부 다 사라질 것
-- test 5는 취소하고 싶지만 test4는 남겨두고 싶다면 rollback이 아니다
-- savepoint insert_test4로 돌아가자
-- 특정 세이브 포인트로 롤백 
-- test 4도 확정된 상태는 아니기 때문에 롤백하면 사라진다 
ROLLBACK TO insert_test4;

ROLLBACK;