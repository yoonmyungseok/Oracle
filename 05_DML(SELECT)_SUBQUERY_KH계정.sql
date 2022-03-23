/*
    <SUBQUERY 서브쿼리>
    하나의 주된 SQL문(SELECT, INSERT, UPDATE, CREATE, ..) 안에 포함된 SELECT문
    메인SQL문을 위해 보조 역할을 하는 쿼리문
*/

--간단 서브쿼리 예시1
--노옹철 사원과 같은 부서인 사원들
--1)먼저 노옹철 사원의 부서코드를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME='노옹철'; --노옹철 사원의 부서코드는 D9임을 알아냄

--2)부서코드가 D9인 사원들을 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE='D9';

--3)위의 두 쿼리문을 합체
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE=(SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME='노옹철');

--간단 서브쿼리 예시2
--전체 사원의 평균 급여보다 더 많은 급여를 받고있는 사원들의 사번, 이름, 직급코드 조회
--1)전체 사원의 평균 급여를 우선 구하겠다
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

--2)평균급여보다 이상인 사원들만 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY>=3047662;

--3)위의 두 단계를 합체시키기
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY>=(SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE);

-------------------------------------------------------------------------------------------------------------------

/*
    서브쿼리 구분
    서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라서 분류됨
    
    -단일행 단일열 서브쿼리 : 서브쿼리 부분을 수행한 결과값이 오로지 1개일 때
    -다중행 단일열 서브쿼리 : 서브쿼리 부분을 수행한 결과값이 여러 행일 때
    -단일행 다중열 서브쿼리 : 서브쿼리 부분을 수행한 결과값이 여러 열일 때
    -다중행 다중열 서브쿼리 : 서브쿼리 부분을 수행한 결과값이 여러 행 여러 열일 때
    
    =>서브쿼리는 기본적으로 WHERE절, HAVING에 들어가기 때문에(WHERE절, HAVING절은 조건식 제시) 서브쿼리를 수행한 결과가 몇행 몇열이냐에 따라서 사용 가능한 연산자의 종류도 달라진다
    
    추가적으로) "인라인 뷰" => 서브쿼리이지만 FROM절에 들어가는 서브쿼리
*/

/*
    1. 단일행 단일열 서브쿼리 (SINGLE ROW SUBQUERY)
    서브쿼리의 조회 결과가 오로지 1개일 경우(1칸)
    
    일반 연산자 사용 가능(=, !=, <=, >, ...)
*/

--전 직원의 평균 급여보다 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
--1) 우선적으로 평균 급여를 구하기
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE; --3047663
-->결과값이 1행 1열, 오로지 1개의 값
--2) 평균급여보다 미만인 사원들의 사원명, 직급코드, 급여 구하기 (메인쿼리 부분)
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < 3047663;

--3) 합치기
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE);

--최저급여를 받는 사원의 사번, 사원명, 직급코드, 급여, 입사일 조회
--1) 최저급여 구하기
SELECT MIN(SALARY)
FROM EMPLOYEE; --1380000
-->결과값이 1행 1열, 오로지 1개의 값
--2) 최저급여를 받는 사원의 정보 구하기
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY=1380000;

--3) 합치기
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY=(SELECT MIN(SALARY) FROM EMPLOYEE);

--노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여조회
--1) 노옹철 사원의 급여 구하기
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='노옹철'; --3700000

--2) 3700000보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY>3700000;

--3) 합치기
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY>(SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME='노옹철');

--노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서명, 급여조회

--1) 노옹철 사원의 급여 구하기
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='노옹철'; --3700000

--2) 3700000보다 더 많이 받는 사원들의 사번, 이름, 부서명, 급여 조회

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID(+) AND SALARY>3700000;

--3) 합치기
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID(+) AND SALARY>(SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='노옹철');

--조인도 함께 가능하다
-->>ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE SALARY>(SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='노옹철');

--전지연 사원이랑 같은 부서인 사원들의 사번, 이름, 휴대폰번호, 직급명 조회(단, 전지연 사원 본인은 제외하고 조회할 것)
--1) 전지연 사원의 부서 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME='전지연'; --D1

--2) 부서코드가 D1인 사원들의 사번, 이름, 휴대폰번호, 직급명 조회
SELECT EMP_ID, EMP_NAME, PHONE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE --연결고리에 대한 조건
AND DEPT_CODE='D1'
AND EMP_NAME!='전지연';

--3) 합치기
SELECT EMP_ID, EMP_NAME, PHONE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE
AND DEPT_CODE=(SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME='전지연')
AND EMP_NAME!='전지연';

-->>ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE=(SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME='전지연') AND EMP_NAME!='전지연';

--부서별 급여 합이 가장 큰 부서 하나만을 조회 (부서코드, 부서명, 급여 합)
--0) 부서별 급여 합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; 

--1) 부서별 급여 합의 최대값  (서브 쿼리 부분)
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;  --17700000

--2) 급여 합이 17700000인 부서 하나만을 조회(부서코드, 부서명, 급여 합)
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID(+)
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY)=17700000; --(그룹함수를 포함한 조건식이라서 HAVING절에 작성)

--3) 합치기
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID(+)
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY)=(SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);

-->>ANSI 구문
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY)=(SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);

-----------------------------------------------------------------------------------------------------------------------------------

/*
    2. 다중행 단일열 서브쿼리(MULTI ROW SUBQUERY)
    서브쿼리의 조회 결과값이 여러 행일 때
    IN : 일치의 의미
    -컬럼명 IN(서브쿼리)  : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면 / NOT IN (~~) 일치하는 값이 없으면 이라는 의미
    -컬럼명 > ANY(서브쿼리)  : 여러개의 결과값 중에서 "하나라도" 클 경우, 즉, 여러개의 결과값 중에서 가장 작은값보다 클 경우
    -컬럼명 < ANY(서브쿼리)  : 여러개의 결과값 중에서 "하나라도" 작을 경우,즉, 여러개의 결과값 중에서 가장 큰값보다 작을 경우
    
    ALL : 모든의 의미
    -컬럼명 > ALL(서브쿼리)  : 여러 개의 결과값의 "모든" 값보다 클 경우, 즉, 여러개의 결과값 중에서 가장 큰값보다 클 경우
    -컬럼명 < ALL(서브쿼리)  : 여러 개의 결과값의 "모든" 값보다 작을 경우, 즉, 여러개의 결과값 중에서 가장 작은값보다 작을 경우
*/

--각 부서별 최고 급여를 받는 사원의 이름, 직급코드, 급여 조회
--1) 우선적으로 각 부서별 최고급여를 조회해야 함
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; --2890000,3660000,8000000,3760000,3900000,2490000,2550000

--2) 위의 급여를 받는 사원들을 조회(메인쿼리 부분)
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2890000,3660000,8000000,3760000,3900000,2490000,2550000);

--3) 합치기
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN(SELECT MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE);

--선동일 또는 유재식 사원과 같은 부서인 사원들을 조회하시오 (사원명, 부서코드, 급여)
--1) 선동일 또는 유재식 사원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('선동일','유재식');--EMP_NAME = '선동일' OR EMP_NAME='유재식'; --'D9','D6'
-->결과값이 2행 1열, 총 2개의 결과값
--2) 부서가 'D9'이거나 'D6'인 사원들을 조회 (메인쿼리 부분)
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9','D6');
--WHERE DEPT_CODE='D9' OR DEPT_CODE='D6';

--3) 합치기
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('선동일','유재식'));

-- 사원<대리<과장<차장<부장
--대리 직급임에도 불구하고 과장 직급보다 급여를 더 많이 받는 직원들을 조회(사번, 이름, 직급명, 급여)
--1) 우선적으로 과장 직급들의 급여를 다 추려내야 함
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='과장'; --2200000,2500000,3760000
-->결과값이 3행 1열, 총 3개의 결과값

--2_1) (메인쿼리 부분_1) 위의 급여보다 높은 급여를 받는 사원들을 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE
AND SALARY > ANY(2200000,2500000,3760000);

--2_2) 직급명이 대리일 경우라는 조건 추가(메인쿼리 부분 완성)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE
AND SALARY > ANY(2200000,2500000,3760000)
AND JOB_NAME='대리';

--3) 합치기
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE
AND SALARY > ANY(SELECT SALARY FROM EMPLOYEE JOIN JOB USING(JOB_CODE) WHERE JOB_NAME='과장')
AND JOB_NAME='대리';

--과장 직급임에도 불구하고 모든 차장 직급의 급여보다 더 많이 받는 직원들을 조회(사번, 이름, 직급명, 급여)
--1) 우선적으로 차장 직급들의 급여를 알아야 함
SELECT SALARY 
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
WHERE JOB_NAME='차장'; --2800000,1550000,2490000,2480000

--2) (메인쿼리 부분) 과장 직급임에도 불구하고 위의 급여보다 모두 큰 금액의 급여를 받는 직원들을 조회(사번, 이름, 직급명, 급여)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
WHERE SALARY > ALL(2800000,1550000,2490000,2480000)
AND JOB_NAME='과장';

--3)합치기
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY 
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
WHERE SALARY > ALL(SELECT SALARY FROM EMPLOYEE E JOIN JOB J USING(JOB_CODE) WHERE JOB_NAME='차장') 
AND JOB_NAME='과장';

------------------------------------------------------------------------

/*
    3. 단일행 다중열 서브쿼리
    조회 결과값은 한 행이지만 나열된 컬럼 수가 여러 개일 때
    (여러개)=(여러개)
    =>순서가 맞아 떨어져야 함
*/

--하이유 사원과 같은 부서코드, 같은 직급코드에 해당되는 사원들을 조회(사원명, 부서코드, 직급코드, 입사일)
--1) 우선적으로 하이유사원의 부서코드, 직급코드를 알아내야 함
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME='하이유';  --'D5' , 'J5'
-->결과값이 1행 2열, 결과값이 2개

--2)  부서코드가 D5이고 직급코드가 J5인 사원들의 이름, 부서코드, 직급코드, 입사일 조회(메인쿼리)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE 
WHERE DEPT_CODE='D5' AND JOB_CODE='J5';

--3) 합치기
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE 
WHERE (DEPT_CODE, JOB_CODE)=(SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE EMP_NAME='하이유');

--참고) 합치기=> 단일행 단일열 서브쿼리 적용(단, 조건에 따라서 서브쿼리의 갯수가 늘어남)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE 
WHERE DEPT_CODE=(SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME='하이유') 
AND JOB_CODE=(SELECT JOB_CODE FROM EMPLOYEE WHERE EMP_NAME='하이유');

--박나라 사원과 같은 직급코드, 같은 사수사번을 가진 사원들의 사번, 이름, 직급코드, 사수사번 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID)=(SELECT JOB_CODE, MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME='박나라');

--------------------------------------------------------------------------------------------

/*
    4. 다중행 다중열 서브쿼리
    서브쿼리 조회 결과값이 여러행 여러열일 경우
    (비교할컬럼명들) IN (서브쿼리)
    =>순서를 맞춰서 작성해야 한다
*/

--각 직급별 최소 급여를 받는 사원들 조회(사번, 이름, 직급코드, 급여)
--1) (서브쿼리 부분) 각 직급별 최소 급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE; --('J2', 3700000), ('J7', 1380000), ('J3',3400000), ('J6',2000000), ('J5',2200000), ('J1',8000000), ('J4',1550000)
-->결과값이 7행 2열, 총 결과값이 14개 =>행별로 묶음 처리했더니 총 7묶음

--2) 위의 목록들 중에서 일치하는 사원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
/*
WHERE (JOB_CODE, SALARY) = ('J2', 3700000)
OR (JOB_CODE, SALARY) = ('J7', 1380000)
OR (JOB_CODE, SALARY) = ('J3', 3400000)
OR (JOB_CODE, SALARY) = ('J6', 2000000)
OR (JOB_CODE, SALARY) = ('J5', 2200000)
OR (JOB_CODE, SALARY) = ('J1', 8000000)
OR (JOB_CODE, SALARY) = ('J4', 1550000)
*/
-->의미는 파악이 되지만 문법에 맞지 않아 오류
WHERE (JOB_CODE, SALARY) IN (('J2',3700000),('J7', 1380000),('J3',3400000), ('J6',2000000), ('J5',2200000), ('J1',8000000), ('J4',1550000));

--3) 합치기
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY) FROM EMPLOYEE GROUP BY JOB_CODE);

--각 부서별 최고 급여를 받는 사원들 조회(사번, 이름, 부서코드, 급여)
--1) 우선적으로 각 부서별 최고 급여 조회 (서브쿼리 부분)
SELECT NVL(DEPT_CODE,'없음'), MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--2) 각 부서별 위의 급여를 받는 사원들 조회(사번, 이름, 부서코드, 급여)
SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'없음'), SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE,'없음'), SALARY) IN (SELECT NVL(DEPT_CODE,'없음'), MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE)
ORDER BY SALARY DESC;
