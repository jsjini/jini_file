SET SERVEROUTPUT ON

-- 커서 FOR LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE employee_id = 0;
BEGIN
    FOR emp_record IN emp_cursor LOOP -- 암시적으로 OPEN; 발생
        DBMS_OUTPUT.PUT('NO. : ' || emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(', 사원번호 : ' || emp_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(', 사원이름 : ' || emp_record.last_name);
    END LOOP; -- 암시적으로 CLOSE; 발생
--    DBMS_OUTPUT.PUT_LINE('Total : ' || emp_cursor%ROWCOUNT);
    
    FOR dept_info IN (SELECT * 
                      FROM departments) LOOP
        DBMS_OUTPUT.PUT(', 부서번호 : ' || dept_info.department_id);
        DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || dept_info.department_name);                     
    END LOOP;
END;
/


-- 1) 모든 사원의 사원번호, 이름, 부서이름 출력
BEGIN
    FOR emp_info IN (SELECT e.employee_id, e.last_name, d.department_name
                    FROM employees e LEFT OUTER JOIN departments d
                    ON e.department_id = d.department_id) LOOP
        DBMS_OUTPUT.PUT('사원번호 : ' || emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_info.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE('부서이름 : ' || emp_info.department_name);
END LOOP;
END;
/

-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
BEGIN
    FOR emp_info IN (SELECT last_name, salary, commission_pct
                    FROM employees
                    WHERE department_id IN (50, 80)) LOOP
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_info.last_name || ', ');
        DBMS_OUTPUT.PUT('급여 : ' || emp_info.salary || ', ');
        DBMS_OUTPUT.PUT('연봉 : ');
        DBMS_OUTPUT.PUT_LINE(emp_info.salary*12 + NVL(emp_info.salary,0)*NVL(emp_info.commission_pct,0)*12);
    END LOOP;
END;
/

DECLARE
    CURSOR emp_cursor IS
        SELECT e.employee_id, e.last_name, d.department_name
        FROM employees e LEFT OUTER JOIN departments d
        ON e.department_id = d.department_id;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('사원번호 : ' || emp_record.employee_id || ', ');
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_record.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE('부서이름 : ' || emp_record.department_name);
    END LOOP;
END;
/

DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id IN (50, 80);
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_record.last_name || ', ');
        DBMS_OUTPUT.PUT('급여 : ' || emp_record.salary || ', ');
        DBMS_OUTPUT.PUT('연봉 : ');
        DBMS_OUTPUT.PUT_LINE(emp_record.salary*12 + NVL(emp_record.salary,0)*NVL(emp_record.commission_pct,0)*12);
    END LOOP;
END;
/


-- 매개변수
DECLARE
    CURSOR emp_cursor
        ( p_mgr employees.manager_id%TYPE ) IS
            SELECT *
            FROM employees
            WHERE manager_id = p_mgr;
            
    v_emp_info emp_cursor%ROWTYPE;
BEGIN
    -- 기본
    OPEN emp_cursor(100);
    
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_emp_info.last_name);
    END LOOP;
    
    CLOSE emp_cursor;
    
    -- 커서 FOR LOOP
    DBMS_OUTPUT.PUT_LINE('==');
    FOR emp_info IN emp_cursor(149) LOOP
        DBMS_OUTPUT.PUT('사원번호 : ' || emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE('사원이름 : ' || emp_info.last_name);
    END LOOP;
    
END;
/


-- 1. 사원(employees) 테이블에서
-- 사원의 사원번호, 사원이름, 입사연도를
-- 다음 기준에 맞게 각각 test01, test02에 입력하시오.
-- 입사연도가 2015년(포함) 이전 입사한 사원은 test01 테이블에 입력
-- 입사연도가 2015년 이후 입사한 사원은 test02 테이블에 입력

CREATE TABLE test01
AS
    SELECT employee_id, last_name, hire_date
    FROM employees
    WHERE employee_id = 0;
    
CREATE TABLE test02
AS
    SELECT employee_id, last_name, hire_date
    FROM employees
    WHERE employee_id = 0;
    
SELECT employee_id, last_name, hire_date
FROM employees
WHERE hire_date >= '2015/1/1';


DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
    v_emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND; 
        
        IF v_emp_info.hire_date >= '2015/1/1' THEN -- TO_CHAR(v_emp_info.hire_date, 'yyyy') <= '2015'
            INSERT INTO test01 (employee_id, last_name, hire_date)
            VALUES (v_emp_info.employee_id, v_emp_info.last_name ,v_emp_info.hire_date);
        ELSE 
            INSERT INTO test02
            VALUES v_emp_info;
        END IF;
    END LOOP;
    
    CLOSE emp_cursor;
END;
/

-- 커서 FOR LOOP 사용시. 
--    FOR emp_record IN emp_cursor LOOP
--        IF TO_CHAR(v_emp_info.hire_date, 'yyyy') <= '2015' THEN
--                        INSERT INTO test01 (employee_id, last_name, hire_date)
--            VALUES (v_emp_info.employee_id, v_emp_info.last_name ,v_emp_info.hire_date);
--        ELSE 
--            INSERT INTO test02
--            VALUES v_emp_info;
--        END IF;
--    END LOOP;

SELECT *
FROM test01;
SELECT *
FROM test02;

-- 2. 부서번호를 입력할 경우 (&치환변수 사용)
-- 해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
-- (단, CURSOR 사용)

SELECT e.last_name, e.hire_date, d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_id = &부서번호;

DECLARE
    CURSOR emp_dept_cursor IS
        SELECT  e.last_name, 
                e.hire_date, 
                d.department_name
        FROM    employees e 
                JOIN departments d
                ON   e.department_id = d.department_id
        WHERE   d.department_id = &부서번호;
        
    emp_record emp_dept_cursor%ROWTYPE;
BEGIN
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO emp_record;
        EXIT WHEN emp_dept_cursor%NOTFOUND; 
        
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_record.last_name);
        DBMS_OUTPUT.PUT(', 입사일자 : ' || emp_record.hire_date);
        DBMS_OUTPUT.PUT_LINE(', 부서명 : ' || emp_record.department_name);
    END LOOP;
    
    CLOSE emp_dept_cursor;

END;
/

DECLARE
    CURSOR dept_cursor IS
        SELECT *
        FROM departments;

    CURSOR emp_dept_cursor 
        (p_dept_id departments.department_id%TYPE) IS
        SELECT  e.last_name, 
                e.hire_date, 
                d.department_name
        FROM    employees e 
                JOIN departments d
                ON   e.department_id = d.department_id
        WHERE   d.department_id = p_dept_id;
      
    emp_record emp_dept_cursor%ROWTYPE;
BEGIN
    FOR dept_info IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('==== 현재 부서 정보 : ' || dept_info.department_name);
    
        OPEN emp_dept_cursor(dept_info.department_id);
        
        LOOP
            FETCH emp_dept_cursor INTO emp_record;
            EXIT WHEN emp_dept_cursor%NOTFOUND; 
            
            DBMS_OUTPUT.PUT('사원이름 : ' || emp_record.last_name);
            DBMS_OUTPUT.PUT(', 입사일자 : ' || emp_record.hire_date);
            DBMS_OUTPUT.PUT_LINE(', 부서명 : ' || emp_record.department_name);
        END LOOP;
        
        IF emp_dept_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('현재 소속된 사원이 없습니다.');
        END IF;
        
        CLOSE emp_dept_cursor;
    
    END LOOP;
END;
/


-- 예외처리
-- 1) Oracle이 관리하고 있고 이름이 존재하는 경우
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;

    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 여러 명의 사원이 존재합니다.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 에러가 발생했습니다.');
        
    DBMS_OUTPUT.PUT_LINE('EXCEPTION 절이 실행되었습니다.'); -- 마지막에 있는 절은 END 전까지 출력
END;
/

-- 2) Oracle이 관리하고 있고 이름이 존재하지 않는 경우
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('다른 테이블에서 사용하고 있습니다.');
END;
/

-- 3) 사용자가 정의하는 예외사항
DECLARE
    e_emp_del_fail EXCEPTION;
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_del_fail;
    END IF;
EXCEPTION
    WHEN e_emp_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
END;
/


-- 예외 트랩 함수
DECLARE
    e_too_many EXCEPTION;
    
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
    emp_info employees%ROWTYPE;
BEGIN
    SELECT *
    INTO emp_info
    FROM employees
    WHERE department_id = &부서번호;
    
    IF emp_info.salary < (emp_info.salary * emp_info.commission_pct + 10000) THEN
        RAISE e_too_many;
    END IF;
EXCEPTION
    WHEN e_too_many THEN
        DBMS_OUTPUT.PUT_LINE('사용자 정의 예외 발생!');
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('ORA ' || v_ex_code);
        DBMS_OUTPUT.PUT_LINE(' - ' || v_ex_msg);
END;
/

-- 1) test_employees 테이블을 사용하여 선택된 사원을 삭제하는 PL/SQL 작성
-- 조건1) 치환변수 사용
-- 조건2) 사원이 존재하지 않는 경우 '해당사원이 존재하지 않습니다.'라는 메세지를 출력
-- => 사용자 정의 예외
DECLARE
    e_emp EXCEPTION;
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp;
    END IF;
EXCEPTION
    WHEN e_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 존재하지 않습니다.');
END;
/


-- PROCEDURE - PROCEDURE와 FUNCTION은 DECLARE가 보이지만 않을뿐 IS와 BEGIN 사이에 존재함.
-- PROCEDURE 안에서는 치환변수 사용금지.
-- 내용 수정할려면 드랍 후 다시 크리에이트 해야함.
CREATE PROCEDURE test_pro
IS
-- 선언부 : 내부에서 사용하는 변수, 커서, 타입, 예외
    v_msg VARCHAR2(1000) := 'Execute Procedure';
BEGIN
    DELETE FROM test_employees
    WHERE department_id = 50;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
EXCEPTION
    WHEN INVALID_CURSOR THEN
        DBMS_OUTPUT.PUT_LINE('사용할 수 없는 커서입니다.');
END;
/

-- 프로시저 실행1
-- 프로시저를 사용할 때는 변수를 사용해서는 안된다.
DECLARE
    v_num NUMBER(1,0);
BEGIN
--  v_num := test_pro; -- 변수사용하면 함수로 인식함.
    test_pro; 
END;
/

-- 프로시저 실행2
-- 프로시저 단축명령어
EXECUTE test_pro;

-- 프로시저는 반드시 PL/SQL 안에서만 실행해야 함.

DROP PROCEDURE raise_salary;

-- IN : PROCEDURE 내부에서 상수로 인식
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS

BEGIN
--    p_eid := 100;  - 컴파일에서 거부함.
    
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_first NUMBER(3,0) := 100;
    v_second CONSTANT NUMBER(3,0) := 149;
BEGIN
    raise_salary(103);
    raise_salary(120 + 10);
    raise_salary(v_second);    
    raise_salary(v_first);    
END;
/

SELECT employee_id, salary
FROM employees;


-- OUT : PROCEDURE 내부에서 초기화되지 않은 변수로 NULL로 인식
CREATE PROCEDURE test_p_out
(p_num IN NUMBER,
 p_result OUT NUMBER)
IS
    v_sum NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_result);
    
--    p_result := 10;
    v_sum := p_num + p_result;
    p_result := v_sum;
END;
/

DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) result : ' || v_result);
    test_p_out(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('2) result : ' || v_result);
END;
/

DROP PROCEDURE select_emp;
CREATE PROCEDURE select_emp
(p_eid IN employees.employee_id%TYPE,
 p_ename OUT employees.last_name%TYPE,
 p_sal OUT employees.salary%TYPE,
 p_comm OUT employees.commission_pct%TYPE)
IS

BEGIN
    SELECT last_name, salary, NVL(commission_pct,0)
    INTO p_ename, p_sal, p_comm
    FROM employees
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_name VARCHAR2(100 char);
    v_sal NUMBER;
    v_comm NUMBER;
    
    v_eid NUMBER := &사원번호;
BEGIN
    select_emp(v_eid, v_name, v_sal, v_comm);
    
    DBMS_OUTPUT.PUT('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT(', 급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE(', 커미션 : ' || v_comm);
END;
/

-- IN OUT : 넘기는 데이터가 보존이 안되고 덮어씌어짐. 보존이 필요하면 IN / OUT 같이 써야함.
-- '01012341234' => '010-1234-1234'
CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)
IS

BEGIN
    p_phone_no := SUBSTR(p_phone_no, 1, 3) -- 1번째를 기준으로해서 3글자 짜르겠다.
                 || '-' || SUBSTR(p_phone_no, 4, 4) -- 4번째를 기준으로해서 4글자 짜르겠다.
                 || '-' || SUBSTR(p_phone_no, 8); -- 8번째를 기준으로해서 마지막까지
END;
/

DECLARE
    v_ph_no VARCHAR2(100) := '01012341234';
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) ' || v_ph_no);
    format_phone(v_ph_no);
    DBMS_OUTPUT.PUT_LINE('2) ' || v_ph_no);
END;
/
--SUBSTR(p_phone_no, 1, 3) 
--    || '-' || SUBSTR(p_phone_no, 4, 4) 
--    || '-' || SUBSTR(p_phone_no, 8); 


-- 테이블 포맷처리 예제 - 시험문제는 아님.
CREATE TABLE var_pk_tbl
(
    no VARCHAR2(1000) PRIMARY KEY,
    name VARCHAR2(4000) DEFAULT 'anony'
);

SELECT no, name
FROM var_pk_tbl;
'TEMP240216001' -- TEMP + yyMMdd + 숫자(3자리)

SELECT TO_CHAR(SYSDATE, 'yyMMdd')
FROM DUAL;

-- LPAD : 공백처리
-- NVL : 널처리
SELECT 'TEMP' || TO_CHAR(SYSDATE, 'yyMMdd') || LPAD(NVL(MAX(SUBSTR(no, -3)),0) + 1, 3,'0')
FROM var_pk_tbl
WHERE SUBSTR(no, 5, 6) = TO_CHAR(SYSDATE, 'yyMMdd');

SELECT NVL(MAX(employee_id),0) + 1
FROM employees;

-- 1. 주민등록번호를 입력하면
-- 다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju(9501011667777);
EXECUTE yedam_ju(1511013689977);

DROP PROCEDURE yedam_ju;
-- -> 950101-1******
CREATE PROCEDURE yedam_ju
(p_number IN VARCHAR2)
IS
    v_result VARCHAR2(100);
BEGIN
--    v_result := SUBSTR(p_number, 1, 6) || '-' || SUBSTR(p_number, 7, 1) || '******';
    v_result := SUBSTR(p_number, 1, 6) || '-' || RPAD(SUBSTR(p_number, 7, 1), 7, '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

DECLARE
    v_p_number VARCHAR2(100) := '9501011667777';
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) ' || v_p_number);
    yedam_ju(v_p_number);
    DBMS_OUTPUT.PUT_LINE('2) ' || v_p_number);
END;
/
