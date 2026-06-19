/*
# 서브쿼리 
: SQL 문장 안에 또다른 SQL을 포함하는 방식.
 여러 개의 질의를 동시에 처리할 수 있습니다.
 WHERE, SELECT, FROM 절에 작성이 가능합니다.

- 서브쿼리의 사용방법은 () 안에 명시함.
 서브쿼리절의 리턴행이 1줄 이하여야 합니다.
- 서브쿼리 절에는 비교할 대상이 하나 반드시 들어가야 합니다.
- 해석할 때는 서브쿼리절 부터 먼저 해석하면 됩니다.
*/


-- 이름이 'Nancy'인 사원보다 급여가 높은 사원을 조회
SELECT salary FROM employees 
WHERE first_name = 'Nancy';

SELECT first_name FROM employees 
WHERE salary > 12000;


-- 한 번에 실행해 구할 수 없을까? - 서브쿼리 활용하자!
-- 서브쿼리를 활용한 문장
SELECT first_name FROM employees
WHERE salary > (SELECT salary FROM employees 
				WHERE first_name = 'Nancy');

-- employee_id가 103번의 사람의 job_id와 동일한 job_id를 가진 사원을 조회
SELECT *
FROM employees
WHERE job_id = (SELECT job_id FROM employees 
				WHERE employee_id = 103);


SELECT *
FROM employees
WHERE job_id = (SELECT job_id FROM employees 
				WHERE last_name = 'King'); -- 에러

-- 다음 문장은 서브쿼리가 리턴하는 행이 여러 개라서 단일 행 연산자를 사용할 수 없다 
-- 단일 행 연산자: 주로 비교 연산자(=, >, <, >=, <=, <>)를 사용하는 경우 하나의 행만 반환해야 한다 
-- 다중 행 서브쿼리를 사용하고 싶다면 다중 행 연산자를 사용해야 한다 
SELECT * FROM employees
WHERE last_name = 'King'; 


-- 다중 행 연산자 중 둘 중 하나만 만족시켜도 가능한 연산자 없을까?
-- IN: 조회된 목록의 특정 값과 같은지 비교
-- ex) salary IN (200, 300, 400) - 반드시 200, 300, 400 중 하나이어야 한다
-- 250 -> false
-- 반드시 조회 목록에 특정 값과 같아야 한다 
SELECT *
FROM employees
WHERE job_id IN (SELECT job_id FROM employees 
				WHERE last_name = 'King');

-- ANY, SOME: 값을 서브쿼리에 의해 리턴된 각각의 값과 비교해
-- 하나라도 만족하면 조회 대상에 포함 
-- 예: salary > ANY (200, 300, 400)
-- 250 -> true - 200 보다 크기 때문에 조회 대상에 포함될 수 있는 것 
-- job_id는 문자이기 때문에 IN이 들어가야 한다 
SELECT *
FROM employees
WHERE salary > ANY (SELECT salary FROM employees -- 가장 작은 값 보다 커지면 조회 대상에 포함 
				WHERE first_name = 'David'); 

SELECT salary FROM employees
					WHERE first_name = 'David';

-- ALL: 값을 서브쿼리에 의해 리턴된 각각의 값과 비교해
-- 모두 다 일치해야 조회대상에 포함
-- 예: salary > ALL (200, 300, 400)
-- 250 -> false
SELECT *
FROM employees
WHERE salary > ALL (SELECT salary FROM employees 
				WHERE first_name = 'David'); 



----------------------------------------------------------------------------------------------------

-- SELECT 절에 서브쿼리 붙이기
-- 스칼라 서브쿼리 라고도 칭한다
-- 스칼라 서브쿼리: 실행 결과가 단일 값을 반환하는 서브쿼리
SELECT ALL 
	e.first_name,
	d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.first_name;

-- JOIN 문 작성하지 않고 SELECT에 서브쿼리
SELECT
	e.first_name, 
	(
		SELECT 
			d.department_name 
		FROM departments d 
		WHERE d.department_id = e.department_id 
	) AS department_name
FROM employees e
ORDER BY e.first_name;

/*
# 스칼라 서브쿼리 vs LEFT JOIN
a. 간단한 상황에서 사용하면 쿼리가 직관적이고 간결합니다.
b. 단일 값을 반환하는 서브쿼리에서 유용.
c. 대량 데이터가 아닌 경우나, 서브쿼리의 복잡도가 낮은 경우 적합.

1. 대량 데이터를 처리하거나, 여러 컬럼을 붙여야 할 때 유리합니다.
2. 여러 테이블을 한 번에 조인해야 할 경우.
3. 다중값 처리 및 중복 데이터가 있는 경우 성능상 좀 더 유리.
*/


-- 각 부서 별 사원 수 뽑기 (부서명, 사원 수)
SELECT 
	d.department_name,
	COUNT(e.employee_id ) AS 사원수 
FROM departments d
LEFT JOIN employees e 
ON d.department_id = e.department_id 
GROUP BY d.department_name -- 기준 테이블이 departments이기 때문에 결국 노출해야 하는 것은 부서명
ORDER BY 사원수 DESC;

-- COALESCE: 주어진 인수들 중 NULL이 아닌 첫번째 값을 반환하는 표준 SQL 함수
-- 만약 NULL 이라면 대체 값으로 치환할 수 있는 기능을 제공 
SELECT 
	d.department_name,
	COALESCE((
		SELECT 
			COUNT(*)
		FROM employees e
		WHERE e.department_id = d.department_id
		GROUP BY department_id
	), 0)  AS 사원수
FROM departments d
ORDER BY 사원수 DESC;


-------------------------------------------------------------------------------------------

-- FROM절 서브쿼리 (인라인 뷰) - '뷰'는 가상 테이블, 인라인, SQL 작성하는 과정에서 가상 테이블 만들겠다
-- FROM절 테이블 쓴다, departments 실제로 구조화된 테이블이 있다 
-- FROM절에 서브쿼리 작성하겠다 = 임시 테이블로 조회하겠다 
-- 특정 테이블 전체가 아닌 SELECT 통해 일부 데이터를 조회한 것을 가상 테이블로 사용하고 싶을 때


-- 각 부서별 평균 급여 계산
SELECT 
	department_id,
	AVG(salary)
FROM employees e
GROUP BY department_id;

-- 개별 직원의 이름과 부서별 평균 급여를 한 줄에 표기
-- first_name, salary, avg_salary
SELECT 
	e.first_name, e.salary,
	tbl.avg_salary 
FROM employees e
JOIN (
	SELECT 
		department_id,
		TRUNC(AVG(salary), 0) AS avg_salary
	FROM employees
	GROUP BY department_id
) tbl
ON e.department_id = tbl.department_id; 


-- 부서 별 최고 급여를 받는 직원을 조회
-- 사원 이름, 급여, 부서 이름
SELECT
	e.first_name, 
	e.salary,
	d.department_name 
FROM employees e
JOIN (SELECT 
	department_id, 
	MAX(salary) AS max_salary
FROM employees
GROUP BY department_id) max_sal
ON e.department_id = max_sal.department_id 
AND e.salary = max_sal.max_salary 
JOIN departments d
ON e.department_id = d.department_id;

