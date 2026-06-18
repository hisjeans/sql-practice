-- 표준 SQL로 테이블 구조 확인
SELECT 
	column_name, data_type, is_nullable, column_default 
FROM information_schema."columns"
WHERE table_name='dapartments';

-- INSERT 첫번째 방법 (모든 칼럼 데이터를 한번에 지정해서 삽입)
-- VALUES 같은 경우 순서대로 칼럼 데이터를 전달 (null 허용 칼럼은 안 줘도 된다), 순서는 변할 수 없다 
INSERT INTO departments 
VALUES(300, '마케팅', 100, 1900);

SELECT * FROM departments

INSERT INTO departments 
VALUES(301, '영업');

INSERT INTO departments 
VALUES(302, '아이티영업부');

-- INSERT 두 번째 방법(직접 칼럼을 지목해 저장, null 허용 여부 잘 확인)
-- 칼럼 직접 지목해 사용하는 방식은 순서 크게 상관 없다 
INSERT INTO departments 
	(department_id, location_id, department_name) -- 칼럼 직접 지목
VALUES(305, 1900)

------------------------------------------------------------------------------------

-- UPDATE
-- UPDATE 테이블 이름 SET 칼럼=값, 칼럼=값... WHERE 누구를 수정할지 (조건)
-- 조건을 지정하지 않으면 대상이 테이블 전체가 됨! (주의!)
UPDATE departments
SET department_name='냥!'
WHERE department_id=300;

SELECT * FROM departments;

-- 조건으로 건 데이터가 여러 개라면 여러 개의 데이터가 한 번에 수정된다 
UPDATE departments
SET 
	department_name='IT 부서',
	manager_id=101,
	location_id=2000
WHERE department_id=300; -- 특정 테이블의 각각의 테이블 구분할 수 있는 데이터 PK(Primary Key)
-- 테이블 생성 시 테이블 하나 당 PK 지정 권장
-- departments의 primary key가 department_id
-- PK 특징: null 값 가지지 않고 중복 허용하지 않는다
-- 특정 지목해 update해야 하는 경우 primary key 통해 가능
SELECT * FROM departments;

------------------------------------------------------------------------------------------

DELETE FROM departments 
WHERE department_id = 300; -- WHERE 작성하지 않으면 테이블 전체 행이 대상이 된다 
SELECT * FROM departments;
