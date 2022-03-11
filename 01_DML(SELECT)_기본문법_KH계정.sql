<<<<<<< HEAD
/*
    <SELECT>
    데이터를 조회하거나 검색할 때 사용하는 명령어
    ResultSet : SELECT 구문을 통해 조회된 데이터들의 결과물을 의미 즉, 조회된 행들의 집합
    [표현법]
    SELECT 조회하고자하는컬럼명1, 컬럼명2, 컬럼명3, ...
    FROM 테이블명;
*/

-- EMPLOYEE 테이블의 전체 사원들의 사번, 이름, 급여 컬럼만을 조회
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE;

--명령어, 키워드, 테이블명, 컬럼명 등은 대소문자를 가리지 않음
--소문자로 써도 무방

--EMPLOYEE 테이블의 전체 사원들의 모든 컬럼을 조회
SELECT * FROM EMPLOYEE;

--JOB 테이블의 모든 컬럼들 조회
SELECT * FROM JOB;

--JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME FROM JOB;

-------실습 문제-------
--1. DEPARTMENT 테이블의 모든 컬럼 조회
SELECT * FROM DEPARTMENT;
--2. EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 입사일 컬럼만 조회
SELECT EMP_ID, EMAIL, PHONE, HIRE_DATE FROM EMPLOYEE;
--3. EMPLOYEE 테이블의 입사일, 직원명, 급여 컬럼만 조회
SELECT HIRE_DATE, EMP_NAME, SALARY FROM EMPLOYEE;

/*
    <컬럼값을 통한 산술연산>
    조회하고자 하는 컬럼들을 나열하는 SELECT 절에 산술연산( +-/*)을 기술해서 결과를 조회할 수 있다
*/

--EMPLOYEE 테이블로부터 직원명, 월급, 연봉(==월급*12)
SELECT EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE;

--EMPLOYEE 테이블로부터 직원명, 월급, 보너스, 보너스가 포함된 연봉(==(월급+(월급*보너스)))
SELECT EMP_NAME, SALARY, BONUS, (SALARY+SALARY*BONUS)*12 FROM EMPLOYEE;
-->산술 연산 과정에 NULL 값이 존재한다면 산술 연산 결과 마저도 NULL이 나옴!

--EMPLOYEE 테이블로부터 직원명, 입사일, 근무일수(== 오늘날짜 - 입사일)조회
--DATE 타입끼리도 연산 가능 ( DATE=>년, 월, 일, 시, 분, 초)
--오늘 날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, Sysdate-HIRE_DATE FROM EMPLOYEE;
--결과값은 일 수 단위로 나옴
--값이 지저분한 이유는 DATE 타입에 포함되어 있는 시/분/초에 대한 연산까지 수행하기 때문

/*
    <컬럼명에 별칭 부여하기>
    [표현법]
    컬럼명 AS 별칭 or 컬럼명 AS "별칭" or 컬럼명 별칭 or 컬럼명 "별칭"
    AS를 붙이든 안붙이든 간에 별칭에 특수문자나 띄어쓰기가 포함될 경우 반드시 ""로 묶어서 표기해야 함
*/

--EMPLOYEE 테이블로부터 이름, 월 급여, 보너스, 보너스가 포함된 총 소득을 조회
SELECT EMP_NAME AS 이름, SALARY AS "급여(월)", BONUS AS 보너스, (SALARY+(SALARY*BONUS))*12 AS "총 소득" FROM EMPLOYEE;

/*
    <리터럴>
    임의로 지정한 문자열( ' ' ), 숫자, 날짜를 SELECT절에 기술하면 실제 그 테이블에 존재하는 데이터처럼 ResultSet으로 조회가 가능하다
*/

--EMPLOYEE 테이블로부터 사번, 사원명, 급여, 단위 조회하기
SELECT EMP_ID AS 사번, EMP_NAME AS 사원명, SALARY AS 급여, '원' AS 단위 FROM EMPLOYEE;
-->SELECT절에 제시한 리터럴 값은 조회결과인 ResultSet의 모든 행에 반복적으로 출력됨

/*
    <DISTINCT>
    조회하고자 하는 컬럼에 중복된 값을 딱 한번씩만 조회하고 싶을 때 사용
    [표현법]
    DISTINCT 컬럼명
    단, SELECT 절에 DISTINCT 구문은 단 한개만 작성 가능하다
*/

--EMPLOYEE 테이블로부터 부서코드들을 조회
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

--EMPLOYEE 테이블로부터 직급코드들을 조회
SELECT JOB_CODE FROM EMPLOYEE;

--DEPT_CODE, JOB_CODE 컬럼의 값을 세트로 묶어서 중복 판별
SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;

/*
    <WHERE 절>
    조회하고자 하는 테이블에 특정 조건을 제시해서 그 조건에 만족하는 데이터만을 조회하고자 할 때 기술하는 구문
    [표현법]
    SELECT 컬럼명1, 컬럼명2, ... FROM 테이블명 WHERE 조건식;
    
    실행순서 : FROM절 -> WHERE절
    조건식에 다양한 연산자들 사용 가능
    <비교 연산자>
    >, <, >=, <= (대소 비교)
    = (일치하는가? : 동등비교, 자바에서 동등비교는 ==였음)
    !=, ^=, <> (일치하지 않는가?)
*/

--EMPLOYEE 테이블로부터 급여가 400만원 이상인 사원들의 모든 컬럼을 조회
SELECT * FROM EMPLOYEE WHERE SALARY>=4000000;

--EMPLOYEE 테이블로부터 부서코드가 D9인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D9';

--EMPLOYEE 테이블로부터 부서코드가 D9가 아닌 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE

--WHERE DEPT_CODE !='D9'; --23명 중 20명 조회? (NULL은 제외하고 18명 조회)
--WHERE DEPT_CODE ^='D9';
WHERE DEPT_CODE <> 'D9';

------- 실습 문제 --------
--1. EMPLOYEE 테이블로부터 급여가 300만원 이상인 사원들의 이름, 급여,입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE WHERE SALARY>=3000000;
--2. EMPLOYEE 테이블로부터 직급코드가 J2인 사원들의 이름, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE WHERE JOB_CODE='J2';
--3. EMPLOYEE 테이블로부터 현재 재직중인 사원들의 사번, 이름, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE ENT_YN='N';
--4. EMPLOYEE 테이블로부터 연봉(==급여*12)이 5000만원 이상인 사원들의 이름, 급여, 연봉, 입사일 조회
SELECT EMP_NAME, SALARY, SALARY*12 AS 연봉, HIRE_DATE FROM EMPLOYEE WHERE SALARY*12>=50000000;

/*
    <논리 연산자>
    여러 개의 조건을 엮을 때 사용
    ~이면서, 그리고 : AND (자바에서는&&)
    ~이거나, 또는 : OR (자바에서는 | | )
*/

--EMPLOYEE 테이블로부터 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D9' AND SALARY>=5000000;

--EMPLOYEE 테이블로부터 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D6' OR SALARY>=3000000;

--EMPLOYEE 테이블로부터 급여가 350만원 이상이고 600만원 이하인 사원들의 이름, 사번, 급여, 직급코드 조회
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY>=3500000 AND SALARY <= 6000000;

/*
    <BETWEEN AND 연산자>
    몇 이상 몇 이하인 범위에 대한 조건을 제시할 수 있는 연산자
    [표현법]
    비교대상컬럼명 BETWEEN 하한값 AND 상한값
    (비교대상컬럼명에 들어있는 값이 하한값 이상 그리고 상한값 이하를 만족하는 경우)
*/

--EMPLOYEE 테이블로부터 급여가 350만원 이상이고 600만원 이하인 사원들의 이름, 사번, 급여, 직급코드 조회
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY BETWEEN 3500000 AND 6000000;

--employee 테이블로부터 급여가 350만원 미만이고 600만원 초과인 사원들의 이름, 사번, 급여, 직급코드 조회
select emp_name, emp_id, salary, job_code 
from employee 
--where salary<3500000 or salary>6000000;
--where not salary between 3500000 and 6000000;
where salary not between 3500000 and 6000000;
-->오라클에서 not은 자바의 논리부정연산자인 !와 동일한 의미

--between and 연산자는 date 형식간에서도 사용 가능
--입사일이 '90/01/01' ~ '03/01/01'인 사원들의 모든 컬럼 조회
select * 
from employee 
--where hire_date>='90/01/01' and hire_date <= '03/01/01';
where hire_date between '90/01/01' and '03/01/01';
--날짜도 대소비교가 가능함(상한값, 하한값의 개념이 있다, between and 연산자를 사용 가능하다)

--employee 테이블로 부터 입사일이 '90/01/01' ~ '03/01/01'이 아닌 사원들의 모든 컬럼을 조회
select *
from employee
where hire_date not between '90/01/01' and '03/01/01';

/*
    <LIKE '특정 패턴'>
    비교하려는 컬럼값이 내가 지정한 특정 패턴에 만족될 경우 조회
    
    [표현법]
    비교대상컬럼명 LIKE '특정 패턴'
    
    -특정 패턴을 제시할 때 와일드카드인 '%', '_'를 가지고 제시할 수 있음
    '%' : 0글자 이상
    비교대상컬럼명 LIKE '문자%' => 컬럼값 중에 '문자'로 시작되는 것을 조회
    비교대상컬럼명 LIKE '%문자' => 컬럼값 중에 '문자'로 끝나는 것을 조회
    비교대상컬럼명 LIKE '%문자%' => 컬럼값 중에 '문자'가 포함되는 것을 조회
    
    '_' : 딱 1글자
    비교대상컬럼명 LIKE '_문자' => 해당 컬럼값 중에 '문자' 앞에 무조건 1글자가 있을 경우 조회
    비교대상컬럼명 LIKE '__문자' => 해당 컬럼값 중에 '문자' 앞에 무조건 2글자가 있을 경우 조회
*/
--employee 테이블로부터 성이 전씨인 사원들의 이름, 급여, 입사일 조회
select emp_name, salary, hire_date from employee where emp_name like '전%';

--employee 테이블로부터 이름 중에 '하'가 포함된 사원들의 이름, 주민번호, 부서코드 조회
select emp_name, emp_no, dept_code from employee where emp_name like '%하%';

--employee 테이블로부터 전화번호 4번 째 자리가 9로 시작되는 사원들의 사번,사원명, 전화번호, 이메일 조회
select emp_id, emp_name, phone, email from employee where phone like '___9%';

--employee 테이블로부터 이름 가운데글자가 '지'인 사원들의 모든 컬럼(이름이 3글자일 경우)
select * from employee where emp_name like '_지_';

--그 이외의 사원
select * from employee where emp_name not like '_지_';

--실습문제--
--1. 이름이 '연'으로 끝나는 사원들의 이름, 입사일 조회
select emp_name, hire_date from employee where emp_name like '%연';
--2. 전화번호 처음 3글자가 010이 아닌 사원들의 이름, 전화번호 조회
select emp_name, phone from employee where phone not like '010%';
--3. department 테이블로부터 해외영업과 관련된 부서들의 모든 컬럼들을 조회
select * from department where dept_title like '%해외영업%';

/*
    <IS NULL>
    NULL인지 아닌지 판별
    [표현법]
    비교대상컬럼 IS NULL : 컬럼값이 NULL인 경우를 조회하겠다
    비교대상컬럼 IS NOT NULL : 컬럼값이 NULL이 아닌 경우를 조회하겠다
    
    주의사항: 오라클에서 NULL값과 동등비교할때는 =을 쓰지 않고 IS NULL을 쓴다
*/

-- 보너스를 받지 않는 사원들의 사번, 이름, 급여, 보너스 조회
select emp_id, emp_name, salary, bonus from employee where bonus is null;

--보너스를 받는 사원들의 사번, 이름, 급여, 보너스
select emp_id, emp_name, salary, bonus from employee where bonus is not null;

--사수가 없는 사원들의 사원명, 사수사번, 부서코드 조회
select emp_name, manager_id, dept_code from employee where manager_id is null;

--사수도 없고 부서배치도 받지 않은 사원들의 모든 컬럼을 조회
select * from employee where manager_id is null and dept_code is null;

--부처 배치는 받지 않았지만 보너스는 받는 사원들의 사원명, 부서코드, 보너스 조회
select emp_name, dept_code, bonus from employee where dept_code is null and bonus is not null;

/*
    <IN>
    비교 대상 컬럼 값에 내가 제시한 목록들 중에서 일치하는 값이 하나라도 있는지 체크
    [표현법]
    비교대상컬럼 IN (값, 값, 값, ...)
*/

--부서코드가 D6이거나 또는 D8이거나 또는 D5인 사원들의 이름, 부서코드, 급여 조회
select emp_name, dept_code, salary 
from employee 
--where dept_code='D6' or dept_code='D8' or dept_code='D5';
where dept_code in ('D6','D8','D5');

--그 이외의 사원들
select emp_name, dept_code, salary from employee where dept_code not in ('D6','D8','D5');

/*
    <연결 연산자>
    여러 컬럼값을 마치 하나의 컬럼인듯 연결시켜주는 연산자
    컬럼과 리터럴( 임의의 문자열)을 연결할 수 있음
    
    자바에서 
    문자열+문자열=합쳐진 문자열
    문자열+숫자=합쳐진 문자열
*/

select emp_id || emp_name || salary as "연결됨" from employee;

--XX번 XXX의 월급은 XXXX원 입니다. 형식으로 출력
select emp_id || '번 ' || emp_name ||'의 월급은 '|| salary || '원 입니다' as "급여정보" from employee;

/*
    <연산자 우선순위>
    0. ( ) : 우선순위를 높여주는 역할
    1. 산술연산자 : 수학 산술연산을 해줌
    2. 연결연산자 : 컬럼과 리터럴값 또는 컬럼과 컬럼값을 연결해줌
    3. 비교연산자 : 대소비교 또는 동등비교
    { 4. IS NULL, IS NOT NULL : NULL 값인지 아닌지 판단해줌
    5. LIKE : 패턴을 제시해서 패턴에 부합하는지 판별
    6. IN : 제시한 목록 중 하나라도 일치하는게 있는지 판별 ( 동등비교+OR 연산 )
    7. BETWEEN AND : 특정 범위에 해당되는지 체크 (하한값 <= 비교대상 <= 상한값) }=> 4,5,6은 같은 우선순위
    8. NOT : 조건을 반전시키는 역할
    9. AND : 조건을 "그리고"라는 키워드로 연결
    10. OR : 조건을 "또는"이라는 키워드로 연결
*/

/*
    <ORDER BY 절>
    SELECT 문 가장 마지막에 기입하는 구문 뿐만 아니라 실행 순서 또한 가장 마지막
   조회된 데이터들을 정렬해주는 역할 (오름차순인지 내림차순인지 / 무엇을 기준으로 정렬할 건지)
   
   [표현법]
   SELECT  조회할컬럼명1, 컬럼명2, ... 
   FROM 테이블명
   WHERE 조건식
   ORDER BY [정렬기준으로세우고자하는컬럼명/별칭/컬럼순번] [ASC(오름차순)/DESC(내림차순)];
   
   =>WHERE절, ORDER BY 절은 생략 가능
*/
=======
/*
    <SELECT>
    데이터를 조회하거나 검색할 때 사용하는 명령어
    ResultSet : SELECT 구문을 통해 조회된 데이터들의 결과물을 의미 즉, 조회된 행들의 집합
    [표현법]
    SELECT 조회하고자하는컬럼명1, 컬럼명2, 컬럼명3, ...
    FROM 테이블명;
*/

-- EMPLOYEE 테이블의 전체 사원들의 사번, 이름, 급여 컬럼만을 조회
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE;

--명령어, 키워드, 테이블명, 컬럼명 등은 대소문자를 가리지 않음
--소문자로 써도 무방

--EMPLOYEE 테이블의 전체 사원들의 모든 컬럼을 조회
SELECT * FROM EMPLOYEE;

--JOB 테이블의 모든 컬럼들 조회
SELECT * FROM JOB;

--JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME FROM JOB;

-------실습 문제-------
--1. DEPARTMENT 테이블의 모든 컬럼 조회
SELECT * FROM DEPARTMENT;
--2. EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 입사일 컬럼만 조회
SELECT EMP_ID, EMAIL, PHONE, HIRE_DATE FROM EMPLOYEE;
--3. EMPLOYEE 테이블의 입사일, 직원명, 급여 컬럼만 조회
SELECT HIRE_DATE, EMP_NAME, SALARY FROM EMPLOYEE;

/*
    <컬럼값을 통한 산술연산>
    조회하고자 하는 컬럼들을 나열하는 SELECT 절에 산술연산( +-/*)을 기술해서 결과를 조회할 수 있다
*/

--EMPLOYEE 테이블로부터 직원명, 월급, 연봉(==월급*12)
SELECT EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE;

--EMPLOYEE 테이블로부터 직원명, 월급, 보너스, 보너스가 포함된 연봉(==(월급+(월급*보너스)))
SELECT EMP_NAME, SALARY, BONUS, (SALARY+SALARY*BONUS)*12 FROM EMPLOYEE;
-->산술 연산 과정에 NULL 값이 존재한다면 산술 연산 결과 마저도 NULL이 나옴!

--EMPLOYEE 테이블로부터 직원명, 입사일, 근무일수(== 오늘날짜 - 입사일)조회
--DATE 타입끼리도 연산 가능 ( DATE=>년, 월, 일, 시, 분, 초)
--오늘 날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, Sysdate-HIRE_DATE FROM EMPLOYEE;
--결과값은 일 수 단위로 나옴
--값이 지저분한 이유는 DATE 타입에 포함되어 있는 시/분/초에 대한 연산까지 수행하기 때문

/*
    <컬럼명에 별칭 부여하기>
    
    [표현법]
    컬럼명 AS 별칭 or 컬럼명 AS "별칭" or 컬럼명 별칭 or 컬럼명 "별칭"
    AS를 붙이든 안붙이든 간에 별칭에 특수문자나 띄어쓰기가 포함될 경우 반드시 ""로 묶어서 표기해야 함
*/

--EMPLOYEE 테이블로부터 이름, 월 급여, 보너스, 보너스가 포함된 총 소득을 조회
SELECT EMP_NAME AS 이름, SALARY AS "급여(월)", BONUS AS 보너스, (SALARY+(SALARY*BONUS))*12 AS "총 소득" FROM EMPLOYEE;

/*
    <리터럴>
    임의로 지정한 문자열( ' ' ), 숫자, 날짜를 SELECT절에 기술하면 실제 그 테이블에 존재하는 데이터처럼 ResultSet으로 조회가 가능하다
*/

--EMPLOYEE 테이블로부터 사번, 사원명, 급여, 단위 조회하기
SELECT EMP_ID AS 사번, EMP_NAME AS 사원명, SALARY AS 급여, '원' AS 단위 FROM EMPLOYEE;
-->SELECT절에 제시한 리터럴 값은 조회결과인 ResultSet의 모든 행에 반복적으로 출력됨

/*
    <DISTINCT>
    조회하고자 하는 컬럼에 중복된 값을 딱 한번씩만 조회하고 싶을 때 사용
    [표현법]
    DISTINCT 컬럼명
    단, SELECT 절에 DISTINCT 구문은 단 한개만 작성 가능하다
*/

--EMPLOYEE 테이블로부터 부서코드들을 조회
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

--EMPLOYEE 테이블로부터 직급코드들을 조회
SELECT JOB_CODE FROM EMPLOYEE;

--DEPT_CODE, JOB_CODE 컬럼의 값을 세트로 묶어서 중복 판별
SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;

/*
    <WHERE 절>
    조회하고자 하는 테이블에 특정 조건을 제시해서 그 조건에 만족하는 데이터만을 조회하고자 할 때 기술하는 구문
    [표현법]
    SELECT 컬럼명1, 컬럼명2, ... FROM 테이블명 WHERE 조건식;
    
    실행순서 : FROM절 -> WHERE절
    조건식에 다양한 연산자들 사용 가능
    <비교 연산자>
    >, <, >=, <= (대소 비교)
    = (일치하는가? : 동등비교, 자바에서 동등비교는 ==였음)
    !=, ^=, <> (일치하지 않는가?)
*/

--EMPLOYEE 테이블로부터 급여가 400만원 이상인 사원들의 모든 컬럼을 조회
SELECT * FROM EMPLOYEE WHERE SALARY>=4000000;

--EMPLOYEE 테이블로부터 부서코드가 D9인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D9';

--EMPLOYEE 테이블로부터 부서코드가 D9가 아닌 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE

--WHERE DEPT_CODE !='D9'; --23명 중 20명 조회? (NULL은 제외하고 18명 조회)
--WHERE DEPT_CODE ^='D9';
WHERE DEPT_CODE <> 'D9';

------- 실습 문제 --------
--1. EMPLOYEE 테이블로부터 급여가 300만원 이상인 사원들의 이름, 급여,입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE WHERE SALARY>=3000000;
--2. EMPLOYEE 테이블로부터 직급코드가 J2인 사원들의 이름, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE WHERE JOB_CODE='J2';
--3. EMPLOYEE 테이블로부터 현재 재직중인 사원들의 사번, 이름, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE ENT_YN='N';
--4. EMPLOYEE 테이블로부터 연봉(==급여*12)이 5000만원 이상인 사원들의 이름, 급여, 연봉, 입사일 조회
SELECT EMP_NAME, SALARY, SALARY*12 AS 연봉, HIRE_DATE FROM EMPLOYEE WHERE SALARY*12>=50000000;

/*
    <논리 연산자>
    여러 개의 조건을 엮을 때 사용
    ~이면서, 그리고 : AND (자바에서는&&)
    ~이거나, 또는 : OR (자바에서는 | | )
*/

--EMPLOYEE 테이블로부터 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D9' AND SALARY>=5000000;

--EMPLOYEE 테이블로부터 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D6' OR SALARY>=3000000;

--EMPLOYEE 테이블로부터 급여가 350만원 이상이고 600만원 이하인 사원들의 이름, 사번, 급여, 직급코드 조회
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY>=3500000 AND SALARY <= 6000000;

/*
    <BETWEEN AND 연산자>
    몇 이상 몇 이하인 범위에 대한 조건을 제시할 수 있는 연산자
    [표현법]
    비교대상컬럼명 BETWEEN 하한값 AND 상한값
    (비교대상컬럼명에 들어있는 값이 하한값 이상 그리고 상한값 이하를 만족하는 경우)
*/

--EMPLOYEE 테이블로부터 급여가 350만원 이상이고 600만원 이하인 사원들의 이름, 사번, 급여, 직급코드 조회
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY BETWEEN 3500000 AND 6000000;

-- EMPLOYEE 테이블로부터 급여가 350만원 미만이거나 600만원 초과인 사원들의 이름, 사번, 급여, 직급코드 조회
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE
FROM EMPLOYEE
-- WHERE SALARY < 3500000 OR 6000000 < SALARY;
-- WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
WHERE SALARY NOT BETWEEN 3500000 AND 6000000;
--> 오라클에서 NOT 은 자바의 논리부정연산자인 ! 와 동일한 의미

-- ** BETWEEN AND 연산자는 DATE 형식간에서도 사용 가능
-- 입사일이 '90/01/01' ~ '03/01/01' 인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
-- WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '03/01/01';
-- 날짜도 대소비교가 가능함 (== 상한값, 하한값의 개념이 있다, BETWEEN AND 연산자를 사용 가능하다)
WHERE HIRE_DATE BETWEEN '90/01/01' AND '03/01/01';

-- EMPLOYEE 테이블로부터 입사일이 '90/01/01' ~ '03/01/01' 이 아닌 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE NOT BETWEEN '90/01/01' AND '03/01/01';

-------------------------------------------------------------------------------------------------

/*
    < LIKE '특정 패턴' >
    비교하려는 컬럼값이 내가 지정한 특정 패턴에 만족될 경우 조회
    
    [ 표현법 ]
    비교대상컬럼명 LIKE '특정 패턴'
    
    - 특정 패턴을 제시할때 와일드카드인 '%', '_' 를 가지고 제시할 수 있음
    '%' : 0글자 이상
    비교대상컬럼명 LIKE '문자%' => 컬럼값 중에 '문자'로 시작되는것을 조회
    비교대상컬럼명 LIKE '%문자' => 컬럼값 중에 '문자'로 끝나는것을 조회
    비교대상컬럼명 LIKE '%문자%' => 컬럼값 중에 '문자'가 포함되는것을 조회
    
    '_' : 딱 1글자
    비교대상컬럼명 LIKE '_문자' => 해당 컬럼값 중에 '문자' 앞에 무조건 1글자가 있을 경우 조회
    비교대상컬럼명 LIKE '__문자' => 해당 컬럼값 중에 '문자' 앞에 무조건 2글자가 있을 경우 조회
*/

-- EMPLOYEE 테이블로부터 성이 전씨인 사원들의 이름, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- EMPLOYEE 테이블로부터 이름 중에 '하' 가 포함된 사원들의 이름, 주민번호, 부서코드 조회
SELECT EMP_NAME, EMP_NO, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- EMPLOYEE 테이블로부터 전화번호 4번째 자리가 9로 시작되는 사원들의 사번, 사원명, 전화번호, 이메일 조회
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

-- EMPLOYEE 테이블로부터 이름 가운데글자가 '지' 인 사원들의 모든 컬럼 (이름이 3글자일 경우)
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_지_';

-- 그 이외의 사원
SELECT *
FROM EMPLOYEE
-- WHERE NOT EMP_NAME LIKE '_지_';
WHERE EMP_NAME NOT LIKE '_지_';

------- 실습문제 -------
-- 1. 이름이 '연' 으로 끝나는 사원들의 이름, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
-- WHERE EMP_NAME LIKE '%연';
WHERE EMP_NAME LIKE '__연';
-- 이름이 모두 3글자라는 가정하에 언더바도 사용가능

-- 2. 전화번호 처음 3글자가 010 이 아닌 사원들의 이름, 전화번호를 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

-- 3. DEPARTMENT 테이블로부터 해외영업과 관련된 부서들의 모든 컬럼들을 조회
SELECT *
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '%해외영업%';

------------------------------------------------------------------------------------------

/*
    < IS NULL >
    NULL 인지 아닌지 판별
    
    [ 표현법 ]
    비교대상컬럼 IS NULL : 컬럼값이 NULL 인 경우를 조회하겠다.
    비교대상컬럼 IS NOT NULL : 컬럼값이 NULL 이 아닌 경우를 조회하겠다.
    
    주의사항 : 오라클에서 NULL 값과 동등비교할때에는 = 을 쓰지 않고 IS NULL 을 쓴다!
*/

SELECT *
FROM EMPLOYEE;

-- 보너스를 받지 않는 사원들의 사번, 이름, 급여, 보너스
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

-- 보너스를 받는 사원들의 사번, 이름, 급여, 보너스
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- 사수가 없는 사원들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 사수도 없고 부서배치도 받지 않은 사원들의 모든 컬럼을 조회
SELECT *
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- 부서배치는 받지 않았지만 보너스는 받는 사원들의 사원명, 부서코드, 보너스 조회
SELECT EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

----------------------------------------------------------------------------------------

/*
    < IN >
    비교 대상 컬럼 값에 내가 제시한 목록들 중에서 일치하는값이 하나라도 있는지 체크
    
    [ 표현법 ]
    비교대상컬럼 IN (값1, 값2, 값3, ..)
*/

-- 부서코드가 D6 이거나 또는 D8 이거나 또는 D5 인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D5';
WHERE DEPT_CODE IN ('D6', 'D8', 'D5');

-- 그 이외의 사원들
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D6', 'D8', 'D5');

----------------------------------------------------------------------------------------

/*
    < 연결 연산자 || >
    여러 컬럼값을 마치 하나의 컬럼인 듯 연결시켜주는 연산자
    컬럼과 리터럴 (임의의 문자열) 을 연결할 수 있음
    
    자바에서 
    문자열 + 문자열 = 합쳐진 문자열
    문자열 + 숫자 = 합쳐진 문자열
*/

SELECT EMP_ID || EMP_NAME || SALARY AS "연결됨"
FROM EMPLOYEE;

-- XX번 XXX의 월급은 XXXX원 입니다. 형식으로 출력
SELECT EMP_ID || '번 ' || EMP_NAME || '의 월급은 ' || SALARY || '원 입니다.' AS "급여정보"
FROM EMPLOYEE;

/*
    < 연산자 우선순위 >
    0. () : 우선순위를 높여주는 역할
    1. 산술연산자 : 수학 산술연산을 해줌
    2. 연결연산자 : 컬럼과 리터럴값 또는 컬럼과 컬럼값을 연결해줌
    3. 비교연산자 : 대소비교 또는 동등비교를 해줌
    { 4. IS NULL, IS NOT NULL : NULL 값인지 아닌지 판단해줌
    5. LIKE : 패턴을 제시해서 패턴에 부합하는지 판별
    6. IN : 제시한 목록중 하나라도 일치하는게 있는지 판별 (동등비교 + OR 연산) } => 4, 5, 6 은 같은 우선순위이다.
    7. BETWEEN AND : 특정 범위에 해당되는지 체크 (하한값 <= 비교대상 <= 상한값)
    8. NOT : 조건을 반전시키는 역할
    9. AND : 조건을 "그리고" 라는 키워드로 연결
    10. OR : 조건을 "또는" 이라는 키워드로 연결
*/

--------------------------------------------------------------------------------------------

/*
    < ORDER BY 절 >
    SELECT 문 가장 마지막에 기입하는 구문 뿐만 아니라 실행 순서 또한 가장 마지막
    조회된 데이터들을 정렬해주는 역할 (오름차순인지 내림차순인지 / 무엇을 기준으로 정렬할건지)
    
    [ 표현법 ]
    SELECT 조회할컬럼명1, 컬럼명2, ...
    FROM 테이블명
    WHERE 조건식
    ORDER BY [정렬기준으로세우고자하는컬럼명/별칭/컬럼순번] [ASC/DESC] ~~~~;
    
    => WHERE절, ORDER BY 절은 생략 가능
*/




