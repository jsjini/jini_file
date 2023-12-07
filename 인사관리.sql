desc departments;

select *
from employees;

select department_id, location_id
from departments;

select location_id, department_id -- 테이블에 있는 칼럼의 순서는 의미가없다.
from departments;

select department_id, department_id
from departments;

select last_name, salary, salary + 300
from employees;

select last_name, salary, 12*salary+100
from employees;

select last_name, salary, 12*(salary+100)
from employees;

select last_name, job_id, salary, commission_pct
from employees;

select last_name, 12*salary*commission_pct -- 널 값을 포함하는 산술식은 널로 평가
from employees;

select last_name, 12*salary*NVL(commission_pct, 1)
from employees;

select last_name as name, commission_pct comm
from employees;

select last_name "Name" , salary*12 "Annual Salary"
from employees;

select last_name "이름" , salary*12 "보너스"
from employees;

select last_name||job_id as "Employees"
from employees;

select last_name||' is a '||job_id as "Employees Details"
from employees;

select department_id
from employees;

select distinct department_id
from employees;

select distinct department_id, job_id -- distinct는 반드시 select 다음에 온다.
from employees;

desc departments;
select * from departments;

desc employees;
select employee_id, last_name, job_id, hire_date as startdate
from employees;

select distinct job_id
from employees;

desc employees;
select employee_id as "Emp #" , last_name as "Employee" , job_id as "Job", hire_date as "Hire Date"
from employees;

select job_id || ', ' || last_name as "Employee and Title"
from employees;

select employee_id, last_name, job_id, department_id
from employees
where department_id = 90;

select last_name, job_id, department_id
from employees
where last_name = 'Whalen'; -- 'whalen' 데이터는 대소문자 구분함.

select last_name
from employees
where hire_date = '05/10/10';

select last_name, salary
from employees
where salary <= 3000;

select last_name, hire_date
from employees
where hire_date < '05/01/01';

select last_name, salary
from employees
where salary between 2500 and 3500;

select last_name, salary
from employees
where salary between 3500 and 2500; -- 논리적오류는 조심하자 무조건 작은값이 앞에!!

select employee_id, last_name, salary, manager_id
from employees
where manager_id in (100, 101, 201);

select first_name
from employees
where first_name like 'S%';

select last_name
from employees
where last_name like '%s';

select last_name, hire_date
from employees
where hire_date like '05%';

select last_name, hire_date
from employees
where last_name like '_o%';

select employee_id, last_name, job_id
from employees
where job_id like '%SA_%';

select employee_id, last_name, job_id
from employees
where job_id like '%SA3_%' escape '3'; -- 문자 언더바를 쓰고 싶을 때는 언더바 앞에 뭔가를 쓰고 이스케이프 뭔가를 적는다.

select employee_id, last_name, job_id
from employees
where job_id like '%_M%';

select employee_id, last_name, job_id
from employees
where job_id like '%3_M%' escape '3';

select *
from employees
where commission_pct is null; -- =null 이 아니고 is null 로 써야함!

select employee_id, last_name, job_id, salary
from employees
where salary >= 10000 and job_id like '%MAN%';

select employee_id, last_name, job_id, salary
from employees
where salary >= 10000 or job_id like '%MAN%';

select last_name, job_id
from employees
where job_id not in ('IT_PROG', 'ST_CLERK', 'SA_REP');

select last_name, job_id, salary
from employees
where job_id = 'SA_REP'
or job_id = 'AD_PRES'
and salary = 15000;

select last_name, job_id, salary
from employees
where (job_id = 'SA_REP' or job_id = 'AD_PRES')
and salary = 15000;

-- 1번
select last_name, salary
from employees
where salary > 12000;

-- 2번
select last_name, department_id
from employees
where employee_id = 176;

-- 3번
select last_name, salary
from employees
where salary not between 5000 and 12000;

-- 6번
select last_name as "Employee", salary as "Monthly Salary"
from employees
where salary between 5000 and 12000
and department_id in (20, 50);

-- 7번
select last_name, hire_date
from employees
where hire_date like '14%';

-- 8번
select last_name, job_id
from employees
where manager_id is null;

-- 10번
select last_name
from employees
where last_name like '__a%';

-- 11번
select last_name
from employees
where last_name like '%a%'
or last_name like '%e%';

select last_name
from employees
where last_name in ('a' , 'e');

-- 12번
select last_name, job_id, salary
from employees
where job_id in ('SA_REP','ST_CLERK')
and salary not in (2500, 3500, 7000);

-- 13번
select last_name, salary, commission_pct
from employees
where commission_pct = 0.2;