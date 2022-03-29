/*
    <TCL: TRANSACTION CONTROL LANGUAGE>
    트랜잭션을 제어하는 언어
    
    *트랜잭션(TRANSACTION)
    -데이터베이스의 논리적 연산단위
    -하나의 작업 단위(로그인 기능, 회원가입 기능, 게시글 작성 기능, 게시글 수정 기능 등)
    -한 트랜잭션 안에는 한 개의 쿼리문만 존재할 수도 있지만 여러 개의 쿼리문이 순차적으로 존재하는 경우도 많다
    -데이터의 변경사항 (DML)들을 하나의 트랜잭션으로 묶어서 처리
    COMMIT(확정)하기 전까지의 변경사항들을 킵해뒀다가 모두 다 성공했을 경우에만 확정짓는다
    -트랜잭션의 대상이 되는 SQL: DML(INSERT, UPDATE, DELETE)
    
    COMMIT: 트랜잭션 종료 처리 후 "확정"
    ROLLBACK: 트랜잭션 취소 (되돌리겠다)
    SAVEPOINT: 임시저장점 잡기
    
    [표현법]
    COMMIT; =>하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영하겠다는 것을 의미
                    실제 DB에 반영시킨 후 트랜잭션은 비워짐
    
    ROLLBACK; =>하나의 트랜잭션에 담겨있는 변경사항들을 삭제한 후 "마지막 COMMIT 시점"으로 되돌림
    
    SAVEPOINT 세이브포인트명; =>현재 이 시점까지의 임시저장점을 정의
                                            임시저장점의 구분을 위해서 세이브포인트명을 붙여준다
    
    ROLLBACK TO 세이브포인트명; =>전체 변경사항 전체 다 되돌리는것이 아니라 해당 포인트 지점까지의 트랜잭션만 롤백함
                                         (세이브포인트 지정 전 시점은 아직 유효한 트랜잭션)
*/

SELECT * FROM EMP_01; --25명의 사원 정보

--사번이 901 번인 사원을 삭제
DELETE FROM EMP_01 WHERE EMP_ID=901;

--사번이 900 번인 사원을 삭제
DELETE FROM EMP_01 WHERE EMP_ID=900;

--이 시점까지 봤을 때 총 23명의 사원의 정보가 있음 (아직 확정은 아님)

ROLLBACK; --이 시점에서 위의 DELETE 구문이 두 번 실행되기 전으로 되돌아감

SELECT * FROM EMP_01;

----------------------------------------------

--다시 25명인 상황
--사번이 200번인 사원 삭제
DELETE FROM EMP_01 WHERE EMP_ID=200; --24명이 조회는 되지만 아직 확정은 안된 상태

--사번이 800, 이름 홍길동, 부서는 총무부인 사원 추가
INSERT INTO EMP_01
VALUES (800,'홍길동','총무부');

--25명이 조회되지만 200번 사원은 삭제되었고, 800번 사원이 추가된 상태(확정은 안됨)

COMMIT;--위의 상태 확정

SELECT * FROM EMP_01;

ROLLBACK;  --위의 COMMIT 명령어가 실행된 시점으로 되돌아가겠다

SELECT * FROM EMP_01; --ROLLBACK 실행전과 실행 후의 SELECT 결과가 똑같음(롤백 전후로 INSERT, UPDATE, DELETE가 한번도 안일어나서)

-------------------------------------------------------------

--25명 (200번은 없고 800번 있는 상태)=>지금 상황
SELECT * FROM EMP_01;

--사번이 217, 216, 214 인 사원 삭제 
DELETE FROM EMP_01 WHERE EMP_ID IN (217,216,214);

--이 시점에서는 22명이 조회될것임(확정은 안된상태)
SELECT * FROM EMP_01;

--3개의 행이 삭제된 시점에서 SAVEPOINT 지정
SAVEPOINT SP1; --나중에 롤백을 하더라도 여기까지는 킵해두겠다

--사번 801, 이름 김말똥, 부서는 인사부인 사원 추가
INSERT INTO EMP_01 VALUES (801,'김말똥','인사부');

--23명이 조회될 것(확정은 안됨)
SELECT * FROM EMP_01;

--사번이 218번인 사원 삭제
DELETE FROM EMP_01 WHERE EMP_ID=218;

--22명이 조회될것(확정은 안됨)
SELECT * FROM EMP_01;

--롤백을 하되, SP1 이전까지만 롤백
ROLLBACK TO SP1;

SELECT * FROM EMP_01;

----------------------------------------------------------------------------------------

--[참고]
--22명이 조회되는 상황(확정은 아님)
--사번이 900,901번인 사원 삭제
DELETE FROM EMP_01 WHERE EMP_ID IN (900,901);

--20명이 조회되는 상황(확정은 아님)
SELECT * FROM EMP_01;

--사번이 218인 사원 삭제
DELETE FROM EMP_01 WHERE EMP_ID=218;

--19명이 조회되는 상황(확정은 아님)
SELECT * FROM EMP_01;

--만약 이 시점에서 COMMIT을 실행할 경우 19명의 사원의 정보가 확정됨

--테이블 생성 (DDL)
CREATE TABLE TEST(
    TID NUMBER
);

--19명이 조회되는 상황 
SELECT * FROM EMP_01;

ROLLBACK;

--만약 위의 테이블 생성 구문에 COMMIT 역할이 포함 안됐다면 마지막 COMMIT 시점으로 돌아간다
SELECT * FROM EMP_01;

--사번이 800번인 사원 삭제
DELETE FROM EMP_01 WHERE EMP_ID=800;

SELECT * FROM EMP_01; --18명이 조회됨 (확정 안됨)

ROLLBACK;

SELECT * FROM EMP_01; --19명이 조회됨

/*
    DDL 구문 (CREATE, ALTER, DROP)을 실행하는 순간 기존 트랜잭션에 있던 모든 변경사항들이 무조건 실제 DB에 반영된다(COMMIT)이 된 다음데 DDL이 실질적으로 수행됨
    =>즉, DDL 수행 전 변경사항이 있었다면 정확히 픽스(COMMIT이든 ROLLBACK이든)하고 DDL을 실행하자(주의)
*/