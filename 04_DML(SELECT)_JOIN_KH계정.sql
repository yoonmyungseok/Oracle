/*
    [ JOIN ]
    두 개 이상의 테이블에서 데이터를 같이 조회하고자 할 때 사용되는 구문
    조회 결과는 하나의 결과물(ResultSet)로 나옴
    
    관계형 데이터베이스에서는 최소한의 데이터로 각각의 테이블에 데이터를 보관하고 있음(중복을 최소화하기 위해서 최대한 쪼개서 보관함)
    =>즉, JOIN 구문을 이용해서 여러개의 테이블 간 "관계"를 맺어서 같이 조회해야 함
    =>단, 무작정 JOIN 구문을 이용해서 조회를 하는게 아니라 테이블 간에 "연결고리"에 해당하는 컬럼을 매칭시켜서 조회해야 함
    
    JOIN은 크게 "오라클 전용 구문"과 "ANSI(미국국립표준협회) 구문"으로 나뉜다
    
                    오라클 전용 구문               |           ANSI 구문(오라클+다른DBMS)
=======================================================================================
                    등가조인                         |           내부조인(INNER JOIN)->JOIN USING / ON
                    (EQUAL JOIN)                   |            외부조인(OUTER JOIN)->JOIN USING       
-----------------------------------------------------------------------------------------------------------------------------------------
                    포괄조인                         |           왼쪽 외부조인(LEFT OUTER JOIN)
                    (LEFT OUTER JOIN)            |           오른쪽 외부조인(RIGHT OUTER JOIN)
                    (RIGHT OUTER JOIN)          |             전체 외부조인(FULL OUTER JOIN)=>오라클에서는 불가
-----------------------------------------------------------------------------------------------------------------------------------------           
        카테시안 곱(CARTESIAN PRODUCT)    |          교차조인(CROSS JOIN)
-----------------------------------------------------------------------------------------------------------------------------------------
            자체조인(SELF JOIN)                   |         JOIN ON 구문 이용
            비등가조인(NON EQUAL JOIN)      |
-----------------------------------------------------------------------------------------------------------------------------------------    
*/
--전체 사원들의 사번, 사원명, 부서코드, 부서명까지 알아내고자 한다면?
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
-->EMPLOYEE 테이블의 DEPT_CODE 컬럼

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;
-->DEPARTMENT 테이블의 DEPT_ID 컬럼

--전체 사원들의 사번, 사원명, 직급코드, 직급명을 알아내고자 한다면?
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;
-->EMPLOYEE 테이블의 JOB_CODE 컬럼
SELECT JOB_CODE, JOB_NAME
FROM JOB;
-->JOB 테이블의 JOB_CODE 컬럼

-->조인을 통해서 연결고리에 해당되는 컬럼만 제대로 매칭시킨다면 마치 하나의 결과물로 조회 가능하다

/*
    1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
    연결시키는 컬럼의 값이 일치하는 행들만 조인해서 조회(==일치하지 않는 값들은 조회에서 제외)
*/
-->>오라클 전용 구문
--FROM절에 조회하고자하는 테이블명들을 나열 ( , 찍어서 나열)
--WHERE 절에 매칭시킬 컬럼명(연결고리)에 대한 조건을 제시함

--전체 사원들의 사번, 사원명, 부서코드, 부서명을 같이 조회
--1) 연결 할 두 컬럼명이 다른 경우 (EMPLOYEE 테이블의 DEPT_CODE / DEPARTMENT 테이블의 DEPT_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID;
-->23명 중 21명의 정보만 조회됨 -->왜? 일치하지 않는 값은 조회에서 제외됨 --> 이 경우에서는 DEPT_CODE 값이 NULL이었던 2명의 사원데이터는 조회가 애초에 안된것
-->DEPARTMENT 테이블의 DEPT_ID 컬럼에 NULL값이 존재하지 않기 때문에 -->추가적으로 D3, D4, D7 부서코드에 해당되는 사원들이 존재하지 않기 때문에 D3, D4, D7에 대한 부서명도 보이지 않는다

--사번, 사원명, 직급코드, 직급명
--2) 연결 할 두 컬럼명이 같은 경우 (EMPLOYEE 테이블의 JOB_CODE / JOB 테이블의 JOB_CODE
/*
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE=JOB_CODE;
*/
--에러 : AMBIGUOUSLY(애매하다, 모호하다) =>확실히 이 컬럼이 어느 테이블로부터 왔는지를 명시해줘야 한다
--방법 1. 테이블명을 명시해주는 방법
--테이블명.컬럼명
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE=JOB.JOB_CODE;

--방법 2. 테이블에 별칭을 붙여서 그 별칭을 명시해주는 방법
--테이블의별칭.컬럼명
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J --테이블명 별칭
WHERE E.JOB_CODE=J.JOB_CODE;

-->>ANSI 구문
--FROM 절에 테이블명은 단 하나만 작성(기준 테이블을 정해서 작성)
--그 뒤에 JOIN절을 작성하여 같이 조회하고자 하는 테이블명을 명시, 또한 매칭시킬 컬럼(연결고리)에 대한 조건도 같이 기술
--JOIN 절에는 ON 구문 또는 USING 구문으로 연결고리에 대한 조건을 기술한다

--사번, 사원명, 부서코드, 부서명
--1) 연결할 두 컬럼명이 다를경우 (EMPLOYEE 테이블에서 DEPT_CODE /DEPARTMENT 테이블에서 DEPT_ID) => 이 경우는 무조건 ON 구문만 사용가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/*INNER*/JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID); --INNER는 생략 가능

--사번, 사원명, 직급코드, 직급명
--2) 연결할 두 컬럼명이 같은 경우 (EMPLOYEE 테이블의 JOB_CODE / JOB 테이블의 JOB_CODE) => ON 구문, USING 구문 둘 다 사용 가능
--ON 구문 버전 : ambiguously가 발생 할 수 밖에 없음. 확실하게 명시를 해줘야 함(테이블명이든 별칭이든)
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE);

--USING 구문 버전: 컬럼명만 제시하는 구조(애초에 컬럼명이 동일할 경우에만 사용 가능한 구문)-->ambiguously가 발생하지 않기 때문에 동일한 컬럼명만 알아서 써주면 조인이 됨
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

--[참고] 위의 USING 구문 버전의 예시는 NATURAL JOIN(자연조인) 이라는 개념으로도 조인 가능
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;
--두 개의 테이블명만 제시한 상태
--운 좋게도 두개의 테이블에 일치하는 컬럼이 유일하게 한 개 존재하는 경우 (JOB_CODE)=>알아서 매칭됨

--추가적인 조건을 제시 가능 (WHERE절 사용)
--직급이 대리인 사원들의 정보를 조회
-->>오라클 전용 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE -- 조인이 일어날 경우 이 조건은 필수적
AND JOB_NAME='대리';
-- 협업 시 가독성을 높이기 위해 보통은 조건 하나당 개행+들여쓰기를 넣어준다

-->ANSI 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE E
--JOIN JOB USING (JOB_CODE)
JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE)
WHERE JOB_NAME='대리';

-----실습 문제-----
--1. 부서가 '인사관리부'인 사원들의 사번, 사원명, 보너스를 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE , DEPARTMENT 
WHERE DEPT_CODE=DEPT_ID
AND DEPT_TITLE='인사관리부';
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE DEPT_TITLE='인사관리부';

--2. 부서가 '총무부'가 아닌 사원들의 사원명, 급여, 입사일을 조회
-->> 오라클 전용 구문
SELECT EMP_NAME, SALARY, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE , DEPARTMENT 
WHERE DEPT_CODE=DEPT_ID
AND NOT DEPT_TITLE='총무부';
-->> ANSI 구문
SELECT EMP_NAME, SALARY, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT  ON (DEPT_CODE=DEPT_ID)
WHERE NOT DEPT_TITLE='총무부';

--3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE , DEPARTMENT 
WHERE DEPT_CODE=DEPT_ID
AND BONUS IS NOT NULL;
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT  ON (DEPT_CODE=DEPT_ID)
WHERE BONUS IS NOT NULL;

--4. 아래의 두 테이블을 참고해서 부서코드, 부서명, 지역코드, 지역명(LOCAL_NAME)을 조회
--SELECT * FROM DEPARTMENT; --LOCATION_ID(해당 부서가 어느 지점에 있는지를 코드로써 알려주는 컬럼)
--SELECT * FROM LOCATION; --LOCAL_CODE(해당 지역을 구분짓기 위한 지역코드값을 담은 컬럼)
-->> 오라클 전용 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT , LOCATION 
WHERE LOCATION_ID=LOCAL_CODE;
-->> ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE);

--다중조인의 예(테이블 3개 이상을 조인)
--사번, 사원명, 부서명, 직급명

-->>오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE, DEPARTMENT, JOB
WHERE DEPT_CODE=DEPT_ID AND EMPLOYEE.JOB_CODE=JOB.JOB_CODE;

-->>ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID) 
JOIN JOB USING (JOB_CODE);

-- 등가조인/내부조인 : 일치하지 않는 행들은 애초에 조회가 되지 않는다
--예) 부서테이블과 조인할 때 사원 테이블에서 부서코드가 NULL인 하동운, 이오리 사원은 제외하고 조회가 됨, 해당 부서에 소속 사원이 없는 경우는 조인 결과에서 확인이 불가함

/*
    2. 포괄조인 / 외부조인 (OUTER JOIN)
    테이블간의 JOIN시 일치하지 않는 행들도 포함시켜서 조회 가능
    단, LEFT / RIGHT를 지정해야 함(기준이 LEFT/RIGHT인지를 지정하라는 뜻)
*/

--"전체" 사원들의 사원명, 급여, 부서명 조회
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID);
--DEPT_CODE가 NULL인 사원들의 정보는 누락
--부서에 배정된 사원이 없는 경우 (D3, D4, D7) 부서명이 누락

--1) LEFT OUTER JOIN : 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN을 하겠다. 
--즉, 뭐가 되었든 간에 왼편에 기술된 기준 테이블의 데이터는 무조건 조회하게 됨(일치하는것을 찾지 못하더라도)

-->>ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
LEFT /*OUTER*/ JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--EMPLOYEE 테이블을 기준으로 조회를 했기 때문에 EMPLOYEE 테이블에 존재하는 데이터는 뭐가 되었든 간에 한번씩 다 조회되게끔 함

-->오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID(+); 
--내가 기준으로 삼을 테이블의 컬럼명이 아닌 반대 테이블의 컬럼명 뒤에다가 (+)기호를 붙여준다

--2) RIGHT OUTER JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN
--즉, 뭐가 되었든 간에 오른편에 기술된 기준 테이블의 데이터는 무조건 조회하겠다(일치하는것을 찾지 못하더라도)

-->ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
RIGHT /*OUTER*/ JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID); 

-->>오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+)=DEPT_ID;

--LEFT/RIGHT OUTER JOIN는 기본적으로 등가/내부조인의 결과+기준테이블에서 누락된 정보의 개수

--3) FULL OUTER JOIN : 두 테이블이 가진 모든 행을 조회할 수 있게 JOIN 단, 오라클 전용 구문에서는 불가

-->>ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE
FULL /*OUTER*/ JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);

--FULL OUTER JOIN은 기본적으로 등가/내부조인의 결과+왼쪽테이블에서 누락된 정보+오른쪽테이블에서 누락된 정보
--포괄조인: 일치하는것+누락된것(기준에 따라서 어디의 누락된것을 추가할지는 다름)

-->>오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+)=DEPT_ID(+);
--ONLY ONE OUTER-JOINED TABLE : 포괄조인 시 기준이되는 테이블이 하나만 있어야 한다 라는 뜻
--오라클 전용 구문은 FULL OUTER JOIN이 불가하다

/*
    3. 카테시안 곱(CARTESIAN PRODUCT) / 교차조인(CROSS JOIN)
    모든 테이블의 각 행들이 서로서로 맵핑된 결과가 조회됨(모든 경우의 수를 다 찍겠다, 곱집합)
    두 테이블의 행들이 모두 곱해진 행들의 조합이 다 출력=>방대한 데이터 출력=>과부화의 위험
    
    예) EMPLOYEE 테이블 총 23개의 행 / DEPARTMENT 테이블 총 9개의 행
    =>카테시안 곱(교차조인)의 결과 23*9=207개의 행이 결과로 나옴
*/

--사원명, 부서명
-->>오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;
--카테시안 곱은 주로 WHERE 절에 연결고리의 조건을 실수로 누락했을 경우 주로 발생(연결고리에 대한 조건을 누락했다는 것은 그냥 가능한 경우의 수를 다 찍겠다라는 것)

-->>ANSI 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

/*
    4. 비등가 조인(NON EQUAL JOIN)
    '=' (등호, 동등비교연산자)이 없는 경우, 등호를 사용하지 않는 JOIN
    지정한 컬럼값이 일치하는 경우가 아니라, '범위'에 포함되는 경우는 다 조회하겠다
*/

--사원명, 급여
SELECT EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT * 
FROM SAL_GRADE;

--사원명, 급여, 급여등급(SAL_LEVEL)
-->>오라클 전용 구문
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL 
FROM EMPLOYEE, SAL_GRADE
--WHERE SALARY>=MIN_SAL AND SALARY<=MAX_SAL; --연결고리에 대한 조건
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL; --연결고리에 대한 조건

-->>ANSI 구문(ON구문만 사용가능)
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL, MIN_SAL, MAX_SAL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

--비등가조인: 주로 연결고리에 대한 조건식으로, >, <, >=, <=, BETWEEN AND가 들어감

/*
    5. 자체조인(SELF JOIN)
    같은 테이블을 다시 한번 조인하는 경우
    즉, 자기 자신의 테이블과 다시 조인을 하는 경우
*/

SELECT EMP_ID "사번", EMP_NAME "사원명", SALARY "급여", MANAGER_ID "사수의 사번"
FROM EMPLOYEE;

--자체조인 주의사항 : 테이블명이 동일함 => 애매모호함
--                          항상 테이블명에 별칭을 다르게 부여한 다음에 진행

SELECT * FROM EMPLOYEE E; --사원에 대한 정보를 조회할 때 E라는 테이블 별칭
SELECT * FROM EMPLOYEE M; --사수에 대한 정보를 조회할 때 M이라는 테이블 별칭
--사원의 사번, 사원명, 부서코드, 급여 (E로 부터)
--사수의 사번, 사수명, 부서코드, 급여 (M으로 부터)
-->>오라클 전용 구문
SELECT E.EMP_ID "사원의 사번", E.EMP_NAME "사원명", E.DEPT_CODE "부서코드", E.SALARY "급여", M.EMP_ID "사수의 사번", M.EMP_NAME "사수명", M.DEPT_CODE "부서코드", M.SALARY "급여"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID=M.EMP_ID(+); --연결고리에 대한 조건

-->>ANSI 구문
SELECT E.EMP_ID "사원의 사번", E.EMP_NAME "사원명", E.DEPT_CODE "부서코드", E.SALARY "급여", M.EMP_ID "사수의 사번", M.EMP_NAME "사수명", M.DEPT_CODE "부서코드", M.SALARY "급여"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID=M.EMP_ID);
--컬럼추가연습
--사원의 사번, 사원명, 부서코드, 부서명,급여  (E로 부터)
--사수의 사번, 사수명, 부서코드, 부서명,급여  (M으로 부터)

SELECT E.EMP_ID "사원의 사번", E.EMP_NAME "사원명", E.DEPT_CODE "부서코드",D1.DEPT_TITLE "사원 부서명", E.SALARY "급여", 
            M.EMP_ID "사수의 사번", M.EMP_NAME "사수명", M.DEPT_CODE "부서코드",D2.DEPT_TITLE "사수 부서명", M.SALARY "급여"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID=M.EMP_ID)
LEFT JOIN DEPARTMENT D1 ON (E.DEPT_CODE=D1.DEPT_ID)
LEFT JOIN DEPARTMENT D2 ON (M.DEPT_CODE=D2.DEPT_ID);

/*
    [ 다중 JOIN ]
    3개 이상의 테이블을 조인하는 것
*/
--사번, 사원명, 부서명, 직급명, 지역명(LOCAL_NAME)
--EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME
SELECT * FROM EMPLOYEE;     --DEPT_CODE         JOB_CODE
SELECT * FROM DEPARTMENT; --DEPT_ID                                     LOCATION_ID
SELECT * FROM JOB;             --                       JOB_CODE
SELECT * FROM LOCATION;    --                                               LOCAL_CODE

-->>오라클 전용 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_TITLE "부서명", JOB_NAME "직급명", LOCAL_NAME "근무 지역명"
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L
WHERE E.DEPT_CODE=D.DEPT_ID(+) AND E.JOB_CODE=J.JOB_CODE(+) AND D.LOCATION_ID=L.LOCAL_CODE(+);

-->>ANSI 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_TITLE "부서명", JOB_NAME "직급명", LOCAL_NAME "근무 지역명"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
LEFT JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE) --포괄조인에서도 USING 가능 USING(JOB_CODE)
LEFT JOIN LOCATION L ON(D.LOCATION_ID=L.LOCAL_CODE);
-->ANSI 구문으로 다중조인을 작성할 경우에는 JOIN의 순서가 중요하다

--사번,사원명,부서명,직급명,근무지역명,근무국가명,급여등급(SAL_GRADE 테이블로부터)
--EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
SELECT * FROM EMPLOYEE;     --DEPT_CODE     JOB_CODE                                                               SALARY
SELECT * FROM DEPARTMENT; --DEPT_ID                             LOCATION_ID
SELECT * FROM JOB;             --                   JOB_CODE    
SELECT * FROM LOCATION;    --                                       LOCAL_CODE          NATIONAL_CODE
SELECT * FROM NATIONAL;    --                                                                 NATIONAL_CODE
SELECT * FROM SAL_GRADE;    --                                                                                               MIN_SAL/MAX_SAL

-->>ANSI 구문
SELECT E.EMP_ID "사번", E.EMP_NAME "사원명", D.DEPT_TITLE "부서명", J.JOB_NAME "직급명", L.LOCAL_NAME "근무지역명", N.NATIONAL_NAME "근무국가명", S.SAL_LEVEL "급여등급"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
LEFT JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE)
LEFT JOIN LOCATION L ON (D.LOCATION_ID=L.LOCAL_CODE)
LEFT JOIN NATIONAL N ON(L.NATIONAL_CODE=N.NATIONAL_CODE)
JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

---------------------- JOIN 종합 실습문제 ----------------------
-- 1. 직급이 대리이면서 ASIA 지역에 근무하는 직원들의
--    사번, 사원명, 직급명, 부서명, 근무지역명, 급여를 조회하시오
SELECT * FROM EMPLOYEE;
-->> 오라클 전용 구문
SELECT E.EMP_ID "사번", E.EMP_NAME "사원명", J.JOB_NAME "직급명", D.DEPT_TITLE "부서명", L.LOCAL_NAME "근무지역명", E.SALARY "급여"
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L
WHERE  E.DEPT_CODE=D.DEPT_ID AND E.JOB_CODE=J.JOB_CODE AND D.LOCATION_ID=L.LOCAL_CODE AND J.JOB_NAME='대리' AND LOCAL_NAME LIKE 'ASIA%';
-->> ANSI 구문
SELECT E.EMP_ID "사번", E.EMP_NAME "사원명", J.JOB_NAME "직급명", D.DEPT_TITLE "부서명", L.LOCAL_NAME "근무지역명", E.SALARY "급여"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE=D.DEPT_ID)
JOIN JOB J ON(E.JOB_CODE=J.JOB_CODE)
JOIN LOCATION L ON(D.LOCATION_ID=L.LOCAL_CODE)
WHERE J.JOB_NAME='대리' AND LOCAL_NAME LIKE 'ASIA%';
-- 2. 70년대생이면서 여자이고, 성이 전씨인 직원들의
--   사원명, 주민번호, 부서명, 직급명을 조회하시오
-->> 오라클 전용 구문
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE=D.DEPT_ID AND E.JOB_CODE=J.JOB_CODE AND EMP_NAME LIKE '전%' AND SUBSTR(EMP_NO,1,1)=7 AND SUBSTR(EMP_NO, 8, 1) IN ('2','4');
-->> ANSI 구문
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE=D.DEPT_ID)
JOIN JOB J ON(E.JOB_CODE=J.JOB_CODE)
WHERE EMP_NAME LIKE '전%' AND SUBSTR(EMP_NO,1,1)=7 AND SUBSTR(EMP_NO, 8, 1) IN ('2','4');
-- 3. 이름에 '형'자가 들어있는 직원들의 
--    사번, 사원명, 직급명을 조회하시오
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE AND EMP_NAME LIKE '%형%';
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
WHERE EMP_NAME LIKE '%형%';
-- 4. 해외영업팀에 근무하는 직원들의
--    사원명, 직급명, 부서코드, 부서명을 조회하시오
-->> 오라클 전용 구문
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_CODE=J.JOB_CODE AND E.DEPT_CODE=D.DEPT_ID AND DEPT_TITLE LIKE '%해외영업%';
-->> ANSI 구문
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE=D.DEPT_ID)
WHERE DEPT_TITLE LIKE '%해외영업%';
-- 5. 보너스를 받는 직원들의
--    사원명, 보너스, 연봉, 부서명, 근무지역명을 조회하시오
-->> 오라클 전용 구문
SELECT EMP_NAME, BONUS, SALARY*12, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE=D.DEPT_ID(+) AND D.LOCATION_ID=L.LOCAL_CODE(+) AND BONUS IS NOT NULL;
-->> ANSI 구문
SELECT EMP_NAME, BONUS, SALARY*12, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE=D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID=L.LOCAL_CODE)
WHERE BONUS IS NOT NULL;
-- 6. 부서가 있는 직원들의
--    사원명, 직급명, 부서명, 근무지역명을 조회하시오
-->> 오라클 전용 구문
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E,  DEPARTMENT D, JOB J, LOCATION L
WHERE E.DEPT_CODE=D.DEPT_ID AND E.JOB_CODE=J.JOB_CODE AND D.LOCATION_ID=L.LOCAL_CODE;
-->> ANSI 구문
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
JOIN JOB J USING(JOB_CODE)
JOIN LOCATION L ON (D.LOCATION_ID=L.LOCAL_CODE);
-- 7. '한국' 과 '일본' 에 근무하는 직원들의
--    사원명, 부서명, 근무지역명, 근무국가명을 조회하시오
-->> 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE=D.DEPT_ID AND D.LOCATION_ID=L.LOCAL_CODE AND L.NATIONAL_CODE=N.NATIONAL_CODE
AND NATIONAL_NAME IN ('한국','일본');
-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID=L.LOCAL_CODE)
JOIN NATIONAL N USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국','일본');
-- 8. 보너스를 받지 않는 직원들 중 직급코드가 J4 또는 J7 인 직원들의
--    사원명, 직급명, 급여를 조회하시오
-->> 오라클 전용 구문
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE AND E.JOB_CODE IN ('J4','J7') AND BONUS IS NULL;
-->> ANSI 구문
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE)
WHERE E.JOB_CODE IN ('J4','J7') AND BONUS IS NULL;
-- 9. 사번, 사원명, 직급명, 급여등급, 구분을 조회하는데
--    이 때, 구분에 해당하는 값은
--    급여등급이 S1, S2 인 경우 '고급'
--    급여등급이 S3, S4 인 경우 '중급'
--    급여등급이 S5, S6 인 경우 '초급' 으로 조회되게 하시오
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SAL_LEVEL, 
CASE WHEN SAL_LEVEL='S1' OR SAL_LEVEL='S2' THEN '고급'
WHEN SAL_LEVEL='S3' OR SAL_LEVEL='S4' THEN '중급'
WHEN SAL_LEVEL='S5' OR SAL_LEVEL='S6' THEN '초급'
END "구분"
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE;
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SAL_LEVEL, 
CASE WHEN SAL_LEVEL='S1' OR SAL_LEVEL='S2' THEN '고급'
WHEN SAL_LEVEL='S3' OR SAL_LEVEL='S4' THEN '중급'
WHEN SAL_LEVEL='S5' OR SAL_LEVEL='S6' THEN '초급'
END "구분"
FROM EMPLOYEE E
JOIN JOB J USING (JOB_CODE);
-- 10. 각 부서별 총 급여합을 조회하되
--     이 때, 총 급여합이 1000만원 이상인 부서명, 급여합을 조회하시오
-->> 오라클 전용 구문
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE=D.DEPT_ID
GROUP BY DEPT_TITLE 
HAVING SUM(SALARY)>=10000000;
-->> ANSI 구문
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
GROUP BY DEPT_TITLE 
HAVING SUM(SALARY)>=10000000;
-- 11. 각 부서별 평균급여를 조회하여 부서명, 평균급여 (정수처리) 로 조회하시오
--     단, 부서배치가 안된 사원들의 평균도 같이 나오게끔 하시오
--> 오라클 전용 구문
SELECT NVL(DEPT_TITLE,'부서없음') "부서명", ROUND(AVG(SALARY)) "평균급여"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE=D.DEPT_ID(+)
GROUP BY DEPT_TITLE;
-->> ANSI 구문
SELECT NVL(DEPT_TITLE,'부서없음') "부서명", ROUND(AVG(SALARY)) "평균급여"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE=D.DEPT_ID)
GROUP BY DEPT_TITLE;
