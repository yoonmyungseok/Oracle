/*
    <VIEW 뷰>
    SELECT(조회용커리문)을 저장해둘 수 있는 표 형태의 객체
    (자주 쓰일법한 긴 SELECT문을 저장해두면 그 긴 SELECT문을 매번 작성해서 다시 조회할 필요가 없음)
    임시테이블 같은 존재(실제 데이터가 담겨있는것은 아니다)
*/

-----실습 문제-----
-- '한국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명, 직급명 조회하시오
-->>오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
WHERE E.DEPT_CODE=D.DEPT_ID AND D.LOCATION_ID=L.LOCAL_CODE AND L.NATIONAL_CODE=N.NATIONAL_CODE AND E.JOB_CODE=J.JOB_CODE AND NATIONAL_NAME='한국';
-->>ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID=L.LOCAL_CODE)
JOIN NATIONAL N USING(NATIONAL_CODE)
JOIN JOB J USING(JOB_CODE)
WHERE NATIONAL_NAME='한국';

/*
    1. VIEW 생성 방법
    [표현법]
    CREATE VIEW 뷰명 AS (서브쿼리); 
    =>단순히 뷰를 생성하는 목적
    
    CREATE OR REPLACE VIEW 뷰명 AS (서브쿼리); 
    =>뷰 생성 시 기존에 중복된 이름의 뷰가 없다면 새로 뷰를 추가하고 
        기존에 중복된 이름의 뷰가 있다면 해당 뷰를 변경하는 옵션
*/
--[참고]
SELECT *
FROM(SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
    WHERE E.DEPT_CODE=D.DEPT_ID(+)
    AND D.LOCATION_ID=L.LOCAL_CODE(+) 
    AND L.NATIONAL_CODE=N.NATIONAL_CODE(+) 
    AND E.JOB_CODE=J.JOB_CODE );
    
--위의 복잡한 SELECT문을 서브쿼리 삼아서 뷰 생성
CREATE VIEW VW_EMPLOYEE
AS (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
    WHERE E.DEPT_CODE=D.DEPT_ID(+)
    AND D.LOCATION_ID=L.LOCAL_CODE(+) 
    AND L.NATIONAL_CODE=N.NATIONAL_CODE(+) 
    AND E.JOB_CODE=J.JOB_CODE 
);
--insufficient privileges
--현재 KH 계정에 CREATE VIEW 권한이 없어서 오류 발생
--해결방법: 관리자 계정으로 접속해서 GRANT CREATE VIEW TO KH;

--이 부분만 관리자 계정으로 접속해서 실행--
GRANT CREATE VIEW TO KH;
----------------------------------
SELECT * FROM VW_EMPLOYEE;
--위와 같이 복잡한 서브쿼리를 이용하여 그때그때 필요한 데이터들만 조회하는것 보다
--한 번 서브쿼리로 뷰를 생성 후 해당 뷰명으로 SELECT 문을 이용하여 간단하게 조회 가능하다

-- '한국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명, 직급명 조회하시오
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME='한국';

---'러시아'에서 근무하는 사원
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME='러시아';

--'러시아'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명, 직급명, 보너스까지 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME, BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME='러시아';
--VW_EMPLOYEE 뷰에 BONUS 컬럼이 없기 때문에 오류 발생

--보너스 컬럼이 없는 뷰에서 보너스도 조회하고 싶을 경우
--CREATE OR REPLACE VIEW 명령어를 쓴다
CREATE OR REPLACE VIEW VW_EMPLOYEE
AS (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME, BONUS
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
    WHERE E.DEPT_CODE=D.DEPT_ID(+)
    AND D.LOCATION_ID=L.LOCAL_CODE(+) 
    AND L.NATIONAL_CODE=N.NATIONAL_CODE(+) 
    AND E.JOB_CODE=J.JOB_CODE 
);

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME, BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME='러시아';

--뷰는 논리적인 가상테이블=>실질적으로 데이터를 저장하고 있지 않음
--(뷰의 정의 자체가 SELECT문을 저장==단순히 쿼리문이 TEXT 문구로 저장되어 있음)
--USER_VIEWS 데이터딕셔너리: 해당 계정이 가지고 있는 VIEW들에 대한 정보들을 가지고 있는 관리용 테이블
SELECT * FROM USER_VIEWS;

------------------------------------------------------------------------------
/*
    *뷰 컬럼에 별칭 부여
    서브쿼리의 SELECT 절에 함수나 산술연산이 기술되어 있는 경우 반드시 별칭 지정
    
*/

--사원의 사번, 이름, 직급명, 성별, 근무년수를 조회할 수 있는 SELECT문을 뷰로 정의
CREATE OR REPLACE VIEW VW_EMP_JOB
AS (
    SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여'), EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE) 
    FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
);
--별칭을 지정하지 않아 오류 발생
--must name this expression with a column alias
--ALIAS : 별칭

CREATE OR REPLACE VIEW VW_EMP_JOB
AS (
    SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') "성별", EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE) "근무년수"
    FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
);
--뷰 생성 성공

SELECT * FROM VW_EMP_JOB;

--또 다른 방법으로 별칭 부여 가능 (단, 모든 컬럼에 대한 별칭을 다 기술해야함)
CREATE OR REPLACE VIEW VW_EMP_JOB (사번, 이름, 직급명, 성별, 근무년수)
AS (
    SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여'), EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE)
    FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
);

SELECT * FROM VW_EMP_JOB;

SELECT 사번, 근무년수
FROM VW_EMP_JOB;

SELECT 사번, 이름, 직급명
FROM VW_EMP_JOB
WHERE 성별='여';

SELECT *
FROM VW_EMP_JOB
WHERE 근무년수 >=20;

--뷰를 삭제하고 싶다면?
DROP VIEW VW_EMP_JOB;

-----------------------------------------------------------

/*
    생성된 뷰를 이용해서 (INSERT,UPDATE, DELETE) 사용 가능
    단, 뷰를 통해서 변경하게 되면 실제 원래 데이터가 담겨있던 실질적인 테이블(베이스테이블)에도 적용이 된다
*/

CREATE OR REPLACE VIEW VW_JOB
AS (
    SELECT * FROM JOB
);

SELECT  * FROM VW_JOB;
SELECT * FROM JOB;

--뷰에 INSERT
INSERT INTO VW_JOB
VALUES('J8','인턴');

--베이스테이블 JOB에도 값이 INSERT 된 것을 확인 가능

--뷰에 UPDATE
-- JOB_CODE가 J8인 JOB_NAME을 알바로 UPDATE

UPDATE VW_JOB SET JOB_NAME='알바'
WHERE JOB_CODE='J8';

--베이스테이블 JOB에도 값이 UPDATE 된 것을 확인 가능

--뷰에 DELETE
--JOB_CODE가 J8인 행을 삭제
DELETE FROM VW_JOB
WHERE JOB_CODE='J8';

--베이스테이블 JOB에도 값이 DELETE 된 것을 확인 가능
----------------------------------------------------------------------------------

/*
    하지만 뷰를 가지고 DML이 불가능한 경우가 더 많음
    1) 뷰에 정의되어 있지 않은 컬럼을 조작하는 경우
    2) 뷰에 정의되어 있지 않은 컬럼 중에 베이스테이블 상에 NOT NULL 제약조건이 지정된 경우
    3) 산술연산식 또는 함수를 통해서 정의되어 있는 경우
    4) 그룹함수나 GROUP BY 절이 포함되어있을 경우
    5) DISTINCT 구문이 포함된 경우
    6) JOIN을 이용해서 여러 테이블을 매칭시켜놓은 경우
*/

--1) 뷰에 정의되어 있지 않은 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW VW_JOB AS
(
    SELECT JOB_CODE FROM JOB
);

SELECT * FROM VW_JOB;

--INSERT (오류)
INSERT INTO VW_JOB(JOB_CODE, JOB_NAME) VALUES('J8','인턴');

--UPDATE(오류)
UPDATE VW_JOB SET JOB_NAME='인턴' WHERE JOB_CODE='J7';

--현재 VW_JOB 뷰에 존재하지 않는 JOB_NAME 컬럼에 값을 추가, 변경, 삭제하고자 하여 오류 발생
--"JOB_NAME": invalid identifier

-----------------------------------------------------------------------------------------------------

--2) 뷰에 정의되어 있지 않은 컬럼 중에 베이스테이블 상에 NOT NULL 제약조건이 지정된 경우
CREATE OR REPLACE VIEW VW_JOB
AS(SELECT JOB_NAME FROM JOB);

SELECT * FROM VW_JOB;

--INSERT
INSERT INTO VW_JOB VALUES ('인턴'); --JOB 테이블에 (NULL, '인턴')이 삽입되려고 함
--cannot insert NULL into ("KH"."JOB"."JOB_CODE")

--UPDATE(성공)
UPDATE VW_JOB SET JOB_NAME='알바' WHERE JOB_NAME='사원';

--UPDATE(오류)
UPDATE VW_JOB
SET JOB_CODE=NULL
WHERE JOB_NAME='알바';
--VW_JOB에 JOB_CODE 컬럼이 없을 뿐만 아니라 NOT NULL 제약조건인데 NULL을 넣고자해서 오류

--DELETE
DELETE FROM VW_JOB
WHERE JOB_NAME='대리';
--J6 직급 데이터를 끌어다 쓰고 있는 자식 데이터가 있기 때문에 삭제 불가

DELETE FROM VW_JOB
WHERE JOB_NAME='알바';
--만약에 J8 직급코드였다면 자식 데이터가 없기 때문에 삭제가 가능했을 것임

-----------------------------------------------

--3) 산술연산식 또는 함수를 통해서 정의되어 있는 경우
--사원의 사번, 이름, 급여, 연봉에 대해서 조회하는 뷰
CREATE OR REPLACE VIEW VW_EMP_SAL
AS (SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 "연봉" FROM EMPLOYEE);

SELECT * FROM VW_EMP_SAL;

--INSERT(오류)
INSERT INTO VW_EMP_SAL
VALUES(400,'정진훈',3000000,36000000);
--virtual column not allowed here

--UPDATE(오류)
UPDATE VW_EMP_SAL
SET 연봉=80000000
WHERE EMP_ID=200;

--UPDATE
UPDATE VW_EMP_SAL
SET SALARY=7000000
WHERE EMP_ID =200;

--DELETE 
DELETE FROM VW_EMP_SAL
WHERE 연봉=72000000;

SELECT * FROM EMPLOYEE;

------------------------------------------

--4) 그룹함수식이나 GROUP BY 절이 포함될 경우
--부서별 급여합, 평균급여를 조회하는 뷰
CREATE OR REPLACE VIEW VW_GROUPDEPT AS (SELECT DEPT_CODE, SUM(SALARY) "급여합", FLOOR(AVG(SALARY)) "평균급여" FROM EMPLOYEE GROUP BY DEPT_CODE);

SELECT * FROM VW_GROUPDEPT;

--INSERT(오류)
INSERT INTO VW_GROUPDEPT VALUES ('D0', 80000000, 4000000);

--UPDATE(오류)
UPDATE VW_GROUPDEPT
SET 급여합=8000000
WHERE DEPT_CODE='D1';

--UPDATE(오류)
UPDATE VW_GROUPDEPT
SET DEPT_CODE='D0'
WHERE DEPT_CODE='D1';

--DELETE(오류)
DELETE FROM VW_GROUPDEPT
WHERE DEPT_CODE='D1';

------------------------------------------------------------------------------

--5) DISTINCT 구문이 포함된 경우
CREATE OR REPLACE VIEW VW_DT_JOB
AS (SELECT JOB_CODE FROM EMPLOYEE);

SELECT * FROM VW_DT_JOB;

--INSERT(오류)
INSERT INTO VW_DT_JOB VALUES ('J8');

--UPDATE(오류)
UPDATE VW_DT_JOB
SET JOB_CODE='J8'
WHERE JOB_CODE='J7';

--DELETE(오류)
DELETE FROM VW_DT_JOB
WHERE JOB_CODE='J7';

---------------------------------------

--6) JOIN을 이용해서 여러 테이블을 매칭시켜놓은 경우
CREATE OR REPLACE VIEW VW_JOINEMP
AS (SELECT EMP_ID, EMP_NAME, DEPT_TITLE FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID));

SELECT * FROM VW_JOINEMP;

--INSERT(오류)
INSERT INTO VW_JOINEMP VALUES (888, '조세오', '총무부');
--여러개의 테이블이 조인된 뷰는 INSERT가 되지 않음

--UPDATE(성공)
UPDATE VW_JOINEMP SET EMP_NAME='서동일' WHERE EMP_ID=200;
--EMPLOYEE 테이블에만 반영 가능한 UPDATE 문이라 수행 성공

SELECT * FROM EMPLOYEE;

--DELETE
DELETE FROM VW_JOINEMP WHERE EMP_ID=200;

DELETE FROM VW_JOINEMP WHERE DEPT_TITLE='총무부';

SELECT * FROM VW_JOINEMP;
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

ROLLBACK;

--------------------------------------------------------------------------

/*
    VIEW 옵션
    
    [상세표현법]
    CREATE OR REPLACE [FORCE / NOFORCE] VIEW 뷰명 
    AS (서브쿼리)
    WITH CHECK OPTION
    WITH READ ONLY;
    
    1) FORCE / NOFORCE
    -FORCE: 서브쿼리에 기술된 테이블이 존재하지 않더라도 뷰를 생성하겠다
    -NOFORCE: 서브쿼리에 기술된 테이블이 반드시 존재해야만 뷰를 생성하겠다(생략 시 기본값)
    
    2) WITH CHECK OPTION: 서브쿼리의 조건절에 기술된 내용에 만족하는 값으로만 DML이 가능
                                    조건에 부합하지 않는 값으로 수정하는 경우 오류 발생
                                    
    3) WITH READ ONLY: 뷰에 대해 조회만 가능
*/

--1) FORCE / NOFORCE
CREATE OR REPLACE VIEW VW_TEST AS (SELECT TCODE, TNAME, TCONTENT FROM TT);
--TT라는 테이블이 존재하지 않아서 오류 발생
--table or view does not exist

CREATE OR REPLACE FORCE VIEW VW_TEST AS (SELECT TCODE, TNAME, TCONTENT FROM TT);
--경고: 컴파일 오류와 함께 뷰가 생성되었습니다.

SELECT * FROM VW_TEST;
--단, 해당 TT라는 이름의 테이블이 생성 된 이후부터는 해당 뷰 사용 가나ㅡㅇ
CREATE TABLE TT(
    TCODE NUMBER,
    TNAME VARCHAR2(30),
    TCONTENT VARCHAR2(50)
);
SELECT * FROM VW_TEST;

--2) WITH CHECK OPTION
CREATE OR REPLACE VIEW VW_EMP
AS(SELECT * FROM EMPLOYEE WHERE SALARY >=3000000) WITH CHECK OPTION;

SELECT * FROM VW_EMP;

UPDATE VW_EMP SET SALARY=2000000 WHERE EMP_ID=200;

UPDATE VW_EMP SET SALARY=4000000 WHERE EMP_ID=200;

ROLLBACK;

--3) WITH READ ONLY
CREATE OR REPLACE VIEW VW_EMPBONUS
AS (SELECT EMP_ID, EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS IS NOT NULL) WITH READ ONLY;

SELECT * FROM VW_EMPBONUS;

DELETE FROM VW_EMPBONUS WHERE EMP_ID=204;
--수정 불가
--cannot perform a DML operation on a read-only view

/*
    *접두사
    보통은 이름을 붙일 때 의미부여를 하는데
    어느 종류의 객체의 이름인지 접두사를 붙임
    
    -테이블명: TB_XXXX
    -시퀀스명: SEQ_XXX
    -뷰명: VW_XXXX
*/

