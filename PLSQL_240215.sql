SET SERVEROUTPUT ON

-- 2. 치환변수(&)를 사용하면 숫자를 입력하면 
-- 해당 구구단이 출력되도록 하시오.
-- 예) 2 입력시 쫙~


-- 기본
DECLARE
    v_gugu NUMBER(2,0) := 1;
    v_dan NUMBER(2,0) := &몇단;
    v_gugudan VARCHAR2(100) := '';
BEGIN
    LOOP
        v_gugudan := v_dan || ' * ' || v_gugu || ' = ' || v_dan * v_gugu;
        DBMS_OUTPUT.PUT_LINE(v_gugudan);
        v_gugu := v_gugu + 1;
        EXIT WHEN v_gugu > 9; -- 종료조건
    END LOOP;
END;
/

-- WHILE
DECLARE
    v_gugu NUMBER(2,0) := 1;
    v_dan NUMBER(2,0) := &몇단;
    v_gugudan VARCHAR2(100) := '';
BEGIN
    WHILE v_gugu <= 9 LOOP -- 반복조건
        v_gugudan := v_dan || ' * ' || v_gugu || ' = ' || v_dan * v_gugu;
        DBMS_OUTPUT.PUT_LINE(v_gugudan);
        v_gugu := v_gugu + 1;
    END LOOP;
END;
/

-- FOR
DECLARE
    v_dan NUMBER(2,0) := &몇단;
    v_gugudan VARCHAR2(100) := '';
BEGIN
    FOR gugu IN 1 .. 9 LOOP
        v_gugudan := v_dan || ' * ' || gugu || ' = ' || v_dan * gugu;
        DBMS_OUTPUT.PUT_LINE(v_gugudan);
    END LOOP;
END;
/

-- 기본
DECLARE
    v_gugu NUMBER(2,0) := 1;
    v_dan NUMBER(2,0) := 2;
BEGIN
    LOOP
        LOOP 
            DBMS_OUTPUT.PUT(v_dan || ' * ' || v_gugu || ' = ' || v_dan * v_gugu || '  ');
            v_gugu := v_gugu + 1;
            EXIT WHEN v_gugu > 9;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_dan := v_dan + 1;
        v_gugu := 1;
        EXIT WHEN v_dan > 9; -- 종료조건
    END LOOP;
END;
/

-- WHILE
DECLARE
    v_gugu NUMBER(2,0) := 1;
    v_dan NUMBER(2,0) := 2;
BEGIN
    WHILE v_gugu <= 9 LOOP -- 반복조건
        WHILE v_dan <= 9 LOOP
            DBMS_OUTPUT.PUT(v_dan || ' * ' || v_gugu || ' = ' || v_dan * v_gugu || '  ');
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_gugu := v_gugu + 1;
        v_dan := 2;
    END LOOP;
END;
/

-- FOR
BEGIN
    FOR gugu IN 1 .. 9 LOOP  -- 단 : 2 ~ 9, 정수
        FOR dan IN 2 .. 9 LOOP -- 곱하는 수 : 1 ~ 9, 정수
            DBMS_OUTPUT.PUT(dan || ' * ' || gugu || ' = ' || dan * gugu || '  ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP; 
END;
/

-- 4. 구구단 1~9단까지 출력되도록 하시오. ( 단, 홀수만 출력)

-- 기본
DECLARE
    v_gugu NUMBER(2,0) := 1;
    v_dan NUMBER(2,0) := 2;
BEGIN
    LOOP
        IF MOD(v_dan, 2) <> 0 THEN
            LOOP 
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_gugu || ' = ' || v_dan * v_gugu);
                v_gugu := v_gugu + 1;
                EXIT WHEN v_gugu > 9;
            END LOOP;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('');
        v_dan := v_dan + 1;
        v_gugu := 1;
        EXIT WHEN v_dan > 9; -- 종료조건
    END LOOP;
END;
/

-- WHILE
DECLARE
    v_gugu NUMBER(2,0) := 1;
    v_dan NUMBER(2,0) := 2;
BEGIN
    WHILE v_dan <= 9 LOOP -- 반복조건
        IF MOD(v_dan, 2) <> 0 THEN
            WHILE v_gugu <= 9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_gugu || ' = ' || v_dan * v_gugu);
                v_gugu := v_gugu + 1;
            END LOOP;
        END IF;
        DBMS_OUTPUT.PUT_LINE('');
        v_dan := v_dan + 1;
        v_gugu := 1;
    END LOOP;
END;
/

-- FOR
BEGIN
    FOR dan IN 2 .. 9 LOOP  -- 단 : 2 ~ 9, 정수
        IF MOD(dan, 2) <> 0 THEN
            FOR gugu IN 1 .. 9 LOOP -- 곱하는 수 : 1 ~ 9, 정수
                DBMS_OUTPUT.PUT_LINE(dan || ' * ' || gugu || ' = ' || dan * gugu);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP; 
END;
/
-- FOR 방법2
BEGIN
    FOR dan IN 2 .. 9 LOOP  -- 단 : 2 ~ 9, 정수
        IF MOD(dan, 2) = 0 THEN
            CONTINUE;
        END IF;
        
        FOR gugu IN 1 .. 9 LOOP -- 곱하는 수 : 1 ~ 9, 정수
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || gugu || ' = ' || dan * gugu);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP; 
END;
/


-- RECORD
DECLARE
    -- 1) 정의
    TYPE emp_record_type IS RECORD
        (empno NUMBER(6,0),
         ename employees.last_name%TYPE,
         sal employees.salary%TYPE := 0); -- 초기값 주는거 가능.
        
    -- 2) 변수 선언
    v_emp_info emp_record_type;
    v_emp_record emp_record_type;
BEGIN
    SELECT employee_id, last_name, salary
    INTO v_emp_info
    FROM employees
    WHERE employee_id = &사원번호;

    DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.empno);
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', 급여 : ' || v_emp_info.sal);
--    DBMS_OUTPUT.PUT_LINE(v_emp_info); -- 레코드 타입만 출력은 못함.
END;
/

-- ROWTYPE 별도의 정의가 필요없음. - 테이블과 뷰에서만 사용가능.
DECLARE
    v_emp_info employees%ROWTYPE;
BEGIN
    SELECT *
    INTO v_emp_info
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.employee_id); -- 필드명을 사용.
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.last_name);
    DBMS_OUTPUT.PUT_LINE(', 업무 : ' || v_emp_info.job_id);
END;
/

-- TABLE
DECLARE
    -- 1) 정의
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;
        
    -- 2) 변수 선언
    v_num_info num_table_type;
BEGIN
    DBMS_OUTPUT.PUT_LINE('현재 인덱스 -1000 : ' || v_num_info(-1000));

    v_num_info(-1000) := 10000;
    
    DBMS_OUTPUT.PUT_LINE('현재 인덱스 -1000 : ' || v_num_info(-1000));
END;
/

-- 2의 배수 10개를 담는 예제 : 2, 4, 6, 8, 10, 12, 14, ...
DECLARE
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;
        
    v_num_ary num_table_type;
    
    v_result NUMBER(4,0) := 0;
BEGIN
    FOR idx IN 1 .. 10 LOOP
        v_num_ary(idx * 5) := idx * 2;
    END LOOP;
    
    FOR i IN v_num_ary.FIRST .. v_num_ary.LAST LOOP
        IF v_num_ary.EXISTS(i) THEN
            DBMS_OUTPUT.PUT(i || ' : ');
            DBMS_OUTPUT.PUT_LINE(v_num_ary(i));
            
            v_result := v_result + v_num_ary(i);
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('총 갯수 : ' || v_num_ary.COUNT);
    DBMS_OUTPUT.PUT_LINE('누적합 : ' || v_result);
END;
/

-- TABLE + RECORD
SELECT MIN(employee_id), MAX(employee_id)
FROM employees;
SELECT employee_id
FROM employees;

DECLARE
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY PLS_INTEGER;
        
    v_emps emp_table_type;
    v_emp_info employees%ROWTYPE;
    v_min NUMBER(3,0);
    v_max NUMBER(3,0);
    v_result NUMBER(1,0);
BEGIN
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;

    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN
            CONTINUE;
        END IF;
        
        SELECT *
        INTO v_emp_info
        FROM employees
        WHERE employee_id = eid;

        v_emps(eid) := v_emp_info;
    END LOOP;
    
    
    DBMS_OUTPUT.PUT_LINE('총 갯수 : ' || v_emps.COUNT);
    DBMS_OUTPUT.PUT_LINE(v_emps(100).last_name);
END;
/


-- CURSOR
DECLARE
    -- 커서를 선언
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE employee_id = 0;  -- 데이터가 없어도 에러는 안뜸.
    
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    OPEN emp_cursor;
    
    FETCH emp_cursor INTO v_eid, v_ename;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);    
    CLOSE emp_cursor;
END;
/

-- 
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees;
        
    v_emp_record emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_emp_record;

        EXIT WHEN emp_cursor%NOTFOUND;
--        EXIT WHEN emp_cursor%ROWCOUNT >= 20;  - 갯수가 명확하지 알지 못하면 한계가 있다.

        -- 실제 연산 진행
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', '); -- 중복데이터가 발생하므로 NOTFOUND 밑에 사용해야함.
        DBMS_OUTPUT.PUT_LINE(v_emp_record.last_name);

    END LOOP;

    CLOSE emp_cursor;

END;
/

DECLARE
    CURSOR emp_cursor IS
        SELECT *
        FROM employees;
        
    v_emp_record employees%ROWTYPE;    

    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
    INDEX BY PLS_INTEGER;
    
    v_emp_table emp_table_type;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
    
        v_emp_table(v_emp_record.employee_id) := v_emp_record;
    END LOOP;
    
    CLOSE emp_cursor;
    
    FOR eid IN v_emp_table.FIRST .. v_emp_table.LAST LOOP
        IF v_emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(v_emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT(v_emp_table(eid).last_name || ', ');
            DBMS_OUTPUT.PUT_LINE(v_emp_table(eid).hire_date);
        END IF;
    END LOOP;    

END;
/
SELECT employee_id, last_name, job_id,department_id
        FROM employees;
-- 
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &부서번호;
        
    v_emp_info emp_dept_cursor%ROWTYPE;
    
BEGIN
    -- 1) 해당 부서에 속한 사원의 정보를 출력
    -- 2) 해당 부서에 속한 사원이 없는 경우 '해당 부서에 소속된 직원이 없습니다.' 라는 메세지 출력
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND;
        
        -- ROWCOUNT 사용할 수 있는 첫번째 => 몇 번째 행
--        DBMS_OUTPUT.PUT_LINE('첫번째 : ' || emp_dept_cursor%ROWCOUNT);
        
        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT(v_emp_info.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.job_id);
    
    END LOOP;
    IF emp_dept_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 소속된 직원이 없습니다.');
    END IF;
--  ROWCOUNT 사용할 수 있는 두번째 => 현재 커서의 데이터 총 갯수
--  DBMS_OUTPUT.PUT_LINE('두번째 : ' || emp_dept_cursor%ROWCOUNT);
        
    CLOSE emp_dept_cursor;
END;
/

-- 1) 모든 사원의 사원번호, 이름, 부서이름 출력
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id;

DECLARE
    CURSOR emp_dept_cursor IS
        SELECT e.employee_id eid, e.last_name ename, d.department_name dept_name
        FROM employees e LEFT OUTER JOIN departments d
        ON e.department_id = d.department_id;
        
    v_emp_info emp_dept_cursor%ROWTYPE;
    
BEGIN
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND; 
        
        DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.eid || ', ');
        DBMS_OUTPUT.PUT('사원이름 : ' || v_emp_info.ename || ', ');
        DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_emp_info.dept_name);
    
    END LOOP;
        
    CLOSE emp_dept_cursor;
END;
/

-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- 연봉 : (급여 * 12) + (NVL(급여, 0) * NVL(커미션,0) *12)
SELECT last_name, salary, commission_pct
FROM employees
WHERE department_id IN (50, 80);

DECLARE
    CURSOR emp_dept_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id IN (50, 80);
        
    v_emp_info emp_dept_cursor%ROWTYPE;
--    v_annual employees.salary%TYPE; -- 연봉을 담아서 출력시 사용.
BEGIN
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND; 
        
        DBMS_OUTPUT.PUT('사원이름 : ' || v_emp_info.last_name || ', ');
        DBMS_OUTPUT.PUT('급여 : ' || v_emp_info.salary || ', ');
        DBMS_OUTPUT.PUT('연봉 : ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.salary*12 + NVL(v_emp_info.salary,0)*NVL(v_emp_info.commission_pct,0)*12);
    END LOOP;
    
    CLOSE emp_dept_cursor;
END;
/