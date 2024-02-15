SET SERVEROUTPUT ON

DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := .1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &사원번호;
    
    INSERT INTO employees(employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);
    
    UPDATE employees
    SET salary = (NVL(salary, 0) + 10000) * v_comm
    WHERE employee_id = 1000;
    
END;
/

SELECT *
FROM employees
WHERE employee_id = 1000;


BEGIN
    DELETE FROM employees
    WHERE employee_id = 1000;
    
    -- 암시적커서는 덮어씀
--    UPDATE employees
--    SET salary = salary * 1.1
--    WHERE employee_id = 0;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되지 않았습니다.');
    END IF;
END;
/


-- 1. 사원번호를 입력 (치환변수 사용&) 할 경우
-- 사원번호, 사원이름, 부서이름
-- 을 출력하는 PL/SQL을 작성하시오.

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id
WHERE e.employee_id = &사원번호;

DECLARE
    v_empid employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, e.last_name, d.department_name
    INTO v_empid, v_name, v_deptname
    FROM employees e JOIN departments d
    ON e.department_id = d.department_id
    WHERE e.employee_id = &사원번호;

    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_empid );
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_deptname);
END;
/
-- PL/SQL의 경우 가능한 방법 (SELECT문 두개를 활용)
-- department_id를 먼저 가져와서 가져온 값으로 department_name을 가져온다.
SELECT employee_id, last_name, department_id
FROM employees
WHERE e.employee_id = &사원번호;

--SELECT department_name
--FROM departments
--WHERE departments_id = 위에서 가져온 값;


--select *
--from departments;
--select *
--from employees;


-- 2. 사원번호를 입력 (치환변수사용&) 할 경우
-- 사원이름, 급여, 연봉 -> (급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12)
-- 을 출력하는 PL/SQL을 작성하시오.

SELECT last_name, salary, (salary*12 + (NVL(salary,0)*NVL(commission_pct,0)*12)) as annual
FROM employees
WHERE employee_id = &사원번호;

DECLARE
    v_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_annual employees.salary%TYPE;
BEGIN
    SELECT last_name, salary, (salary*12 + (NVL(salary,0)*NVL(commission_pct,0)*12)) as annual
    INTO v_name, v_salary, v_annual 
    FROM employees
    WHERE employee_id = &사원번호;

    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_annual);

END;
/
-- PL/SQL의 경우 가능한 방법 (별도연산)
DECLARE
    v_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_annual employees.salary%TYPE;
BEGIN
    SELECT last_name, salary, commission_pct
    INTO v_name, v_salary, v_comm
    FROM employees
    WHERE employee_id = &사원번호;
    
    v_annual := (v_salary*12 + (NVL(v_salary,0)*NVL(v_comm,0)*12));
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_annual);
END;
/

CREATE TABLE test_employees
AS
    SELECT *
    FROM employees;

-- 기본 IF 문
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('사원번호를 확인해주세요.');
    END IF;
END;
/

SELECT *
FROM employees;

-- IF ~ ELSE 문 : 하나의 조건식, 결과는 참과 거짓 각각
DECLARE
    v_result NUMBER(4,0);
BEGIN
    SELECT COUNT(employee_id)
    INTO v_result
    FROM employees
    WHERE manager_id = &사원번호;
    
    IF v_result = 0 THEN
        DBMS_OUTPUT.PUT_LINE('일반 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('팀장입니다.');
    END IF;
END;
/

-- IF ~ ELSIF ~ ELSE 문 : 다중 조건식이 필요, 각각 결과처리
-- 연차를 구하는 공식
SELECT employee_id, TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
FROM employees;

DECLARE
    v_hyear NUMBER(2,0);
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hyear
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hyear < 5 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 5년 미만입니다.');
    ELSIF v_hyear < 10 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 5년 이상 10년 미만입니다.');
    ELSIF v_hyear < 15 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 10년 이상 15년 미만입니다.');
    ELSIF v_hyear < 20 THEN
        DBMS_OUTPUT.PUT_LINE('입사한 지 15년 이상 20년 미만입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('입사한 지 20년 이상입니다.');
    END IF;
END;
/

-- 3-1. 사원번호를 입력(치환변수 사용&)할 경우
-- 입사일이 2015년 이후(2015년 포함)이면 'New employee' 출력
-- 2015년 이전이면 'Career employee' 출력
SELECT employee_id, TO_CHAR(hire_date, 'yyyy')
FROM employees
where hire_date > '2014/12/31';

DECLARE
    v_date DATE;
BEGIN
    SELECT hire_date
    INTO v_date
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- IF v_date > = TO_DATE('2015-01-01', 'yyyy-MM-dd') THEN
    -- IF TO_CHAR(v_date, 'yyyy') >= '2015' THEN
    IF v_date > '2014/12/31' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/

-- 3-2. 사원번호를 입력(치환변수 사용&)할 경우
-- 입사일이 2015년 이후(2015년 포함)이면 'New employee' 출력
-- 2015년 이전이면 'Career employee' 출력
-- 단, DBMS_OUTPUT.PUT_LINE ~은 한번만 사용.
DECLARE
    v_date DATE;
    v_result VARCHAR2(1000);
BEGIN
    SELECT hire_date
    INTO v_date
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_date > '2014/12/31' THEN
        v_result := 'New employee';
    ELSE
        v_result := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- yy는 무조건 현재 세기 (20yy년)
-- rr은 0~49 , 50~99 에 따라 19rr , 20rr 로 출력
SELECT TO_CHAR(TO_DATE('99/01/01', 'rr/MM/dd'), 'yyyy-MM-dd'),
       TO_CHAR(TO_DATE('99/01/01', 'yy/MM/dd'), 'yyyy-MM-dd')
FROM dual;

-- 5. 급여가 5000이하이면 20% 인상된 급여
-- 급여가 10000이하이면 15% 인상된 급여
-- 급여가 15000이하이면 10% 인상된 급여
-- 급여가 15001이상이면 급여 인상없음
-- 사원번호를 입력(치환변수&)하면
-- 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.

-- 입력 : 사원번호
-- 연산 : 1)SELECT문 employees     => 사원이름, 급여

SELECT last_name, salary
FROM employees
WHERE employee_id = &사원번호;

DECLARE
    v_ename employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_upsalary v_salary%TYPE;
BEGIN
    SELECT last_name, salary
    INTO v_ename, v_salary
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_salary <= 5000 THEN
        v_upsalary := v_salary * 1.2;
    ELSIF v_salary <= 10000 THEN
        v_upsalary := v_salary * 1.15;
    ELSIF v_salary <= 15000 THEN
        v_upsalary := v_salary * 1.1;
    ELSE 
        v_upsalary := v_salary;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' ||v_ename);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('인상된 급여 : ' || v_upsalary);
END;
/


-- 기본 LOOP문
-- 문법적 오류는 없지만 기본 LOOP문에는 항상 EXIT를 넣어줘야함.
-- 문법적 오류는 없지만 변수가 변경되는 코드는 필수로 있어야함.
DECLARE
    v_num NUMBER(38) := 0;
BEGIN
    LOOP
        v_num := v_num + 1;
        DBMS_OUTPUT.PUT_LINE(v_num);
        EXIT WHEN v_num > 10; -- 종료조건
    END LOOP;
END;
/

-- WHILE LOOP문
-- 문법적 오류는 없지만 변수가 변경되는 코드는 필수로 있어야함.
DECLARE
    v_num NUMBER(38,0) := 10;
BEGIN
    WHILE v_num < 5 LOOP -- 반복조건
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_num := v_num + 1;
    END LOOP;
END;
/

-- 예제 : 1에서 10까지 정수값의 합
-- 1) 기본 LOOP
DECLARE
    v_num NUMBER(2,0) := 1;
    v_sum NUMBER(2,0) := 0;
BEGIN
    LOOP
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
        EXIT WHEN v_num > 10; -- 종료조건
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/
-- 2) WHILE LOOP
DECLARE
    v_num NUMBER(2,0) := 1;
    v_sum NUMBER(2,0) := 0;
BEGIN
    WHILE v_num <= 10 LOOP -- 반복조건
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- FOR LOOP
-- 증감하는 값을 건들 순 없다.
BEGIN
    FOR idx IN -10 .. 5 LOOP
        IF MOD(idx,2) <> 0 THEN -- <> => != 의미
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/
-- 주의사항 1)범위지정
BEGIN
    FOR idx IN REVERSE -10 .. 5 LOOP -- FOR idx IN 5 .. -10 LOOP (X)
        IF MOD(idx,2) <> 0 THEN -- <> => != 의미
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/

-- 주의사항 2)카운터(counter) - 값 변경 X , 변수명 혼동될 수 있으니 DECLARE의 변수명과 동일하게 사용 X
DECLARE
    v_num NUMBER(2,0) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num * 2;
    DBMS_OUTPUT.PUT_LINE(v_num);
    DBMS_OUTPUT.PUT_LINE('==========================');
    FOR v_num IN 1 .. 10 LOOP
--        v_num := 0;
        DBMS_OUTPUT.PUT_LINE(v_num * 2);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_num);
END;
/


-- 예제 : 1에서 10까지 정수값의 합
DECLARE
    v_total NUMBER(2,0) := 0;
BEGIN
    FOR num IN 1 .. 10 LOOP
       v_total := v_total + num;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

-- 답안이 3개 나와야함. 기본, FOR, WHILE 모두
-- 1. 다음과 같이 출력되도록 하시오.
-- *
-- **
-- ***
-- ****
-- *****

-- 기본
DECLARE
    v_star VARCHAR2(100) := ''; -- null은 원칙적으로 연산이 안된다.
    v_num NUMBER(38) := 1;
BEGIN
    LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
        v_num := v_num + 1;
        EXIT WHEN v_num > 5; -- 종료조건
    END LOOP;
END;
/
-- WHILE
DECLARE
    v_star VARCHAR2(100) := '';
    v_num NUMBER(38) := 0;
BEGIN
    WHILE v_num < 5 LOOP -- 반복조건
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
        v_num := v_num + 1;
    END LOOP;
END;
/
-- FOR
DECLARE
    v_star VARCHAR2(100) := '';
BEGIN
    FOR num IN 1 .. 5 LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/
-- 이중 FOR문의 예 (권장하지는 않음)
BEGIN
    FOR num IN 1 .. 5 LOOP -- 몇번째 줄
        FOR i IN 1 .. num LOOP  -- *
            DBMS_OUTPUT.PUT('*'); -- 단독으로 사용불가. PUT_LINE 이 적절한 시점(대부분 마지막)에 있어야함.
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;