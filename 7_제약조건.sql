-- 테이블 생성과 제약조건
-- : 테이블에 부적절한 데이터가 입력되는 것을 방지하기 위해 규칙을 설정하는 것.

-- 테이블 열레벨 제약조건 (PRIMARY KEY, UNIQUE, NOT NULL, FOREIGN KEY, CHECK)
-- 키워드를 통해 각각의 컬럼 별 규칙 설정 가능
-- PRIMARY KEY: 테이블의 고유 식별 컬럼입니다. (주요 키) - 왠만한 테이블 PRIMARY KEY 가진다
-- UNIQUE: 유일한 값을 갖게 하는 컬럼 (중복값 방지) 
-- NOT NULL: null을 허용하지 않음. (필수값)
-- FOREIGN KEY: 참조하는 테이블의 PRIMARY KEY를 저장하는 컬럼
-- CHECK: 정의된 형식만 저장되도록 허용.

-- 컬럼 레벨 제약 조건 (컬럼 선언마다 제약조건 지정)
-- 제약조건 식별자는 생략이 가능합니다. (PostgreSQL에서 알아서 이름 지음)
-- 컬럼 선언하면서 바로 옆에 제약조건 넣는 방식

CREATE TABLE dept (
	dept_no BIGSERIAL CONSTRAINT dept_deptno_pk PRIMARY KEY, -- 제약조건 이름 필수 아님, 생략 가능
	dept_name VARCHAR(14) NOT NULL CONSTRAINT dept_deptname_uk UNIQUE, -- NOT NULL은 거의 대부분 이름 지정하지 않는다 
	loca INTEGER CONSTRAINT dept_loca_locid_fk REFERENCES locations(location_id), -- foriegn key로 연결하고자 하는 것에 맞춰주어야 한다, locatios location id 외의 다른 값 막아버린다  
	dept_date TIMESTAMP DEFAULT NOW(), -- 테이블에 insert 값 넣지 않아도 된다 dept_date를 따로 보낼 필요 없다 
	dept_bonus NUMERIC(8) CONSTRAINT dept_bonus_ck CHECK(dept_bonus > 100000), -- 최대 8 자리 수 강제 
	man_gender VARCHAR(1) CONSTRAINT dept_gender_ck CHECK(man_gender IN ('M', 'F')) -- manager gender가 M or F 이어야 한다 
);

-- != 제약 조건 걸어주는 컬럼이 누구인지만 다른 것 
-- 가독성이 좋기 때문에 실무에서 선호 
-- 테이블 레벨 제약 조건 (모든 열을 선언 후 제약조건을 한번에 취하는 방식)
-- + 테이블 생성 후 제약조건 추가하는 경우도 있다 
CREATE TABLE dept (
    dept_no BIGSERIAL,
    dept_name VARCHAR(14) NOT NULL,
    loca INTEGER, 
    dept_bonus NUMERIC(10),
    man_gender VARCHAR(1),
    
    CONSTRAINT dept_deptno_pk PRIMARY KEY(dept_no),
    CONSTRAINT dept_deptname_uk UNIQUE(dept_name),
    CONSTRAINT dept_loca_locid_fk FOREIGN KEY(loca) REFERENCES locations(location_id),
    CONSTRAINT dept_bonus_ck CHECK(dept_bonus > 1000000),
    CONSTRAINT dept_gender_ck CHECK(man_gender IN ('M', 'F'))
);

-- 제약조건 확인 (FK는 부모테이블(참조테이블)에 없는 값을 INSERT할 수 없다
-- 제약조건은 update, delete 진행할 때도 항상 검사의 대상이 된다
INSERT INTO dept
	(dept_name, loca, dept_bonus, man_gender)
VALUES
	('마케팅', 1800, 500000, 'F');

SELECT * FROM dept;

UPDATE dept
SET loca = 4000
WHERE dept_no = 2; -- 실패 (fk 위반)

UPDATE dept
SET loca = 5
WHERE dept_no = 2; -- 실패 (pk 위반)

UPDATE dept
SET dept_bonus = 1000
WHERE dept_no = 2 -- 실패 (check 위반)

-- 타 테이블에서 나의 PK를 참조하는 경우 삭제가 마음대로 안 된다 
DELETE FROM locations 
WHERE location_id = 1800;

-- 참조하지 않는 경우 삭제 가능
DELETE FROM locations 
WHERE location_id = 3000;

-- 제약 조건 삭제 (제약 조건 이름으로)
ALTER TABLE dept
DROP CONSTRAINT dept_gender_ck;

-- 제약 조건 추가 (꼭 테이블 생성할 때만 지정할 수 있는 게 아니다 )
ALTER TABLE dept
ADD CONSTRAINT man_gender_ck CHECK(man_gender IN ('M', 'F'));
