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
    컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명(참조할컬럼명)
    
    -테이블레벨 방식
    [CONSTRAINT 제약조건명] FOREIGN KEY (제약조건을걸컬럼명) REFERENCES 참조할테이블명(참조할컬럼명)
    
    단, 두 방식 모두 참조할컬럼명은 생략 가능하다
    이 경우 기본적으로 참조할테이블의 PRIMARY KEY 컬럼으로 참조할컬럼명이 자동으로 잡힌다
    CONSTRAINT 제약조건명은 생략 가능하다
*/

--테스트를 위한 부모 테이블 생성
--회원 등급에 대한 데이터(등급코드, 등급명)를 보관하는 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE CHAR(2) PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

INSERT INTO MEM_GRADE VALUES('G1','일반회원');
INSERT INTO MEM_GRADE VALUES('G2','우수회원');
INSERT INTO MEM_GRADE VALUES('G3','특별회원');

SELECT * FROM MEM_GRADE;

--자식 테이블(외래키 제약조건 걸어보기)
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE), --컬럼레벨 방식
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE
);

INSERT INTO MEM VALUES(1,'user01','pass01','홍길동','G1',NULL,NULL,NULL,DEFAULT);
INSERT INTO MEM VALUES(2,'user02','pass02','김말똥','G2',NULL,NULL,NULL,DEFAULT);
INSERT INTO MEM VALUES(3,'user03','pass03','고영희','G1',NULL,NULL,NULL,DEFAULT);
INSERT INTO MEM VALUES(4, 'user04','pass04','박개똥',NULL,NULL,NULL,NULL,DEFAULT);
--외래키 제약조건이 걸려있는 컬럼에는 기본적으로 NULL값이 들어갈 수 있다

INSERT INTO MEM VALUES(5,'user05','pass05','고길동','G5',NULL,NULL,NULL,DEFAULT);
--integrity constraint (DDL.SYS_C007166) violated - parent key not found
--PARENT KEY NOT FOUND
--G5 등급이 부모테이블인 MEM_GRADE 테이블의 GRADE_CODE 컬럼에서 제공하는 값이 아니기 때문에 오류 발생

--문제)부모테이블(MEM_GRADE)에서 데이터값이 삭제된다면?
--MEM_GRADE 테이블로부터 GRADE_CODE가 G1인 데이터를 지우기
DELETE FROM MEM_GRADE WHERE GRADE_CODE='G1';
--integrity constraint (DDL.SYS_C007166) violated - child record found
--CHILD RECODE FOUND 
--자식테이블 (MEM) 중에 G1이라는 값을 사용하고있는 행들이 존재하기 때문에 부모값을 삭제할 수가 없다
--현재 외래키 제약조건 부여시 추가적으로 삭제옵션을 부여하지 않았음
--자식테이블에서 사용하고 있는 값이 있을 경우 삭제가 되지 않는 "삭제 제한 옵션"이 기본적으로 걸려있음

DELETE FROM MEM_GRADE WHERE GRADE_CODE='G3'; --자식테이블에서 사용되고 있는 값이 아니기 때문에 삭제가 가능함

SELECT * FROM MEM_GRADE;

--그동안 테스트했던거 되돌리기
ROLLBACK;

--MEM 테이블 삭제
DROP TABLE MEM;

/*
    자식 테이블을 생성 시(외래키 제약조건을 부여 시)
    부모 테이블의 데이터가 삭제되었을 때 자식 테이블에서는 어떻게 삭제된 값에 대해서 처리 할 것인지를 옵션으로 정해놓을 수 있음
    
    * FOREIGN KEY 삭제 옵션
    -ON DELETE RESTRICTED: 삭제 옵션을 별도로 제시하지 않았을 때(기본값)=> 삭제 제한
    -ON DELETE SET NULL: 부모데이터를 삭제 시 해당 데이터를 사용하고있는 자식데이터를 NULL로 변경
    -ON DELETE CASCADE: 부모데이터를 삭제 시 해당 데이터를 사용하고있는 자식데이터도 같이 삭제
*/

--1) ON DELETE SET NULL: 부모데이터 삭제 시 해당 데이터를 사용하고 있는 자식데이터를 NULL로 변경하는 옵션
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE), 
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE,
    FOREIGN KEY (GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL
);

SELECT * FROM MEM;

--부모테이블(MEM_GRADE)의 GRADE_CODE가 G1인 데이터 삭제
DELETE FROM MEM_GRADE WHERE GRADE_CODE='G1'; --문제없이 잘 삭제가 됨

--자식테이블(MEM)의 GRADE_ID가 G1인 부분은? NULL값으로 바뀜

--그동안 테스트했던거 되돌리기
ROLLBACK;

--MEM 테이블 삭제
DROP TABLE MEM;

--2)ON DELETE CASCADE : 부모데이터를 삭제 시 해당 데이터를 사용하고 있는 자식 데이터도 같이 삭제하는 옵션
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2),
    GENDER CHAR(3) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE,
    FOREIGN KEY (GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE
);

SELECT * FROM MEM;

--부모테이블(MEM_GRADE)의 G1을 삭제
DELETE FROM MEM_GRADE WHERE GRADE_CODE='G1'; --문제없이 잘 삭제됨
--자식테이블 (MEM)의 GRADE_ID가 G1인 행들은? 함께 삭제가 되어버림

--[참고]
--외래키와 조인
--전체 회원의 회원번호, 아이디, 비밀번호, 이름, 등급명 조회
-->>오라클 전용 구문
SELECT MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_NAME
FROM MEM, MEM_GRADE
WHERE GRADE_ID=GRADE_CODE(+);

-->>ANSI 구문
SELECT MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GRADE_NAME
FROM MEM
LEFT JOIN MEM_GRADE ON (GRADE_ID=GRADE_CODE);

/*
    굳이 외래키 제약조건이 걸려있지 않더라도 JOIN이 가능함
    다만, 두 컬럼에 동일한 의미의 데이터만 담겨있다면 매칭해서 JOIN 조회 가능함
    
*/

ROLLBACK;

DROP TABLE MEM;

--[참고] 서브쿼리를 이용한 테이블 생성(테이블 복사의 개념)

/*
    ---여기서부터 KH계정으로 접속해서 테스트---
    
    *SUBQUERY를 이용한 테이블 생성(테이블 복사 뜨는 개념)
    서브쿼리: 메인 SQL문(SELECT, CREATE, INSERT, UPDATE)를 보조역할 하는 쿼리문 (SELECT)
    
    [표현법]
    CREATE TABLE 테이블명 AS (서브쿼리);
    
    해당 서브쿼리를 실행한 결과를 이용해서 새로운 테이블을 생성하는 개념
*/

--EMPLOYEE 테이블을 복제한 새로운 테이블 생성(EMPLOYEE_COPY)
CREATE TABLE EMPLOYEE_COPY AS (SELECT * FROM EMPLOYEE);

-->컬럼들, 조회결과의 데이터값들이 잘 복사됨 + 제약조건의 경우에는 NOT NULL만 복사됨

SELECT * FROM EMPLOYEE_COPY;

--EMPLOYEE 테이블에 있는 컬럼의 구조만 복사하고싶음. 데이터값은 필요없는 경우
CREATE TABLE EMPLOYEE_COPY2 AS (SELECT * FROM EMPLOYEE WHERE 1=0); 
--WHERE절에 거짓을 작성해준다
SELECT * FROM EMPLOYEE_COPY2;

--전체 사원들 중 급여가 300만원 이상인 사원들의 사번, 이름, 부서코드, 급여 컬럼을 복제
CREATE TABLE EMPLOYEE_COPY3 AS (SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY>=3000000);
SELECT * FROM EMPLOYEE_COPY3;

--전체 사원의 사번, 사원명, 급여, 연봉 조회 결과 테이블을 생성
CREATE TABLE EMPLOYEE_COPY4 AS
(SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE);
--must name this expression with a column alias
--서브쿼리의 SELECT절 부분에 산술연산 또는 함수식이 기술된 경우 반드시 별칭 부여를 해야함

CREATE TABLE EMPLOYEE_COPY4 AS (SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 "연봉" FROM EMPLOYEE);
SELECT * FROM EMPLOYEE_COPY4;

--[참고] 기존 테이블에 제약조건을 추가하는 방법
/*
    *테이블이 이미 다 생성된 후 뒤늦게 제약조건을 추가(ALTER TABLE 테이블명 ~~)
    
    -PRIMARY KEY: ADD PRIMARY KEY(컬럼명);
    -FOREIGN KEY: ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명(참조할컬럼명);
                        ->참조할컬럼명은 생략 가능, 이 경우 참조할테이블명의 PRIMARY KEY로 잡힌다
    -UNIQUE: ADD UNIQUE (컬럼명);
    -CHECK: ADD CHECK (컬럼에 대한 조건식);
    -NOT NULL: MODIFY 컬럼명 NOT NULL;
*/
--EMPLOYEE_COPY 테이블에 없는 PRIMARY KEY 제약조건을 추가 (EMP_ID)
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY (EMP_ID);

--EMPLOYEE_COPY 테이블의 DEPT_CODE 컬럼에 외래키 제약조건을 추가 (DEPARTMENT테이블의 DEPT_ID 컬럼을 참조)
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY (DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID); 

--EMPLOYEE_COPY 테이블에 JOB_CODE컬럼에 외래키 제약조건을 추가(JOB테이블의 JOB_CODE 컬럼을 참조)
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY (JOB_CODE) REFERENCES JOB(JOB_CODE);


-- 실습 문제 --
-- 도서관리 프로그램을 만들기 위한 테이블들 만들기 --
-- 이때, 제약조건에 이름을 부여할것
-- 각 컬럼에 주석 달기

-- 1. 출판사들에 대한 데이터를 담기 위한 출판사 테이블 (TB_PUBLISHER)
-- 컬럼 : PUB_NO (출판사번호) -- 기본키 (PUBLISHER_PK)
--        PUB_NAME (출판사명) -- NOT NULL (PUBLISHER_NN)
--        PHONE (출판사전화번호) -- 제약조건 없음
CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY,
    PUB_NAME VARCHAR2(20) CONSTRAINT PUBLISHER_NN NOT NULL,
    PHONE VARCHAR2(15)
);
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사 번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사 명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사 전화번호';
-- 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_PUBLISHER VALUES(1,'KH출판사','02-123-4567');
INSERT INTO TB_PUBLISHER VALUES(2,'당산출판사','02-321-6543');
INSERT INTO TB_PUBLISHER VALUES(3,'정보출판사','02-789-4561');

SELECT * FROM TB_PUBLISHER;

-- 2. 도서들에 대한 데이터를 담기 위한 도서 테이블 (TB_BOOK)
-- 컬럼 : BK_NO (도서번호) -- 기본키 (BOOK_PK)
--        BK_TITLE (도서명) -- NOT NULL (BOOK_NN_TITLE)
--        BK_AUTHOR (저자명) -- NOT NULL (BOOK_NN_AUTHOR)
--        BK_PRICE (가격)
--        BK_PUB_NO (출판사번호) -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
--                                 이 때, 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 한다.
CREATE TABLE TB_BOOK(
    BK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BK_TITLE VARCHAR2(30) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BK_AUTHOR VARCHAR2(20) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER CONSTRAINT BOOK_FK REFERENCES TB_PUBLISHER(PUB_NO) ON DELETE CASCADE
);
COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';
-- 5개 정도의 샘플 데이터 추가하기
INSERT INTO TB_BOOK VALUES (1, '1월의 날씨', '홍길동', 10000, 1);
INSERT INTO TB_BOOK VALUES (2, '2월의 날씨', '김기동', 20000, 2);
INSERT INTO TB_BOOK VALUES (3, '3월의 날씨', '이백조', 30000, 3);
INSERT INTO TB_BOOK VALUES (4, '4월의 날씨', '최부자', 40000, 1);
INSERT INTO TB_BOOK VALUES (5, '5월의 날씨', '박대감', 50000, 2);

SELECT * FROM TB_BOOK;

-- 3. 회원에 대한 데이터를 담기 위한 회원 테이블 (TB_MEMBER)
-- 컬럼명 : MEMBER_NO (회원번호) -- 기본키 (MEMBER_PK)
--         MEMBER_ID (아이디) -- 중복금지 (MEMBER_UQ)
--         MEMBER_PWD (비밀번호) -- NOT NULL (MEMBER_NN_PWD)
--         MEMBER_NAME (회원명) -- NOT NULL (MEMBER_NN_NAME)
--         GENDER (성별) -- 'M' 또는 'F' 로 입력되도록 제한 (MEMBER_CK_GEN)
--         ADDRESS (주소)
--         PHONE (연락처)
--         STATUS (탈퇴여부) -- 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N' 으로만 입력되도록 제약조건 (MEMBER_CK_ST)
--         ENROLL_DATE (가입일) -- 기본값으로 SYSDATE, NOT NULL 제약조건 (MEMBER_NN_EN)
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(15) CONSTRAINT MEMBER_UQ NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(15) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME VARCHAR2(15) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER CHAR(2) CONSTRAINT MEMBER_CK_GEN CHECK (GENDER IN ('M', 'F')),
    ADDRESS VARCHAR2(100),
    PHONE VARCHAR2(15),
    STATUS CHAR(2) DEFAULT 'N' CONSTRAINT MEMBER_CK_ST CHECK(STATUS IN ('Y', 'N')),
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL 
);
COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';
-- 5개 정도의 샘플 데이터 추가하기
INSERT INTO TB_MEMBER VALUES(1,'user01','pass01','일인자','M','강남구 일원동','010-1234-5678','Y',DEFAULT);
INSERT INTO TB_MEMBER VALUES(2,'user02','pass02','이인자','F','강서구 송정동','010-2144-1223','Y',DEFAULT);
INSERT INTO TB_MEMBER VALUES(3,'user03','pass03','삼인자','F','강남구 삼성동','010-2461-8532',DEFAULT,DEFAULT);
INSERT INTO TB_MEMBER VALUES(4,'user04','pass04','사인자','M','강서구 개화동','010-2152-3556',DEFAULT,DEFAULT);
INSERT INTO TB_MEMBER VALUES(5,'user05','pass05','오인자','M','영등포구 당산동','010-5665-5319','Y',DEFAULT);
SELECT * FROM TB_MEMBER;
-- 4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블 (TB_RENT)
-- 컬럼 : RENT_NO (대여번호) -- 기본키 (RENT_PK)
--        RENT_MEM_NO (대여회원번호) -- 외래키 (RENT_FK_MEM) TB_MEMBER 와 참조하도록
--                                    이 때, 부모 데이터 삭제 시 자식 데이터 값이 NULL 이 되도록 옵션 설정
--        RENT_BOOK_NO (대여도서번호) -- DHLFOZL (RENT_FK_BOOK) TB_BOOK 와 참조하도록
--                                     이 때, 부모 데이터 삭제 시 자식 데이터 값이 NULL 값이 되도록 옵션 설정
--        RENT_DATE (대여일) -- 기본값 SYSDATE
CREATE TABLE TB_RENT(
    RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER(MEMBER_NO) ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK(BK_NO) ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';
-- 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_RENT VALUES(1, 1, 1, DEFAULT);
INSERT INTO TB_RENT VALUES(2, 2, 2, DEFAULT);
INSERT INTO TB_RENT VALUES(3, 3, 3, DEFAULT);

SELECT * FROM TB_RENT;










