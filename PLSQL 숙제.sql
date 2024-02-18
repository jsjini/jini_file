CREATE TABLE test_employees
AS
    SELECT *
    FROM employees;


SET SERVEROUTPUT ON

/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******
*/

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

EXECUTE yedam_ju(9501011667777);
EXECUTE yedam_ju(1511013689977);


/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/

CREATE PROCEDURE test_pro
(p_eid IN test_employees.employee_id%TYPE)
IS

BEGIN
    DELETE FROM test_employees
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
    END IF;
END;
/

EXECUTE TEST_PRO(205);


/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/

CREATE PROCEDURE yedam_emp
(p_eid IN test_employees.employee_id%TYPE)
IS
    v_result VARCHAR2(100);
BEGIN
    SELECT RPAD(SUBSTR(last_name, 1, 1), LENGTH(last_name), '*')
    INTO v_result
    FROM test_employees
    WHERE employee_id = p_eid;
    
    DBMS_OUTPUT.PUT_LINE(v_result); 
END;
/

EXECUTE yedam_emp(176);


/*
4.
부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name)을 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/

CREATE PROCEDURE get_emp
(p_deptid test_employees.department_id%TYPE)
IS
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM test_employees
        WHERE department_id = p_deptid;
    
    v_emp_record emp_cursor%ROWTYPE;
    e_emp EXCEPTION;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT('사원번호: ' || v_emp_record.employee_id);
        DBMS_OUTPUT.PUT_LINE(', 사원이름: ' || v_emp_record.last_name);
    END LOOP;
    
    IF emp_cursor%ROWCOUNT = 0 THEN
        RAISE e_emp;
    END IF;
    
    CLOSE emp_cursor;
    
EXCEPTION
    WHEN e_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
END;
/

EXECUTE get_emp(30);


/*
5.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/

CREATE PROCEDURE y_update
(p_eid test_employees.employee_id%TYPE,
 p_increase test_employees.salary%TYPE)
IS
    e_emp EXCEPTION;
BEGIN
    UPDATE test_employees
    SET salary = salary + p_increase
    WHERE employee_id = p_eid;

    IF SQL%NOTFOUND THEN
        RAISE e_emp;
    END IF;
EXCEPTION
    WHEN e_emp THEN
    DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

EXECUTE y_update(200, 10);

