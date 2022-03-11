--일반 사용자 계정을 만들 수 있는 권한은 관리자 계정에 있음
--사용자 계정을 만드는 방법
--[표현법] CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER KH IDENTIFIED BY KH;

--생성된 사용자 계정에게 최소한의 권한 (접속, 데이터관리) 부여
--[표현법] GRANT 권한명1, 권한명2, ... TO 계정명;
GRANT CONNECT, RESOURCE TO KH;

-- 한줄 주석
/*
    여러줄
    주석
*/