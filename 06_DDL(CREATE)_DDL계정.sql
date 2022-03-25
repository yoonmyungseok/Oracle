/*
    DDL(DATA DEFINITION LANGUAGE)
    데이터 정의 언어
    
    오라클에서 제공하는 객체(OBJECT)를 새로 만들고 (CREATE), 구조를 변경하고(ALTER), 구조 자체를 삭제하는(DROP) 명령문
    즉, 구조 자체를 정의하는 언어로 주로 DB관리자나 설계자가 사용함
    
    오라클에서의 객체: 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 사용자(USER), 패키지(PACKAGE), 트리거(TRIGGER), 프로시저(PROCEDURE), 함수(FUNCTION), 동의어(SYNONYM)
*/

/*
    <CREATE TABLE>
    테이블이란? : 행(ROW)과 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체
    항상 모든 데이터는 테이블을 통해서 저장됨
    즉, 데이터를 보관하고자 한다면 테이블을 만들어야 한다
    
    [표현법]
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형, 
        컬럼명 자료형,
        ...
    );
    
    <자료형>
    -문자: CHAR(사이즈) / VARCHAR2(사이즈) - 크기는 BYTE수(숫자, 영문자, 특수문자=>1글자당 1BYTE, 한글=>1글자당 3BYTE)
    CHAR(바이트수): 고정길이 문자열(아무리 적은 값이 들어가더라도 공백으로 채워서 처음 할당한 크기를 유지)
                         최대 2000BYTE까지 지정 가능함=>주로 들어올 값의 글자수가 정해져있을 때 사용한다 EX)성별: 남/여 (3BYTE), M/F(1BYTE), 주민번호: 생년월일 6숫자-7숫자(14BYTE)
    VARCHAR2(바이트수): 가변길이 문자열(아무리 적은 값이 들어가도 그 담긴 값에 맞춰서 크기가 줄어든다)
                                최대 4000BYTE까지 지정 가능함 
                                VAR는 '가변'을 의미하고, 2는 '두배'를 의미함
                                =>들어올 값의 글자수가 명확하게 정해져있지 않을 때 사용한다 EX)이름, 이메일주소, 집주소
    
    -숫자: NUMBER - 정수/실수 상관없이 NUMBER이다.
    
    -날짜: DATE - 년,월,일,시,분,초의 개념이 들어간 자료형
*/

--회원들의 데이터를 담을 수 있는 테이블 만들기
--테이블명 : MEMBER
--컬럼종류 : 아이디, 비밀번호, 이름, 가입일
CREATE TABLE MEMBER (
    MEMBER_ID VARCHAR2(20), --오라클에서는 대소문자 구분을 안하기 때문에 낙타봉표기법이 불가하므로 언더바로 단어 사이를 구분
    MEMBER_PWD VARCHAR2(16),
    MEMBER_NAME VARCHAR2(15),
    MEMBER_DATE DATE
);

SELECT * FROM MEMBER; --테이블명을 잘 작성했다면 내용물이 없는 상태로 조회
SELECT * FROM MEMBER2; --table or view does not exist : 없는 테이블명을 조회하고자 했을 때 발생하는 오류

/*
    컬럼에 주석 달기(컬럼에 대한 설명)
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
*/
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '회원가입일';

--참고) 해당 계정에 어떤 테이블들이 존재하는지, 어떤 컬럼명들이 존재하는지 알 수 있는 방법
--데이터 딕셔너리: 다양한 객체들의 정보를 저장하고있는 시스템 테이블(관리용)
SELECT * FROM USER_TABLES;
--USER_TABLES : 현재 이 계정이 가지고 있는 테이블들의 전반적인 구조를 확인할 수 있는 데이터 딕셔너리

SELECT * FROM USER_TAB_COLUMNS;
--USER_TAB_COLUMNS : 현재 이 계정이 가지고 있는 테이블들의 모든 컬럼들의 정보를 조회할 수 있는 데이터 딕셔너리

SELECT * FROM MEMBER;

--데이터를 추가할 수 있는 구문(INSERT : 한 행 단위로 추가, 값의 순서를 잘 맞춰서 작성)
--INSERT INTO 테이블명 VALUES(첫번째컬럼의값, 두번째컬럼의값, 세번째컬럼의값, ...);
INSERT INTO MEMBER VALUES('user01', 'pass01', '홍길동', '2021-02-01');
INSERT INTO MEMBER VALUES('user02', 'pass02', '김말똥', '21/02/02');
INSERT INTO MEMBER VALUES('user03', 'pass03', '김나박', SYSDATE);
INSERT INTO MEMBER VALUES('가나다라마바사', 'PASS04', '김갑생', SYSDATE);
--value too large for column "DDL"."MEMBER"."MEMBER_ID" (actual: 21, maximum: 20) 오류 발생
--최대 20바이트까지 저장 가능한데 21바이트짜리 값을 넣었다고 오류 발생


INSERT INTO MEMBER VALUES('user04', NULL, NULL, SYSDATE);
INSERT INTO MEMBER VALUES(NULL,NULL,NULL,SYSDATE);
--오류가 발생하지 않음, 단, 유효한 값이 아닌 값들이 들어가는 상황=>큰 문제
--아이디, 비밀번호, 이름에 NULL 값이 존재해서는 안됨
INSERT INTO MEMBER VALUES('user03', 'pass03', '고길동', SYSDATE);
--중복된 아이디는 존재해서는 안됨
--위의 NULL값이나 중복된 아이디값은 유효하지 않은 값들이다
--유효한 데이터값을 유지하기 위해서는 "제약조건"을 걸어줘야 한다

-------------------------------------------------------------------------
/*
    <제약 조건 CONSTRAINTS>
    -원하는 데이터값만 유지하기 위해서(유효한 값들만 보관하기 위해서) 특정 컬럼마다 설정하는 제약
    (최대 목적: 데이터 무결성 보장을 목적으로 한다)
    -애초에 제약조건이 부여된 컬럼에 들어올 데이터에 문제가 있는지 없는지 우선적으로 검사할 목적
    -종류: NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FORIEGN KEY
    -컬럼에 제약조건을 부여하는 방식: 컬럼레벨/테이블레벨
*/

/*
    1. NOT NULL 제약조건
    해당 컬럼에 반드시 값이 존재해야할 경우에 사용한다(즉, NULL값이 절대로 들어와서는 안되는 컬럼에 부여)
    INSERT할 때 / UPDATE할 때도 마찬가지로 NULL값을 허용하지 않도록 제한
    
    단, NOT NULL 제약조건은 컬럼레벨 방식 밖에 안됨
*/

--NOT NULL 제약조건만 설정한 테이블 만들기(회원번호, 아이디, 비밀번호, 이름)
--컬럼레벨 방식: 컬럼명 자료형 제약조건=>제약조건을 부여하고자하는 컬럼 뒤에 곧바로 기술
CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);

SELECT * FROM MEM_NOTNULL;

INSERT INTO MEM_NOTNULL VALUES(1,'user01','pass01','홍길동','남','010-1234-5678','abc@naver.com');
INSERT INTO MEM_NOTNULL VALUES(2,NULL,NULL,NULL,NULL,NULL,NULL);
--cannot insert NULL into ("DDL"."MEM_NOTNULL"."MEM_ID")
--NOT NULL 제약조건에 위배되어 오류 발생

INSERT INTO MEM_NOTNULL VALUES(3,'user02','pass02','김말똥',null,null,null);
INSERT INTO MEM_NOTNULL VALUES(4,'user03','pass03','박개똥','여',null,null);
--NOT NULL 제약조건이 부여되어있는 컬럼에는 반드시 값이 존재해야 함

--------------------------------------------------------------------------------------------------------------------
/*
    2. UNIQUE 제약조건
    컬럼에 중복값을 제한하는 제약조건
    삽입 / 수정 시 기존에 해당 컬럼값 중에 중복값이 있을 경우
    추가 또는 수정이 되지 않게끔 제약
    
    컬럼레벨 / 테이블레벨 방식 둘 다 가능
*/

--UNIQUE 제약조건을 추가한 테이블 생성
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, --컬럼레벨 방식(제약조건을 여러개 사용할 경우 띄어쓰기로 나열)
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)    
);

--테이블레벨 방식
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    UNIQUE (MEM_ID)--테이블레벨 방식
);
--name is already used by an existing object
--테이블명 중복 시 해당 오류가 발생

--테이블을 삭제시킬 수 있는 구문
DROP TABLE MEM_UNIQUE;

SELECT * FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE VALUES(1, 'user01', 'pass01', '홍길동', '남','010-1234-1234', 'abc@naver.com');
INSERT INTO MEM_UNIQUE VALUES(2, 'user02', 'pass02', '김말똥', NULL, NULL, NULL);
INSERT INTO MEM_UNIQUE VALUES(3, 'user02', 'pass02', '고영희', NULL, NULL, NULL);
--unique constraint (DDL.SYS_C007106) violated
--UNIQUE 제약조건에 위배되었으므로 INSERT 실패
--해당 오류구문으로 제약조건명을 알려줌( 정확하게 어떤 컬럼에 문제가 발생했는지 컬럼명으로 알려주지는 않음)=>쉽게 오류를 파악할 수 없다
--제약조건 부여 시 직접 제약조건명을 지정해주지 않으면 시스템에서 알아서 임의의 제약조건명을 부여해줌(SYS_C~~~~)

/*
    제약조건 부여 시 제약조건명도 지정하는 표현법들
    -컬럼레벨 방식일 경우
    CREATE TABLE 테이블명(
        컬럼명 자료형 CONSTRAINT 제약조건명 제약조건,
        컬럼명 자료형,
        ...
    );
    
    -테이블레벨 방식일 경우
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        ...,
        CONSTRAINT 제약조건명 제약조건 (컬럼명)
    );
    
    이 때, 두 방식 모두 CONSTRAINT 제약조건명 부분은 생략 가능하다
*/

--제약조건명 붙이는 연습
CREATE TABLE MEM_CON_NM(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEM_NAME_NN NOT NULL, --컬럼레벨 방식
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    CONSTRAINT MEM_ID_UNIQUE UNIQUE(MEM_ID) --테이블레벨 방식
);

SELECT * FROM MEM_CON_NM;

INSERT INTO MEM_CON_NM VALUES(1,'user01','pass01','홍길동',null,null,null);
INSERT INTO MEM_CON_NM VALUES(2,'user01','pass02','고길동',null,null,null);
--unique constraint (DDL.MEM_ID_UNIQUE) violated
--제약조건명을 지어줄 경우에는 컬럼명, 제약조건의 종류를 적절히 섞어서 지어주는것이 오류 파악에 더 도움이됨

SELECT * FROM MEM_CON_NM;

INSERT INTO MEM_CON_NM VALUES(2,'user02','pass02','고길동','가',null,null);
--GENDER 컬럼에 '남'또는 '여'만 들어가게끔 하고 싶음
---------------------------------------------------------------------------------------------------------------------
/*
    3. CHECK 제약조건
    컬럼에 기록될 수 있는 값에 대한 조건을 설정해 둘 수 있는 제약조건
    
    CHECK (조건식)
*/

--CHECK 제약조건이 추가된 테이블
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')), --GENDER 컬럼에는 '남' 또는 '여'만 들어가야한다
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE NOT NULL
);

SELECT * FROM MEM_CHECK;

INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','홍길동','남','010-1111-1111', null, sysdate);

INSERT INTO MEM_CHECK VALUES(2,'user02','pass02','김개똥',null,null,null,sysdate);
--CHECK 제약조건에 NULL값도 INSERT가 가능함
--만약에 NULL값이 못들어오게 막고싶다면? NOT NULL 추가

INSERT INTO MEM_CHECK VALUES(3, 'user03','pass03','김말똥','가',null,null,sysdate);
--check constraint (DDL.SYS_C007117) violated
--CHECK 제약조건을 위배했을 경우 위의 오류 발생

SELECT * FROM MEM_CHECK;

--회원가입일을 항상 SYSDATE 값으로 받고 싶은 경우 테이블 생성시 지정 가능하다(기본값 설정 옵션)
/*
    특정 컬럼에 들어올 값에 대해 기본값을 설정 가능하다=>DEFAULT
    (단, 제약조건 종류는 아님)
*/

--MEM_CHECK 테이블 삭제
DROP TABLE MEM_CHECK;

--기존의 MEM_CHECK 테이블에 DEFAULT 설정까지 추가
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL
);
/*
    INSERT INTO 테이블명 VALUES(값1, 값2,...); =>항상 값들의 개수는 컬럼의 개수와 일치, 순서도 일치
    
    INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3) VALUES(값1, 값2, 값3); =>일부 컬럼들만 지정해서 값을 넣을 수 있는 구문
*/

INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','홍길동','남',NULL,NULL);
--not enough values
--값들의 개수가 충분하지 않다 (실제 컬럼은 8개, 제시한 값은 7개라서 발생한 오류)

INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PW, MEM_NAME) VALUES(1,'user01','pass01','홍길동');
--지정이 안된 컬럼에는 기본적으로 NULL이 채워져서 한 행이 추가됨
--만약에 DEFAULT 설정이 되어있다면 NULL값이 아니라 DEFAULT값이 추가되는것을 확인 할 수 있다
--그러면 DEFAULT 설정 했을 때 처음 배운 구문 형식으로 INSERT하고 싶다면?
INSERT INTO MEM_CHECK VALUES(2, 'user02','pass02','고길동',null,null,null,default);
--DEFAULT 설정값 부분에 DEFAULT라고 적어주면 됨

--DEFAULT 설정 시 다른 값을 담아도 무관
INSERT INTO MEM_CHECK VALUES(3,'user03','pass03','김개똥',null,null,null,'2021-03-15');
SELECT * FROM MEM_CHECK;
--------------------------------------------------------------------------------------------------------------------------------------------

/*
    4. PRIMARY KEY (기본키) 제약조건
    테이블에서 각 행들의 정보를 유일하게 식별해줄 수 있는 컬럼에 부여하는 제약조건
    =>각 행 한줄 한줄 마다 구분할 수 있는 식별자의 역할( 자바에서 MAP의 KEY값)
    예)사번, 학번, 예약번호, 주문번호, 아이디, 주민번호, 이메일, 휴대폰번호, 회원번호 등
    =>중복되지 않고 값이 존재해야만 하는 컬럼에 PRIMARY KEY 부여(UNIQUE+NOT NULL)
    
    단, 한 테이블에 한 개의 PRIMARY KEY만 존재해야한다
    -PRIMARY KEY 제약조건을 컬럼 한 개에만 거는것: 기본키
    -PRIMARY EKY 제약조건을 컬럼 여러개를 묶어서 한번에 거는 것: 복합키
*/

--PRIMARY KEY 제약조건을 추가한 테이블 생성
CREATE TABLE MEM_PRIMARYKEY1(
    MEM_NO NUMBER CONSTRAINT MEM_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE --DEFAULT 설정 시 굳이 NOT NULL을 안넣어도 됨
);

INSERT INTO MEM_PRIMARYKEY1 VALUES(1, 'user01','pass01','홍길동','남',NULL,NULL,DEFAULT);

SELECT * FROM MEM_PRIMARYKEY1;

INSERT INTO MEM_PRIMARYKEY1 VALUES(1, 'user02','pass02','김말똥',NULL,NULL,NULL,DEFAULT);
--unique constraint (DDL.MEM_PK) violated
--기본키 컬럼에 중복값이 들어갈 경우 UNIQUE 제약조건을 위배했다고 오류 발생
--이 경우, 제약조건명을 갖고 정확히 UNIQUE를 위배한건지 PRIMARY KEY를 위배한건지 찾아가야함
--그래서 PRIMARY KEY의 경우 제약 조건명을 붙이는 습관을 들이자(보통은 테이블명_PK)

--NULL값이 허용되나?
INSERT INTO MEM_PRIMARYKEY1 VALUES(NULL, 'user02','pass02','김말똥',NULL,NULL,NULL,DEFAULT);
--cannot insert NULL into ("DDL"."MEM_PRIMARYKEY1"."MEM_NO")
--기본키 컬럼에 NULL 값이 들어갈 경우 NOT NULL 제약조건을 위배했다고 오류 발생
--계정명.테이블명.컬럼명

INSERT INTO MEM_PRIMARYKEY1 VALUES(2, 'user02','pass02','김말똥',NULL,NULL,NULL,DEFAULT);

--테이블레벨 방식으로 PRIMARY KEY 제약조건 걸기
CREATE TABLE MEM_PRIMARYKEY2(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEM_PK PRIMARY KEY (MEM_NO) --테이블레벨 방식
);
--name already used by an existing constraint
--아무리 다른 테이블의 제약조건 이더라도 제약조건명이 중복되서는 안된다

--복합키 : 여러 컬럼을 묶어서 한번에 PRIMARY KEY 제약조건을 주는 것
CREATE TABLE MEM_PRIMARYKEY3(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) PRIMARY KEY,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE
);
--table can have only one primary key
--PRIMARY KEY가 한 테이블에 두개가 될 수 없다
--단, 두 컬럼을 하나로 묶어서 PRIMARY KEY 하나로 설정 가능하다

CREATE TABLE MEM_PRIMARYKEY3(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE,
    PRIMARY KEY (MEM_NO, MEM_ID) --컬럼을 묶어서 PRIMARY KEY 하나로 설정 : 복합키
); 

INSERT INTO MEM_PRIMARYKEY3 VALUES (1,'user01','pass01','홍길동',NULL,NULL,NULL,DEFAULT);

SELECT * FROM MEM_PRIMARYKEY3;

INSERT INTO MEM_PRIMARYKEY3 VALUES (1,'user02','pass02','김개똥',null,null,null,default);
--복합키의 경우 해당 컬럼에 들은 값들이 완전히 다 일치해야만 중복으로 판별
--만일 하나라도 값이 다를 경우에는 중복으로 판별이 안됨

INSERT INTO MEM_PRIMARYKEY3 VALUES (2, NULL, 'pass02', '김개똥',null,null,null,default);
--cannot insert NULL into ("DDL"."MEM_PRIMARYKEY3"."MEM_ID")
--복합키의 경우 복합키에 해당하는 컬럼값들 중에서 하나라도 NULL이 들어가면 안됨

-------------------------------------------------------------------------------------------------------------------

/*
    5. FOREIGN KEY (외래키) 제약조건
    해당 컬럼에 다른 테이블에 존재하는 값만 들어와야되는 컬럼에 부여하는 제약조건
    
    예시)KH계정에서 EMPLOYEE 테이블의 JOB_CODE 컬럼에 들어있는 값들은 반드시 JOB 테이블의 JOB_CODE 컬럼에 들어있는 값들로 이루어져 있어야 한다(그 이외의 값이 들어오면 안됨)
            ->EMPLOYEE 테이블 입장에서 JOB 테이블의 컬럼값을 끌어다 쓰는 개념(==참조한다)
            ->EMPLOYEE 테이블 입장에서 JOB 테이블을 부모테이블 이라고 표현 가능
            ->JOB 테이블 입장에서 EMPLOYEE 테이블을 자식테이블 이라고 표현 가능
    
    =>다른 테이블 (부모테이블)을 참조한다라고 표현(REFERENCES라는 키워드를 사용) 즉, 참조된 다른 테이블이 제공하고있는 값만 해당 외래키 제약조건이 걸려있는 컬럼에 들어올 수 있다
    =>FOREIGN KEY 제약조건으로 다른 테이블과의 관계를 형성할 수 있다(==JOIN의 개념)
    
    [표현법]
    -컬럼레벨 방식
    
    -테이블레벨 방식
*/
