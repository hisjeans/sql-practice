
-- 1. 시퀀스 생성(순차적으로 증가, 감소하는 값을 만들어 주는 객체)
CREATE SEQUENCE test_seq -- 테이블은 () 열지만, 시퀀스는 () 열지 않고 가로로 작성 - 보기 편하기 위해 그대로 쭉 작성하지 않고 내려서 작성
	START WITH 1 -- 시작값
	INCREMENT BY 1 -- 증감값
	MAXVALUE 10 -- 최대값, test_seq는 10이 되면 끝난다 
	MINVALUE 1 -- 최소값
	-- 1부터 시작해 10까지 증가할 것이기 때문에 minvalue 따로 설정할 필요 없지만
	-- 만일 10부터 시작해 1 감소할 것이라면 minvalue 작성해야 한다 
	NO CYCLE; -- 순환 여부 (기본값이 NOCYCLE이라 생략 가능)
	

CREATE TABLE test_tbl(
	test_no INT PRIMARY KEY,
	test_msg VARCHAR(100)
);


-- 2. 데이터 삽입(시퀀스 값 활용)
INSERT INTO test_tbl
VALUES(nextval('test_seq'), 'test message'); 

SELECT * FROM test_tbl;

-- 3. 시퀀스 단독 조회
SELECT currval('test_seq');


-- 4. 시퀀스 속성 수정
-- START WITH 은 수정할 수 없다!
ALTER SEQUENCE test_seq MAXVALUE 9999;
ALTER SEQUENCE test_seq INCREMENT BY 5;

-- 5. 시퀀스 삭제
DROP SEQUENCE test_seq;