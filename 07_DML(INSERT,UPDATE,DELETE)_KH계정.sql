/*
    <DML: DATA MANIPULATION LANGUAGE>
    데이터 조작 언어
    
    테이블에 새로운 데이터를 삽입 (INSERT)하거나, 기존의 데이터값을 수정(UPDATE)하거나, 기존의 데이터 값을 삭제(DELETE)하는 구문
    추가적으로 SELECT문도 DML에 포함할 수 있음
*/

/*
    1. INSERT: 테이블에 새로운 행을 추가하는 구문
    
    [표현법]
    1) INSERT INTO 테이블명 VALUES(값, 값, 값,...);
    =>해당 테이블에 모든 컬럼에 대해 추가하고자 하는 값을 내가 직접 "모두" 제시해서 한 행을 INSERT 하고자 할 때 사용하는 구문
    주의할점: 컬럼 순번을 지켜서 VALUES 괄호 안에 값을 나열해야 함
    -부족한 갯수로 값을 나열했을 경우: NOT ENOUGH VALUE 오류
    -값을 컬럼의 갯수보다 더 많이 제시했을 경우: TOO MANY VALUES 오류
*/

--EMPLOYEE 테이블에 INSERT
SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE VALUES('900', '김말똥', '870215-2000000', 'kim_md@kh.or.kr', '01011112222', 'D1', 'J7', 'S3', 4000000, 0.2, '200', SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE WHERE EMP_ID ='900';

/*
    2) INSERT INTO 테이블명 (컬럼명, 컬럼명, 컬럼명) VALUES (값, 값, 값);
    =>해당 테이블에 특정 컬럼만 선택해서 그 컬럼에 추가할 값만 "부분적으로" 제시하고자 할 때 사용
    그래도 한 행 단위로 추가되기 때문에 선택이 안된 컬럼에 대해서는 기본적으로 NULL 값이 들어감
    (단, 기본값 DEFAULT를 설정한 경우에는 DEFAULT 값이 추가된다)
    주의할점: NOT NULL 제약조건이 걸려있는 컬럼은 반드시 선택해서 값을 직접 제시해야한다
    단, NOT NULL 제약조건이 걸려있는 컬럼이라고 하더라도 DEFAULT 설정이 함께 걸려있는 경우에는 선택 안해도 됨
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, SAL_LEVEL, HIRE_DATE) VALUES('901', '박말순', '990101-1234567', 'D1', 'J2', 'S1', SYSDATE);

SELECT * FROM EMPLOYEE WHERE EMP_ID ='901';

/*
    3) INSERT INTO 테이블명(서브쿼리);
    =>VALUES로 값을 일일이 기입하는것 대신에 서브쿼리로 조회한 결과물들을 통째로 INSERT하는 구문(여러 행을 INSERT 시킬 수 있다)
*/

--새로운 테이블 만들기
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

--전체 사원들의 사번, 이름, 부서명을 조회한 결과를 EMP_01 테이블에 통째로 추가
INSERT INTO EMP_01
(
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE, DEPARTMENT
    WHERE DEPT_CODE=DEPT_ID(+)
);
--서브쿼리를 이용하면 통째로 한번에 여러 개의 행이 추가 가능하다
SELECT * FROM EMP_01;

/*
    2. INSERT ALL
    두 개 이상의 테이블에 각각 INSERT하고 싶을 때 사용
    단, 사용되는 서브쿼리가 동일한 경우 사용
*/
--새로운 테이블을 먼저 만들기
--첫번째 테이블 : 급여가 300만원 이상인 사원들의 사번, 사원명, 직급명에 대해서 보관할 테이블
CREATE TABLE EMP_JOB(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    JOB_NAME VARCHAR2(20)
);

SELECT * FROM EMP_JOB;

--두번째 테이블: 급여가 300만원 이상인 사원들의 사번, 사원명, 부서명에 대해서 보관할 테이블
CREATE TABLE EMP_DEPT(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_DEPT;

--급여가 300만원 이상인 사원들의 사번, 사원명, 직급명, 부서명 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE SALARY >=3000000;

/*
    1)INSERT ALL 
    INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...) 
    INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
    (서브쿼리);
*/

--EMP_JOB 테이블에는 급여가 300만원 이상인 사원들의 EMP_ID, EMP_NAME, JOB_NAME을 삽입
--EMP_DEPT 테이블에는 급여가 300만원 이상인 사원들의 EMP_ID, EMP_NAME, DEPT_TITLE을 삽입
INSERT ALL 
INTO EMP_JOB VALUES(EMP_ID, EMP_NAME, JOB_NAME)
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_TITLE)
(SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE SALARY >=3000000);

SELECT * FROM EMP_JOB;
SELECT * FROM EMP_DEPT;

--INSERT ALL 시 조건을 사용해서 각 테이블에 값 INSERT 가능
--사번, 사원명, 입사일, 급여 (EMP_OLD 테이블에 저장) => 단, 2010년 이전에 입사한 사원
CREATE TABLE EMP_OLD AS (SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY FROM EMPLOYEE WHERE 1=0);

--사번, 사원명, 입사일, 급여 (EMP_NEW 테이블에 저장)=>단, 2010년 부터 입사한 사원
CREATE TABLE EMP_NEW AS (SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY FROM EMPLOYEE WHERE 1=0);

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

--각 범위에 맞는 사원들을 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY FROM EMPLOYEE WHERE HIRE_DATE < '2010/01/01'; --2010년도 이전 입사자들만 조회(9명)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY FROM EMPLOYEE WHERE HIRE_DATE >= '2010/01/01'; --2010년도 부터 입사자들만 조회(16명)

/*
    2)  INSERT ALL
        WHEN 조건식1 THEN INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
        WHEN 조건식2 THEN INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
        (공통적으로 사용할 서브쿼리);    
*/

INSERT ALL 
WHEN HIRE_DATE < '2010/01/01' THEN INTO EMP_OLD VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >='2010/01/01' THEN INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
(SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY FROM EMPLOYEE);

/*
    3. UPDATE
    테이블에 기록된 기존의 데이터를 수정하는 구문
    
    [표현법]
    UPDATE 테이블명 
    SET 컬럼명=바꿀값, 컬럼명=바꿀값, 컬럼명=바꿀값 =>여러 개의 컬럼값을 동시에 수정 가능( ,로 나열해야 함)
    WHERE 조건; =>WHERE 절을 생략 가능 단, 생략시 전체 모든 행의 데이터가 다 변경되어버림(주의)
*/

--테스트용 복사본 테이블을 생성
CREATE TABLE DEPT_COPY AS (SELECT * FROM DEPARTMENT);
SELECT * FROM DEPT_COPY;

--DEPT_COPY 테이블의 D9 부서의 부서명을 '전략기획팀'으로 수정
UPDATE DEPT_COPY 
SET DEPT_TITLE='전략기획팀'
WHERE DEPT_ID='D9';

--주의사항) WHERE절을 누락했을 경우
UPDATE DEPT_COPY
SET DEPT_TITLE='총무부';
--전체 행의 모든 DEPT_TITLE의 값이 다 총무부로 변경되어버림

--복사본 테이블
CREATE TABLE EMP_SALARY AS (SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS FROM EMPLOYEE);

SELECT * FROM EMP_SALARY;

--EMP_SALARY 테이블에 노옹철 사원의 급여를 1000만원으로 변경
UPDATE EMP_SALARY 
SET SALARY=10000000
WHERE EMP_NAME='노옹철';


--EMP_SALARY 테이블의 선동일 사원의 급여를 700만원으로, 보너스를 0.2로 변경
UPDATE EMP_SALARY
SET SALARY=7000000, BONUS=0.2
WHERE EMP_NAME='선동일';

--전체 사원의 급여를 기존 급여에 20프로 인상한 금액으로 변경(기존급여*1.2)
UPDATE EMP_SALARY
SET SALARY=SALARY*1.2;


/*
    *UPDATE 시에 서브쿼리를 사용하기
    서브쿼리를 수행한 결과값으로 변경하겠다
    
    [표현법]
    UPDATE 테이블명
    SET 컬럼명=(서브쿼리)
    WHERE 조건;
*/

--EMP_SALARY 테이블의 김말똥 사원의 부서코드를 선동일 사원의 부서코드로 변경
UPDATE EMP_SALARY
SET DEPT_CODE=(SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME='선동일')
WHERE EMP_NAME='김말똥';

SELECT * FROM EMP_SALARY;

--방명수 사원의 급여와 보너스를 유재식 사원의 급여와 보너스로 변경
UPDATE EMP_SALARY
SET (SALARY,BONUS)=(SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME='유재식')
WHERE EMP_NAME='방명수';

SELECT * FROM EMP_SALARY WHERE EMP_NAME IN ('방명수', '유재식');

--[참고] UPDATE 시에도 변경할 값에 있어서 해당 컬럼에 대한 제약조건에 위배되면 안됨

--송중기 사원의 사번을 200번으로 변경
SELECT * FROM EMPLOYEE;

UPDATE EMPLOYEE
SET EMP_ID='200'
WHERE EMP_NAME='송종기';
--unique constraint (KH.EMPLOYEE_PK) violated
--PRIMARY KEY 제약조건에 위배

--사번이 200번인 사원의 이름을 NULL로 변경
UPDATE EMPLOYEE
SET EMP_NAME=NULL
WHERE EMP_ID='200';
--cannot update ("KH"."EMPLOYEE"."EMP_NAME") to NULL
--NOT NULL 제약조건에 위배

--여태까지 연습했던 내용들을 확정짓겠다
COMMIT;

---------------------------------------------------------------------------------------------------------
/*
    4. DELETE
    테이블에 기록된 데이터를 삭제하는 구문
    
    [표현법]
    DELETE FROM 테이블명
    WHERE 조건; => WHERE 절은 생략 가능 단, 생략 시 모든 행에 대해서 전부 다 삭제(주의)
*/

--EMPLOYEE 테이블의 모든 행들을 삭제
SELECT * FROM EMPLOYEE;
DELETE FROM EMPLOYEE;
ROLLBACK; --마지막 커밋 시점까지 복원
SELECT * FROM EMPLOYEE;

--김말똥 사원과 박말순 사원만 삭제
DELETE FROM EMPLOYEE WHERE EMP_NAME IN ('김말똥','박말순');
SELECT * FROM EMPLOYEE;
COMMIT;

--DEPARTMENT 테이블로부터 DEPT_ID가 D1인 부서 삭제
DELETE FROM DEPARTMENT WHERE DEPT_ID='D1';
--integrity constraint (KH.SYS_C007197) violated - child record found
--삭제 안됨=> EMPLOYEE 테이블에서 D1을 가져다 쓰는 자식데이터가 있기 때문에

--DEPARTMENT 테이블로부터 DEPT_ID가 D3인 부서 삭제
DELETE FROM DEPARTMENT WHERE DEPT_ID='D3';
--삭제됨: D3을 가져다 쓰고있는 자식데이터가 없기 때문에

SELECT * FROM DEPARTMENT;


--DEPARTMENT 테이블 DELETE 전으로 복구
ROLLBACK;

------------------------------------------------------------------------------------------

/*
    * TRUNCATE: 테이블의 전체 행을 삭제할 때 사용하는 구문(절삭)
                    DELETE FROM 테이블명; 과 같은 역할
                    단, DELETE 보다 수행속도가 더 빠르다
                    별도의 조건 제시 불가, ROLLBACK이 불가함
    [표현법]
    TRUNCATE TABLE 테이블명;    |       DELETE FROM 테이블명;
    =============================================
    별도의 조건제시 불가            |       특정 조건제시 가능
    수행속도가 더 빠름               |       수행속도가 좀 느림
    ROLLBACK이 불가                |       ROLLBACK 가능
*/

SELECT * FROM EMP_SALARY;

DELETE FROM EMP_SALARY;
ROLLBACK;

TRUNCATE TABLE EMP_SALARY; --Table EMP_SALARY이(가) 잘렸습니다.
