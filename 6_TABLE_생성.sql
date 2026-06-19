
CREATE TABLE dept (
	dept_no BIGSERIAL,
	dept_name VARCHAR(14),
	loca VARCHAR(15), -- 타 DBMS는 ()안의 숫자를 byte 크기, postgress는 허용되는 글자 수 
	dept_date TIMESTAMP DEFAULT NOW(), -- 테이블에 insert 값 넣지 않아도 된다 dept_date를 따로 보낼 필요 없다 
	dept_bonus NUMERIC(8) -- 최대 8 자리 수 강제 
);

SELECT * FROM dept;

INSERT INTO dept
	(dept_name, loca, dept_bonus) -- dept_bonus 자릿수
VALUES('test', '경기도', 2000000);


-- 컬럼명 수정 
ALTER TABLE dept 
RENAME COLUMN dept_bonus TO bonus;

-- 컬럼 추가
ALTER TABLE dept
ADD COLUMN dept_comment VARCHAR(100);

-- 컬럼 삭제
ALTER TABLE dept
DROP COLUMN bonus;

SELECT * FROM dept2;

-- 테이블명 변
ALTER TABLE dept
RENAME TO dept2;

ALTER TABLE dept2
ALTER COLUMN dept_name TYPE VARCHAR(140);

ALTER TABLE dept2
ALTER COLUMN loca TYPE NUMERIC(4); -- location 컬럼에 문자열이 있기 때문에 타입 변경 불가능 

-- 테이블 삭제 종류 두 가지 
-- 테이블 삭제 (구조는 남겨두고 내부 데이터만 모두 삭제)
TRUNCATE TABLE dept2;

-- 테이블 자체 삭제
DROP TABLE dept2;


