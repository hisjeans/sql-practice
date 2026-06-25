-- postgress 계정 관리

-- 1. 사용자 계정(Role) 목록 확인
SELECT * FROM pg_roles;

-- 2. 계정 생성 명령 
-- PostgreSQL에서는 USER와 ROLE이 거의 같은 개념
-- LOGIN 권한을 주어야 실제로 접속 가능한 유저 역할 하게 된다 
CREATE USER user1 WITH PASSWORD 'user1';
-- CREATE ROLE user1 WITH LOGIN PASSWORD 'user1';

/*
 PostgreSQL DCL: GRANT (권한 부여), REVOKE(권한 회수)
 
 Postgres는 기본적으로 데이터베이스 접속 권한과 스키마 사용 권한이 먼저 필요 
 계정을 생성했다고 바로 활성화되는 게 아니라 데이터베이스, 스키마에 접근할 수 있는 권한을 일괄적으로 부여해야 한다 
*/

-- 데이터 베이스 접속 권한 부여
GRANT CONNECT ON DATABASE postgres TO user1;

-- 특정 스키마의 객체(테이블, 시퀀스 등..) 들을 사용할 수 있는 권한 부여 
GRANT USAGE ON SCHEMA public TO user1;

SELECT * FROM employees; -- 관리자 계정인 postgres는 접속 가능하지만 user1은 조회되지 않는다

-- 특정 테이블만 조회할 수 있는 권한 부여 
GRANT SELECT ON TABLE public.employees TO user1;

SELECT  * FROM departments; -- user1이 조회할 수 없다 

DELETE FROM employees WHERE employee id = 100; -- user1이 조회할 수 없다, select 권한만 받았기 때문


-- 3. ROLE(권한의 묶음) 실습 
CREATE ROLE new_emp_role;


-- 롤에 권한 부여
GRANT USAGE ON SCHEMA public TO new_emp_role; -- schema 권한 먼저 선행되어야 한다 
GRANT SELECT, UPDATE, INSERT ON TABLE public.employees TO new_emp_role;
GRANT SELECT, UPDATE ON TABLE public.departments TO new_emp_role;

-- 유저에게 롤 부여하기(user1은 new_emp_role의 권한을 상속받는다)
GRANT new_emp_role TO user1;

SELECT * FROM employees; -- 이제 user1이 조회 가능

UPDATE employees 
SET salary = 12345
WHERE employee_id = 195;

SELECT * FROM departments;


-- 4. 관리자 권한 부여하기 
ALTER USER user1 WITH SUPERUSER; -- 슈퍼유저 권한 부여
ALTER USER user1 WITH NOSUPERUSER; -- 슈퍼유저 권한 회수

CREATE DATABASE test_db; -- 관리자 계정은 데이터베이스 생성 권한 가진다 

SELECT datname FROM pg_database;

CREATE SCHEMA my_schema;
DROP SCHEMA my_schema;