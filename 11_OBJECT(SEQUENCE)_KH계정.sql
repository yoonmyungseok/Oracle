/*
    <시퀀스 SEQUENCE>
    자동으로 번호를 발생시켜주는 역할을 하는 객체
    정수값을 자동으로 순차적으로 생성해줌
    
    예)회원번호, 사번, 게시글번호 등등 채번할 때 주로 사용
    
    1. 시퀀스 객체 생성 구문
    [표현법]
    CREATE SEQUENCE 시퀀스명
    START WITH 시작숫자            =>처음 발생시킬 시작값을 지정
    INCREMENT BY 증가값             =>한 번에 몇씩 증가시킬건지 지정
    MAXVALUE 최대값                 =>최대값 지정
    MINVALUE 최소값                 =>최소값 지정
    CYCLE / NOCYCLE                  =>값의 순환 여부 지정(CYCLE은 순환하겠다, NOCYCLE은 순환 안하겠다)
    CACHE 바이트크기 / NOCACHE  =>캐시메모리 사용 여부 지정(CACHE 바이트크기는 바이트크기만큼의 캐시메모리를 사용하겠다, NOCACHE 캐시메모리를 사용안하겠다)
    
    주의할점: 모든 설정들은 생략 가능
    
    *캐시메모리: 미리 발생될 값들을 생성해서 저장해두는 임시 메모리 공간
    매번 호출할 때마다 새로 변호를 생성하는 것보다 캐시메모리 공간에 미리 생성된 번호들들 저장해뒀다가 가져다 쓰게되면 속도가 더 빠르다
    단, DB접속이 끊기면 기존에 저장되어있던 값들이 다 날아감(임시 메모리 공간이라서, 일회성)
*/

CREATE SEQUENCE SEQ_TEST;

SELECT * FROM USER_SEQUENCES;
--USER_SEQUENCES: 현재 접속한 계정이 소유하고 있는 시퀀스들에 대한 정보 조회용 데이터 딕셔너리
--기본 설정값
--MIN_VALUE: 1
--MAX_VALUE: 9999999999999999999999999999
--INCREMENT_BY: 1
--CYCLE_FLAG: N
--ORDER_FLAG: N
--CACHE_SIZE: 20
--LAST_NUMBER: 1

CREATE SEQUENCE SEQ_EMPNO
    START WITH 300
    INCREMENT BY 5
    MAXVALUE 310
    NOCYCLE
    NOCACHE;


/*
    2. 시퀀스 사용 구문
    번호를 발생시키는 구문
    
    시퀀스명.CURRVAL : 현재 시퀀스의 값(가장 마지막으로 성공적으로 발생한 NEXTVAL 값이 곧 CURRVAL이 된다)
    시퀀스명.NEXTVAL : 시퀀스값을 증가시키고 증가된 시퀀스의 값
                            기존의 시퀀스 값에서 INCREMENT BY 값만큼 증가된 값
                            (시퀀스명.CURRVAL+INCREMENT BY 설정값 == 시퀀스명.NEXTVAL)
    
    *주의사항
    1) 시퀀스 생성 후 첫 CURRVAL 불가능
    2) 시퀀스 생성 후 첫 NEXTVAL 값은 시작값(START WITH 시작숫자)으로 잡힌다
    3) CURRVAL은 가장 마지막으로 성공적으로 수행한 NEXTVAL 값을 담아두는 변수의 개념
    4) MAXVALUE, MINVALUE 범위를 벗어난 값을 발생시킬 수 없다
*/
SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;
--sequence SEQ_EMPNO.CURRVAL is not yet defined in this session
--한번이라도 NEXTVAL을 수행하지 않는 이상 CURRVAL을 사용할 수 없음
--(CURRVAL은 마지막으로 성공적으로 수행된 NEXTVAL의 값을 저장해서 보여주는 임시값이기 때문에)

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --300
--NEXTVAL을 처음 수행하면 START WITH 시작값이 나온다
--이제서야 CURRVAL 값이 300으로 저장된다

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --300

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --300

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --305

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --305

SELECT * FROM USER_SEQUENCES;
--LAST_NUMBER: 현재 상황에서 NEXTVAL을 실행할 경우의 예정 값

--예정값: 310
--현재값: 305
--증가값: 5

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --310

--현재값:310
--예정값:원래대로라면 315
--최대값:310
SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL;
--sequence SEQ_EMPNO.NEXTVAL exceeds MAXVALUE and cannot be instantiated
--지정한 MAXVALUE 값=310을 초과했기 때문에 오류 발생

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --310
--마지막에 "성공적으로" 발생한 NEXTVAL 값

/*
    3. 시퀀스 변경 구문
    
    [표현법]
    ALTER SEQUENCE 시퀀스명
        INCREMENT BY 증가값
        MAXVALUE 최대값
        MINVALUE 최소값
        CYCLE / NOCYCLE
        CACHE 바이트크기 / NOCACHE;
        
        *START WITH는 변경 불가 =>정 바꾸고 싶다면 기존 시퀀스를 삭제했다가 다시 생성
*/

ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

--잘 바뀌었나 데이터 딕셔너리 조회
SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --310

--예상값 :320
SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL;

--이 시점에서 CURRVAL은 320

--SEQUENCE 삭제하기
DROP SEQUENCE SEQ_EMPNO;

----------시퀀스 사용 예시------------

--매번 새로운 사번이 발생되는 시퀀스 생성
CREATE SEQUENCE SEQ_EID
    START WITH 300;

--이 시점에서 CURRVAL: 안나옴
--이 시점에서 NEXTVAL: 300

--사원이 추가될 때 EMPLOYEE 테이블에 INSERT
INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE,SAL_LEVEL,HIRE_DATE)
VALUES(SEQ_EID.NEXTVAL, '홍길동', '910110-1188213', 'J2', 'S3', SYSDATE);

SELECT * FROM EMPLOYEE;

SELECT SEQ_EID.CURRVAL FROM DUAL; --300

INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE,SAL_LEVEL,HIRE_DATE)
VALUES(SEQ_EID.NEXTVAL, '고길동', '910110-1188213', 'J2', 'S3', SYSDATE);

SELECT SEQ_EID.CURRVAL FROM DUAL; --301

SELECT SEQ_EID.NEXTVAL FROM DUAL; --302

INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE,SAL_LEVEL,HIRE_DATE)
VALUES(SEQ_EID.NEXTVAL, '김길동', '910110-1188213', 'J2', 'S3', SYSDATE);

