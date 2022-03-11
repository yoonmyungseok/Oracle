<<<<<<< HEAD
/*
    <SELECT>
    �����͸� ��ȸ�ϰų� �˻��� �� ����ϴ� ��ɾ�
    ResultSet : SELECT ������ ���� ��ȸ�� �����͵��� ������� �ǹ� ��, ��ȸ�� ����� ����
    [ǥ����]
    SELECT ��ȸ�ϰ����ϴ��÷���1, �÷���2, �÷���3, ...
    FROM ���̺��;
*/

-- EMPLOYEE ���̺��� ��ü ������� ���, �̸�, �޿� �÷����� ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE;

--��ɾ�, Ű����, ���̺��, �÷��� ���� ��ҹ��ڸ� ������ ����
--�ҹ��ڷ� �ᵵ ����

--EMPLOYEE ���̺��� ��ü ������� ��� �÷��� ��ȸ
SELECT * FROM EMPLOYEE;

--JOB ���̺��� ��� �÷��� ��ȸ
SELECT * FROM JOB;

--JOB ���̺��� ���޸� �÷��� ��ȸ
SELECT JOB_NAME FROM JOB;

-------�ǽ� ����-------
--1. DEPARTMENT ���̺��� ��� �÷� ��ȸ
SELECT * FROM DEPARTMENT;
--2. EMPLOYEE ���̺��� ������, �̸���, ��ȭ��ȣ, �Ի��� �÷��� ��ȸ
SELECT EMP_ID, EMAIL, PHONE, HIRE_DATE FROM EMPLOYEE;
--3. EMPLOYEE ���̺��� �Ի���, ������, �޿� �÷��� ��ȸ
SELECT HIRE_DATE, EMP_NAME, SALARY FROM EMPLOYEE;

/*
    <�÷����� ���� �������>
    ��ȸ�ϰ��� �ϴ� �÷����� �����ϴ� SELECT ���� �������( +-/*)�� ����ؼ� ����� ��ȸ�� �� �ִ�
*/

--EMPLOYEE ���̺�κ��� ������, ����, ����(==����*12)
SELECT EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE;

--EMPLOYEE ���̺�κ��� ������, ����, ���ʽ�, ���ʽ��� ���Ե� ����(==(����+(����*���ʽ�)))
SELECT EMP_NAME, SALARY, BONUS, (SALARY+SALARY*BONUS)*12 FROM EMPLOYEE;
-->��� ���� ������ NULL ���� �����Ѵٸ� ��� ���� ��� ������ NULL�� ����!

--EMPLOYEE ���̺�κ��� ������, �Ի���, �ٹ��ϼ�(== ���ó�¥ - �Ի���)��ȸ
--DATE Ÿ�Գ����� ���� ���� ( DATE=>��, ��, ��, ��, ��, ��)
--���� ��¥ : SYSDATE
SELECT EMP_NAME, HIRE_DATE, Sysdate-HIRE_DATE FROM EMPLOYEE;
--������� �� �� ������ ����
--���� �������� ������ DATE Ÿ�Կ� ���ԵǾ� �ִ� ��/��/�ʿ� ���� ������� �����ϱ� ����

/*
    <�÷��� ��Ī �ο��ϱ�>
    [ǥ����]
    �÷��� AS ��Ī or �÷��� AS "��Ī" or �÷��� ��Ī or �÷��� "��Ī"
    AS�� ���̵� �Ⱥ��̵� ���� ��Ī�� Ư�����ڳ� ���Ⱑ ���Ե� ��� �ݵ�� ""�� ��� ǥ���ؾ� ��
*/

--EMPLOYEE ���̺�κ��� �̸�, �� �޿�, ���ʽ�, ���ʽ��� ���Ե� �� �ҵ��� ��ȸ
SELECT EMP_NAME AS �̸�, SALARY AS "�޿�(��)", BONUS AS ���ʽ�, (SALARY+(SALARY*BONUS))*12 AS "�� �ҵ�" FROM EMPLOYEE;

/*
    <���ͷ�>
    ���Ƿ� ������ ���ڿ�( ' ' ), ����, ��¥�� SELECT���� ����ϸ� ���� �� ���̺� �����ϴ� ������ó�� ResultSet���� ��ȸ�� �����ϴ�
*/

--EMPLOYEE ���̺�κ��� ���, �����, �޿�, ���� ��ȸ�ϱ�
SELECT EMP_ID AS ���, EMP_NAME AS �����, SALARY AS �޿�, '��' AS ���� FROM EMPLOYEE;
-->SELECT���� ������ ���ͷ� ���� ��ȸ����� ResultSet�� ��� �࿡ �ݺ������� ��µ�

/*
    <DISTINCT>
    ��ȸ�ϰ��� �ϴ� �÷��� �ߺ��� ���� �� �ѹ����� ��ȸ�ϰ� ���� �� ���
    [ǥ����]
    DISTINCT �÷���
    ��, SELECT ���� DISTINCT ������ �� �Ѱ��� �ۼ� �����ϴ�
*/

--EMPLOYEE ���̺�κ��� �μ��ڵ���� ��ȸ
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

--EMPLOYEE ���̺�κ��� �����ڵ���� ��ȸ
SELECT JOB_CODE FROM EMPLOYEE;

--DEPT_CODE, JOB_CODE �÷��� ���� ��Ʈ�� ��� �ߺ� �Ǻ�
SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;

/*
    <WHERE ��>
    ��ȸ�ϰ��� �ϴ� ���̺� Ư�� ������ �����ؼ� �� ���ǿ� �����ϴ� �����͸��� ��ȸ�ϰ��� �� �� ����ϴ� ����
    [ǥ����]
    SELECT �÷���1, �÷���2, ... FROM ���̺�� WHERE ���ǽ�;
    
    ������� : FROM�� -> WHERE��
    ���ǽĿ� �پ��� �����ڵ� ��� ����
    <�� ������>
    >, <, >=, <= (��� ��)
    = (��ġ�ϴ°�? : �����, �ڹٿ��� ����񱳴� ==����)
    !=, ^=, <> (��ġ���� �ʴ°�?)
*/

--EMPLOYEE ���̺�κ��� �޿��� 400���� �̻��� ������� ��� �÷��� ��ȸ
SELECT * FROM EMPLOYEE WHERE SALARY>=4000000;

--EMPLOYEE ���̺�κ��� �μ��ڵ尡 D9�� ������� �����, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D9';

--EMPLOYEE ���̺�κ��� �μ��ڵ尡 D9�� �ƴ� ������� �����, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE

--WHERE DEPT_CODE !='D9'; --23�� �� 20�� ��ȸ? (NULL�� �����ϰ� 18�� ��ȸ)
--WHERE DEPT_CODE ^='D9';
WHERE DEPT_CODE <> 'D9';

------- �ǽ� ���� --------
--1. EMPLOYEE ���̺�κ��� �޿��� 300���� �̻��� ������� �̸�, �޿�,�Ի��� ��ȸ
SELECT EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE WHERE SALARY>=3000000;
--2. EMPLOYEE ���̺�κ��� �����ڵ尡 J2�� ������� �̸�, �޿�, ���ʽ� ��ȸ
SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE WHERE JOB_CODE='J2';
--3. EMPLOYEE ���̺�κ��� ���� �������� ������� ���, �̸�, �Ի��� ��ȸ
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE ENT_YN='N';
--4. EMPLOYEE ���̺�κ��� ����(==�޿�*12)�� 5000���� �̻��� ������� �̸�, �޿�, ����, �Ի��� ��ȸ
SELECT EMP_NAME, SALARY, SALARY*12 AS ����, HIRE_DATE FROM EMPLOYEE WHERE SALARY*12>=50000000;

/*
    <�� ������>
    ���� ���� ������ ���� �� ���
    ~�̸鼭, �׸��� : AND (�ڹٿ�����&&)
    ~�̰ų�, �Ǵ� : OR (�ڹٿ����� | | )
*/

--EMPLOYEE ���̺�κ��� �μ��ڵ尡 'D9'�̸鼭 �޿��� 500���� �̻��� ������� �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D9' AND SALARY>=5000000;

--EMPLOYEE ���̺�κ��� �μ��ڵ尡 'D6'�̰ų� �޿��� 300���� �̻��� ������� �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D6' OR SALARY>=3000000;

--EMPLOYEE ���̺�κ��� �޿��� 350���� �̻��̰� 600���� ������ ������� �̸�, ���, �޿�, �����ڵ� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY>=3500000 AND SALARY <= 6000000;

/*
    <BETWEEN AND ������>
    �� �̻� �� ������ ������ ���� ������ ������ �� �ִ� ������
    [ǥ����]
    �񱳴���÷��� BETWEEN ���Ѱ� AND ���Ѱ�
    (�񱳴���÷��� ����ִ� ���� ���Ѱ� �̻� �׸��� ���Ѱ� ���ϸ� �����ϴ� ���)
*/

--EMPLOYEE ���̺�κ��� �޿��� 350���� �̻��̰� 600���� ������ ������� �̸�, ���, �޿�, �����ڵ� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY BETWEEN 3500000 AND 6000000;

--employee ���̺�κ��� �޿��� 350���� �̸��̰� 600���� �ʰ��� ������� �̸�, ���, �޿�, �����ڵ� ��ȸ
select emp_name, emp_id, salary, job_code 
from employee 
--where salary<3500000 or salary>6000000;
--where not salary between 3500000 and 6000000;
where salary not between 3500000 and 6000000;
-->����Ŭ���� not�� �ڹ��� �������������� !�� ������ �ǹ�

--between and �����ڴ� date ���İ������� ��� ����
--�Ի����� '90/01/01' ~ '03/01/01'�� ������� ��� �÷� ��ȸ
select * 
from employee 
--where hire_date>='90/01/01' and hire_date <= '03/01/01';
where hire_date between '90/01/01' and '03/01/01';
--��¥�� ��Һ񱳰� ������(���Ѱ�, ���Ѱ��� ������ �ִ�, between and �����ڸ� ��� �����ϴ�)

--employee ���̺�� ���� �Ի����� '90/01/01' ~ '03/01/01'�� �ƴ� ������� ��� �÷��� ��ȸ
select *
from employee
where hire_date not between '90/01/01' and '03/01/01';

/*
    <LIKE 'Ư�� ����'>
    ���Ϸ��� �÷����� ���� ������ Ư�� ���Ͽ� ������ ��� ��ȸ
    
    [ǥ����]
    �񱳴���÷��� LIKE 'Ư�� ����'
    
    -Ư�� ������ ������ �� ���ϵ�ī���� '%', '_'�� ������ ������ �� ����
    '%' : 0���� �̻�
    �񱳴���÷��� LIKE '����%' => �÷��� �߿� '����'�� ���۵Ǵ� ���� ��ȸ
    �񱳴���÷��� LIKE '%����' => �÷��� �߿� '����'�� ������ ���� ��ȸ
    �񱳴���÷��� LIKE '%����%' => �÷��� �߿� '����'�� ���ԵǴ� ���� ��ȸ
    
    '_' : �� 1����
    �񱳴���÷��� LIKE '_����' => �ش� �÷��� �߿� '����' �տ� ������ 1���ڰ� ���� ��� ��ȸ
    �񱳴���÷��� LIKE '__����' => �ش� �÷��� �߿� '����' �տ� ������ 2���ڰ� ���� ��� ��ȸ
*/
--employee ���̺�κ��� ���� ������ ������� �̸�, �޿�, �Ի��� ��ȸ
select emp_name, salary, hire_date from employee where emp_name like '��%';

--employee ���̺�κ��� �̸� �߿� '��'�� ���Ե� ������� �̸�, �ֹι�ȣ, �μ��ڵ� ��ȸ
select emp_name, emp_no, dept_code from employee where emp_name like '%��%';

--employee ���̺�κ��� ��ȭ��ȣ 4�� ° �ڸ��� 9�� ���۵Ǵ� ������� ���,�����, ��ȭ��ȣ, �̸��� ��ȸ
select emp_id, emp_name, phone, email from employee where phone like '___9%';

--employee ���̺�κ��� �̸� ������ڰ� '��'�� ������� ��� �÷�(�̸��� 3������ ���)
select * from employee where emp_name like '_��_';

--�� �̿��� ���
select * from employee where emp_name not like '_��_';

--�ǽ�����--
--1. �̸��� '��'���� ������ ������� �̸�, �Ի��� ��ȸ
select emp_name, hire_date from employee where emp_name like '%��';
--2. ��ȭ��ȣ ó�� 3���ڰ� 010�� �ƴ� ������� �̸�, ��ȭ��ȣ ��ȸ
select emp_name, phone from employee where phone not like '010%';
--3. department ���̺�κ��� �ؿܿ����� ���õ� �μ����� ��� �÷����� ��ȸ
select * from department where dept_title like '%�ؿܿ���%';

/*
    <IS NULL>
    NULL���� �ƴ��� �Ǻ�
    [ǥ����]
    �񱳴���÷� IS NULL : �÷����� NULL�� ��츦 ��ȸ�ϰڴ�
    �񱳴���÷� IS NOT NULL : �÷����� NULL�� �ƴ� ��츦 ��ȸ�ϰڴ�
    
    ���ǻ���: ����Ŭ���� NULL���� ������Ҷ��� =�� ���� �ʰ� IS NULL�� ����
*/

-- ���ʽ��� ���� �ʴ� ������� ���, �̸�, �޿�, ���ʽ� ��ȸ
select emp_id, emp_name, salary, bonus from employee where bonus is null;

--���ʽ��� �޴� ������� ���, �̸�, �޿�, ���ʽ�
select emp_id, emp_name, salary, bonus from employee where bonus is not null;

--����� ���� ������� �����, ������, �μ��ڵ� ��ȸ
select emp_name, manager_id, dept_code from employee where manager_id is null;

--����� ���� �μ���ġ�� ���� ���� ������� ��� �÷��� ��ȸ
select * from employee where manager_id is null and dept_code is null;

--��ó ��ġ�� ���� �ʾ����� ���ʽ��� �޴� ������� �����, �μ��ڵ�, ���ʽ� ��ȸ
select emp_name, dept_code, bonus from employee where dept_code is null and bonus is not null;

/*
    <IN>
    �� ��� �÷� ���� ���� ������ ��ϵ� �߿��� ��ġ�ϴ� ���� �ϳ��� �ִ��� üũ
    [ǥ����]
    �񱳴���÷� IN (��, ��, ��, ...)
*/

--�μ��ڵ尡 D6�̰ų� �Ǵ� D8�̰ų� �Ǵ� D5�� ������� �̸�, �μ��ڵ�, �޿� ��ȸ
select emp_name, dept_code, salary 
from employee 
--where dept_code='D6' or dept_code='D8' or dept_code='D5';
where dept_code in ('D6','D8','D5');

--�� �̿��� �����
select emp_name, dept_code, salary from employee where dept_code not in ('D6','D8','D5');

/*
    <���� ������>
    ���� �÷����� ��ġ �ϳ��� �÷��ε� ��������ִ� ������
    �÷��� ���ͷ�( ������ ���ڿ�)�� ������ �� ����
    
    �ڹٿ��� 
    ���ڿ�+���ڿ�=������ ���ڿ�
    ���ڿ�+����=������ ���ڿ�
*/

select emp_id || emp_name || salary as "�����" from employee;

--XX�� XXX�� ������ XXXX�� �Դϴ�. �������� ���
select emp_id || '�� ' || emp_name ||'�� ������ '|| salary || '�� �Դϴ�' as "�޿�����" from employee;

/*
    <������ �켱����>
    0. ( ) : �켱������ �����ִ� ����
    1. ��������� : ���� ��������� ����
    2. ���Ῥ���� : �÷��� ���ͷ��� �Ǵ� �÷��� �÷����� ��������
    3. �񱳿����� : ��Һ� �Ǵ� �����
    { 4. IS NULL, IS NOT NULL : NULL ������ �ƴ��� �Ǵ�����
    5. LIKE : ������ �����ؼ� ���Ͽ� �����ϴ��� �Ǻ�
    6. IN : ������ ��� �� �ϳ��� ��ġ�ϴ°� �ִ��� �Ǻ� ( �����+OR ���� )
    7. BETWEEN AND : Ư�� ������ �ش�Ǵ��� üũ (���Ѱ� <= �񱳴�� <= ���Ѱ�) }=> 4,5,6�� ���� �켱����
    8. NOT : ������ ������Ű�� ����
    9. AND : ������ "�׸���"��� Ű����� ����
    10. OR : ������ "�Ǵ�"�̶�� Ű����� ����
*/

/*
    <ORDER BY ��>
    SELECT �� ���� �������� �����ϴ� ���� �Ӹ� �ƴ϶� ���� ���� ���� ���� ������
   ��ȸ�� �����͵��� �������ִ� ���� (������������ ������������ / ������ �������� ������ ����)
   
   [ǥ����]
   SELECT  ��ȸ���÷���1, �÷���2, ... 
   FROM ���̺��
   WHERE ���ǽ�
   ORDER BY [���ı������μ�������ϴ��÷���/��Ī/�÷�����] [ASC(��������)/DESC(��������)];
   
   =>WHERE��, ORDER BY ���� ���� ����
*/
=======
/*
    <SELECT>
    �����͸� ��ȸ�ϰų� �˻��� �� ����ϴ� ��ɾ�
    ResultSet : SELECT ������ ���� ��ȸ�� �����͵��� ������� �ǹ� ��, ��ȸ�� ����� ����
    [ǥ����]
    SELECT ��ȸ�ϰ����ϴ��÷���1, �÷���2, �÷���3, ...
    FROM ���̺��;
*/

-- EMPLOYEE ���̺��� ��ü ������� ���, �̸�, �޿� �÷����� ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE;

--��ɾ�, Ű����, ���̺��, �÷��� ���� ��ҹ��ڸ� ������ ����
--�ҹ��ڷ� �ᵵ ����

--EMPLOYEE ���̺��� ��ü ������� ��� �÷��� ��ȸ
SELECT * FROM EMPLOYEE;

--JOB ���̺��� ��� �÷��� ��ȸ
SELECT * FROM JOB;

--JOB ���̺��� ���޸� �÷��� ��ȸ
SELECT JOB_NAME FROM JOB;

-------�ǽ� ����-------
--1. DEPARTMENT ���̺��� ��� �÷� ��ȸ
SELECT * FROM DEPARTMENT;
--2. EMPLOYEE ���̺��� ������, �̸���, ��ȭ��ȣ, �Ի��� �÷��� ��ȸ
SELECT EMP_ID, EMAIL, PHONE, HIRE_DATE FROM EMPLOYEE;
--3. EMPLOYEE ���̺��� �Ի���, ������, �޿� �÷��� ��ȸ
SELECT HIRE_DATE, EMP_NAME, SALARY FROM EMPLOYEE;

/*
    <�÷����� ���� �������>
    ��ȸ�ϰ��� �ϴ� �÷����� �����ϴ� SELECT ���� �������( +-/*)�� ����ؼ� ����� ��ȸ�� �� �ִ�
*/

--EMPLOYEE ���̺�κ��� ������, ����, ����(==����*12)
SELECT EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE;

--EMPLOYEE ���̺�κ��� ������, ����, ���ʽ�, ���ʽ��� ���Ե� ����(==(����+(����*���ʽ�)))
SELECT EMP_NAME, SALARY, BONUS, (SALARY+SALARY*BONUS)*12 FROM EMPLOYEE;
-->��� ���� ������ NULL ���� �����Ѵٸ� ��� ���� ��� ������ NULL�� ����!

--EMPLOYEE ���̺�κ��� ������, �Ի���, �ٹ��ϼ�(== ���ó�¥ - �Ի���)��ȸ
--DATE Ÿ�Գ����� ���� ���� ( DATE=>��, ��, ��, ��, ��, ��)
--���� ��¥ : SYSDATE
SELECT EMP_NAME, HIRE_DATE, Sysdate-HIRE_DATE FROM EMPLOYEE;
--������� �� �� ������ ����
--���� �������� ������ DATE Ÿ�Կ� ���ԵǾ� �ִ� ��/��/�ʿ� ���� ������� �����ϱ� ����

/*
    <�÷��� ��Ī �ο��ϱ�>
    
    [ǥ����]
    �÷��� AS ��Ī or �÷��� AS "��Ī" or �÷��� ��Ī or �÷��� "��Ī"
    AS�� ���̵� �Ⱥ��̵� ���� ��Ī�� Ư�����ڳ� ���Ⱑ ���Ե� ��� �ݵ�� ""�� ��� ǥ���ؾ� ��
*/

--EMPLOYEE ���̺�κ��� �̸�, �� �޿�, ���ʽ�, ���ʽ��� ���Ե� �� �ҵ��� ��ȸ
SELECT EMP_NAME AS �̸�, SALARY AS "�޿�(��)", BONUS AS ���ʽ�, (SALARY+(SALARY*BONUS))*12 AS "�� �ҵ�" FROM EMPLOYEE;

/*
    <���ͷ�>
    ���Ƿ� ������ ���ڿ�( ' ' ), ����, ��¥�� SELECT���� ����ϸ� ���� �� ���̺� �����ϴ� ������ó�� ResultSet���� ��ȸ�� �����ϴ�
*/

--EMPLOYEE ���̺�κ��� ���, �����, �޿�, ���� ��ȸ�ϱ�
SELECT EMP_ID AS ���, EMP_NAME AS �����, SALARY AS �޿�, '��' AS ���� FROM EMPLOYEE;
-->SELECT���� ������ ���ͷ� ���� ��ȸ����� ResultSet�� ��� �࿡ �ݺ������� ��µ�

/*
    <DISTINCT>
    ��ȸ�ϰ��� �ϴ� �÷��� �ߺ��� ���� �� �ѹ����� ��ȸ�ϰ� ���� �� ���
    [ǥ����]
    DISTINCT �÷���
    ��, SELECT ���� DISTINCT ������ �� �Ѱ��� �ۼ� �����ϴ�
*/

--EMPLOYEE ���̺�κ��� �μ��ڵ���� ��ȸ
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

--EMPLOYEE ���̺�κ��� �����ڵ���� ��ȸ
SELECT JOB_CODE FROM EMPLOYEE;

--DEPT_CODE, JOB_CODE �÷��� ���� ��Ʈ�� ��� �ߺ� �Ǻ�
SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;

/*
    <WHERE ��>
    ��ȸ�ϰ��� �ϴ� ���̺� Ư�� ������ �����ؼ� �� ���ǿ� �����ϴ� �����͸��� ��ȸ�ϰ��� �� �� ����ϴ� ����
    [ǥ����]
    SELECT �÷���1, �÷���2, ... FROM ���̺�� WHERE ���ǽ�;
    
    ������� : FROM�� -> WHERE��
    ���ǽĿ� �پ��� �����ڵ� ��� ����
    <�� ������>
    >, <, >=, <= (��� ��)
    = (��ġ�ϴ°�? : �����, �ڹٿ��� ����񱳴� ==����)
    !=, ^=, <> (��ġ���� �ʴ°�?)
*/

--EMPLOYEE ���̺�κ��� �޿��� 400���� �̻��� ������� ��� �÷��� ��ȸ
SELECT * FROM EMPLOYEE WHERE SALARY>=4000000;

--EMPLOYEE ���̺�κ��� �μ��ڵ尡 D9�� ������� �����, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D9';

--EMPLOYEE ���̺�κ��� �μ��ڵ尡 D9�� �ƴ� ������� �����, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE

--WHERE DEPT_CODE !='D9'; --23�� �� 20�� ��ȸ? (NULL�� �����ϰ� 18�� ��ȸ)
--WHERE DEPT_CODE ^='D9';
WHERE DEPT_CODE <> 'D9';

------- �ǽ� ���� --------
--1. EMPLOYEE ���̺�κ��� �޿��� 300���� �̻��� ������� �̸�, �޿�,�Ի��� ��ȸ
SELECT EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE WHERE SALARY>=3000000;
--2. EMPLOYEE ���̺�κ��� �����ڵ尡 J2�� ������� �̸�, �޿�, ���ʽ� ��ȸ
SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE WHERE JOB_CODE='J2';
--3. EMPLOYEE ���̺�κ��� ���� �������� ������� ���, �̸�, �Ի��� ��ȸ
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE ENT_YN='N';
--4. EMPLOYEE ���̺�κ��� ����(==�޿�*12)�� 5000���� �̻��� ������� �̸�, �޿�, ����, �Ի��� ��ȸ
SELECT EMP_NAME, SALARY, SALARY*12 AS ����, HIRE_DATE FROM EMPLOYEE WHERE SALARY*12>=50000000;

/*
    <�� ������>
    ���� ���� ������ ���� �� ���
    ~�̸鼭, �׸��� : AND (�ڹٿ�����&&)
    ~�̰ų�, �Ǵ� : OR (�ڹٿ����� | | )
*/

--EMPLOYEE ���̺�κ��� �μ��ڵ尡 'D9'�̸鼭 �޿��� 500���� �̻��� ������� �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D9' AND SALARY>=5000000;

--EMPLOYEE ���̺�κ��� �μ��ڵ尡 'D6'�̰ų� �޿��� 300���� �̻��� ������� �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE='D6' OR SALARY>=3000000;

--EMPLOYEE ���̺�κ��� �޿��� 350���� �̻��̰� 600���� ������ ������� �̸�, ���, �޿�, �����ڵ� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY>=3500000 AND SALARY <= 6000000;

/*
    <BETWEEN AND ������>
    �� �̻� �� ������ ������ ���� ������ ������ �� �ִ� ������
    [ǥ����]
    �񱳴���÷��� BETWEEN ���Ѱ� AND ���Ѱ�
    (�񱳴���÷��� ����ִ� ���� ���Ѱ� �̻� �׸��� ���Ѱ� ���ϸ� �����ϴ� ���)
*/

--EMPLOYEE ���̺�κ��� �޿��� 350���� �̻��̰� 600���� ������ ������� �̸�, ���, �޿�, �����ڵ� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY BETWEEN 3500000 AND 6000000;

-- EMPLOYEE ���̺�κ��� �޿��� 350���� �̸��̰ų� 600���� �ʰ��� ������� �̸�, ���, �޿�, �����ڵ� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE
FROM EMPLOYEE
-- WHERE SALARY < 3500000 OR 6000000 < SALARY;
-- WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
WHERE SALARY NOT BETWEEN 3500000 AND 6000000;
--> ����Ŭ���� NOT �� �ڹ��� �������������� ! �� ������ �ǹ�

-- ** BETWEEN AND �����ڴ� DATE ���İ������� ��� ����
-- �Ի����� '90/01/01' ~ '03/01/01' �� ������� ��� �÷� ��ȸ
SELECT *
FROM EMPLOYEE
-- WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '03/01/01';
-- ��¥�� ��Һ񱳰� ������ (== ���Ѱ�, ���Ѱ��� ������ �ִ�, BETWEEN AND �����ڸ� ��� �����ϴ�)
WHERE HIRE_DATE BETWEEN '90/01/01' AND '03/01/01';

-- EMPLOYEE ���̺�κ��� �Ի����� '90/01/01' ~ '03/01/01' �� �ƴ� ������� ��� �÷� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE NOT BETWEEN '90/01/01' AND '03/01/01';

-------------------------------------------------------------------------------------------------

/*
    < LIKE 'Ư�� ����' >
    ���Ϸ��� �÷����� ���� ������ Ư�� ���Ͽ� ������ ��� ��ȸ
    
    [ ǥ���� ]
    �񱳴���÷��� LIKE 'Ư�� ����'
    
    - Ư�� ������ �����Ҷ� ���ϵ�ī���� '%', '_' �� ������ ������ �� ����
    '%' : 0���� �̻�
    �񱳴���÷��� LIKE '����%' => �÷��� �߿� '����'�� ���۵Ǵ°��� ��ȸ
    �񱳴���÷��� LIKE '%����' => �÷��� �߿� '����'�� �����°��� ��ȸ
    �񱳴���÷��� LIKE '%����%' => �÷��� �߿� '����'�� ���ԵǴ°��� ��ȸ
    
    '_' : �� 1����
    �񱳴���÷��� LIKE '_����' => �ش� �÷��� �߿� '����' �տ� ������ 1���ڰ� ���� ��� ��ȸ
    �񱳴���÷��� LIKE '__����' => �ش� �÷��� �߿� '����' �տ� ������ 2���ڰ� ���� ��� ��ȸ
*/

-- EMPLOYEE ���̺�κ��� ���� ������ ������� �̸�, �޿�, �Ի��� ��ȸ
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '��%';

-- EMPLOYEE ���̺�κ��� �̸� �߿� '��' �� ���Ե� ������� �̸�, �ֹι�ȣ, �μ��ڵ� ��ȸ
SELECT EMP_NAME, EMP_NO, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��%';

-- EMPLOYEE ���̺�κ��� ��ȭ��ȣ 4��° �ڸ��� 9�� ���۵Ǵ� ������� ���, �����, ��ȭ��ȣ, �̸��� ��ȸ
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

-- EMPLOYEE ���̺�κ��� �̸� ������ڰ� '��' �� ������� ��� �÷� (�̸��� 3������ ���)
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_��_';

-- �� �̿��� ���
SELECT *
FROM EMPLOYEE
-- WHERE NOT EMP_NAME LIKE '_��_';
WHERE EMP_NAME NOT LIKE '_��_';

------- �ǽ����� -------
-- 1. �̸��� '��' ���� ������ ������� �̸�, �Ի��� ��ȸ
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
-- WHERE EMP_NAME LIKE '%��';
WHERE EMP_NAME LIKE '__��';
-- �̸��� ��� 3���ڶ�� �����Ͽ� ����ٵ� ��밡��

-- 2. ��ȭ��ȣ ó�� 3���ڰ� 010 �� �ƴ� ������� �̸�, ��ȭ��ȣ�� ��ȸ
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

-- 3. DEPARTMENT ���̺�κ��� �ؿܿ����� ���õ� �μ����� ��� �÷����� ��ȸ
SELECT *
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '%�ؿܿ���%';

------------------------------------------------------------------------------------------

/*
    < IS NULL >
    NULL ���� �ƴ��� �Ǻ�
    
    [ ǥ���� ]
    �񱳴���÷� IS NULL : �÷����� NULL �� ��츦 ��ȸ�ϰڴ�.
    �񱳴���÷� IS NOT NULL : �÷����� NULL �� �ƴ� ��츦 ��ȸ�ϰڴ�.
    
    ���ǻ��� : ����Ŭ���� NULL ���� ������Ҷ����� = �� ���� �ʰ� IS NULL �� ����!
*/

SELECT *
FROM EMPLOYEE;

-- ���ʽ��� ���� �ʴ� ������� ���, �̸�, �޿�, ���ʽ�
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

-- ���ʽ��� �޴� ������� ���, �̸�, �޿�, ���ʽ�
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- ����� ���� ������� �����, ������, �μ��ڵ� ��ȸ
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- ����� ���� �μ���ġ�� ���� ���� ������� ��� �÷��� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- �μ���ġ�� ���� �ʾ����� ���ʽ��� �޴� ������� �����, �μ��ڵ�, ���ʽ� ��ȸ
SELECT EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

----------------------------------------------------------------------------------------

/*
    < IN >
    �� ��� �÷� ���� ���� ������ ��ϵ� �߿��� ��ġ�ϴ°��� �ϳ��� �ִ��� üũ
    
    [ ǥ���� ]
    �񱳴���÷� IN (��1, ��2, ��3, ..)
*/

-- �μ��ڵ尡 D6 �̰ų� �Ǵ� D8 �̰ų� �Ǵ� D5 �� ������� �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D5';
WHERE DEPT_CODE IN ('D6', 'D8', 'D5');

-- �� �̿��� �����
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D6', 'D8', 'D5');

----------------------------------------------------------------------------------------

/*
    < ���� ������ || >
    ���� �÷����� ��ġ �ϳ��� �÷��� �� ��������ִ� ������
    �÷��� ���ͷ� (������ ���ڿ�) �� ������ �� ����
    
    �ڹٿ��� 
    ���ڿ� + ���ڿ� = ������ ���ڿ�
    ���ڿ� + ���� = ������ ���ڿ�
*/

SELECT EMP_ID || EMP_NAME || SALARY AS "�����"
FROM EMPLOYEE;

-- XX�� XXX�� ������ XXXX�� �Դϴ�. �������� ���
SELECT EMP_ID || '�� ' || EMP_NAME || '�� ������ ' || SALARY || '�� �Դϴ�.' AS "�޿�����"
FROM EMPLOYEE;

/*
    < ������ �켱���� >
    0. () : �켱������ �����ִ� ����
    1. ��������� : ���� ��������� ����
    2. ���Ῥ���� : �÷��� ���ͷ��� �Ǵ� �÷��� �÷����� ��������
    3. �񱳿����� : ��Һ� �Ǵ� ����񱳸� ����
    { 4. IS NULL, IS NOT NULL : NULL ������ �ƴ��� �Ǵ�����
    5. LIKE : ������ �����ؼ� ���Ͽ� �����ϴ��� �Ǻ�
    6. IN : ������ ����� �ϳ��� ��ġ�ϴ°� �ִ��� �Ǻ� (����� + OR ����) } => 4, 5, 6 �� ���� �켱�����̴�.
    7. BETWEEN AND : Ư�� ������ �ش�Ǵ��� üũ (���Ѱ� <= �񱳴�� <= ���Ѱ�)
    8. NOT : ������ ������Ű�� ����
    9. AND : ������ "�׸���" ��� Ű����� ����
    10. OR : ������ "�Ǵ�" �̶�� Ű����� ����
*/

--------------------------------------------------------------------------------------------

/*
    < ORDER BY �� >
    SELECT �� ���� �������� �����ϴ� ���� �Ӹ� �ƴ϶� ���� ���� ���� ���� ������
    ��ȸ�� �����͵��� �������ִ� ���� (������������ ������������ / ������ �������� �����Ұ���)
    
    [ ǥ���� ]
    SELECT ��ȸ���÷���1, �÷���2, ...
    FROM ���̺��
    WHERE ���ǽ�
    ORDER BY [���ı������μ�������ϴ��÷���/��Ī/�÷�����] [ASC/DESC] ~~~~;
    
    => WHERE��, ORDER BY ���� ���� ����
*/




