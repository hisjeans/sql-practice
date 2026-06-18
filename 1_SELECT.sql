-- 한 줄 주석
/*
   여러 줄 주석
*/

-- SELCEC [컬럼명] FROM [테이블이름]
SELECT * FROM employees;

SELECT 
	employee_id, 
	first_name, 
	last_name 
FROM 
	employees;
-- SQL script는 문장 단위로 실행, 데이터베이스에게 명령

-- ALIAS (컬럼명, 테이블명의 이름을 변경해 조회)
SELECT 
	employee_id AS 사번, 
	first_name AS 성, 
	last_name AS 이름
FROM 
	employees;

-- 컬럼을 조회하는 위치에서 산술 연산을 통해 새로운 컬럼을 함께 조회하는 것이 가능
SELECT 
	employee_id, 
	first_name, 
	last_name,
	salary,
	salary + salary*0.1 AS 성과포함급여
FROM 
	employees;


-- NULL 값의 확인 (숫자 0이나 공백과는 다른 개념)
SELECT 
	employee_id, 
	department_id,
	commission_pct
FROM 
	employees;

-- DISTINCT (중복 행의 제거)
SELECT DISTINCT 
	department_id
FROM employees;


