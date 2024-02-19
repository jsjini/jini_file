SELECT *
FROM user_source
WHERE type IN ('PROCEDURE');


SET SERVEROUTPUT ON

-- FUNCTION  
CREATE FUNCTION test_fun
( p_msg IN VARCHAR2 )  -- 무조건 IN만 가능.
RETURN VARCHAR2
IS
    -- 선언부(DECLARE)
BEGIN
    
    RETURN p_msg;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '데이터가 존재하지 않습니다.';
END;
/

-- FUNCTION의 기본 호출 방법.
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    v_result := test_fun('테스트');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- FUNCTION은 기본SQL문에서 사용가능 (PROCEDURE는 불가능) 
SELECT test_fun('SELECT문에서 호출')
FROM dual;

SELECT *
FROM dual;

SELECT test_fun('SELECT문에서 호출')
FROM employees;


-- 더하기
CREATE FUNCTION y_sum
(p_x IN NUMBER,
 p_y IN NUMBER)
RETURN NUMBER
IS
    v_result NUMBER;
BEGIN
    v_result := p_x + p_y;
    RETURN v_result;
END;
/

SELECT y_sum(100, 200)
FROM dual;

SELECT *
FROM employees;
-- 사원번호를 기준으로 직속상사 이름을 출력.
-- 셀프 조인 - e, m 위치가 중요함.
SELECT m.last_name
FROM employees e JOIN employees m
    ON (e.manager_id = m.employee_id)
WHERE e.employee_id = 149;

CREATE OR REPLACE FUNCTION get_mgr
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    SELECT m.last_name
    INTO v_mgr_name
    FROM employees e JOIN employees m
        ON (e.manager_id = m.employee_id)
    WHERE e.employee_id = p_eid;
    
    RETURN v_mgr_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RETURN '직속상사가 존재하지 않습니다.';
END;
/

SELECT employee_id, last_name, get_mgr(employee_id) as manager
FROM employees;


