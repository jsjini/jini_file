select department_id, department_name
from departments;

select last_name, department_name
from   employees, departments;

select count(*)
from departments;

-- 테이블 이름명을 접두어로 붙이자!
select  e.employee_id, e.last_name, e.department_id,
        d.department_id, d.location_id, d.department_name
from    employees e, departments d
where   e.department_id = d.department_id;

select  employee_id, last_name, e.department_id,
        d.department_id, location_id, department_name
from    employees e, departments d
where   e.department_id = d.department_id;

select  d.department_id, d.department_name,
        d.location_id, l.city
from    departments d, locations l
where   d.location_id = l.location_id;

select  d.department_id, d.department_name, l.city
from    departments d, locations l
where   d.location_id = l.location_id
        and d.department_id in (20, 50);

select *
from job_grades;

select e.last_name, e.salary, j.grade_level
from employees e, job_grades j
where e.salary
      between j.lowest_sal and j.highest_sal;
      
select e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id(+) = d.department_id;

select e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

select employee_id, last_name
from employees
order by 1;

-- 셀프 조인
select worker.last_name || ' works for ' || manager.last_name
from employees worker, employees manager
where worker.manager_id = manager.employee_id;

-- 여기서부터 ANSI조인
-- 교차 조인
select last_name, department_name
from employees cross join departments;
-- 자연 조인 -안쓰는걸 권장.
select department_id, department_name, location_id, city
from departments natural join locations;
desc departments;
desc locations;
-- using 절 조인
select employee_id, last_name, location_id,
       department_id
from   employees join departments 
                        using (department_id);
-- 조건에 알리아스 금지.
select l.city, d.department_name
from   locations l join departments d
                        using (location_id)
where  location_id = 1400;

-- ON 절 조인 중요!
select  e.department_id, e.last_name, e.department_id, 
        d.department_id, d.location_id
from    employees e join departments d
             on (e.department_id = d.department_id);
             
select  employee_id, city, department_name
from    employees e
        join    departments d
            on d.department_id = e.department_id
        join    locations l
            on d.location_id = l.location_id;
            
select  employee_id, city, department_name
from    employees e, departments d, locations l
         where   d.department_id = e.department_id
        and d.location_id = l.location_id;

select e.last_name, e.department_id, d.department_name
from employees e left outer join departments d
        on (e.department_id = d.department_id);

select e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

select e.last_name, e.department_id, d.department_name
from employees e right outer join departments d
        on (e.department_id = d.department_id);
        
select e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id(+) = d.department_id;

-- ANSI조인과 다르게 오라클조인은 full 아우터 조인을 지원해주지 않습니다.
select e.last_name, e.department_id, d.department_name
from employees e full outer join departments d
        on (e.department_id = d.department_id);
-- 추가조건  and , where 둘다 가능   
select e.last_name, e.department_id, d.department_name
from   employees e join departments d
            on (e.department_id = d.department_id)
            and e.manager_id = 149;
select e.last_name, e.department_id, d.department_name
from   employees e join departments d
            on (e.department_id = d.department_id)
where  e.manager_id = 149;

--1. LOCATIONS 및 COUNTRIES 테이블을 사용하여 모든 부서의 주소를 생성하는 query를 작성하시오. 
--출력에 위치ID(location_id), 주소(street_address), 구/군(city), 시/도(state_province) 및 국가(country_name)를 표시하시오.
select l.location_id, l.street_address, l.city, l.state_province, c.country_name
from locations l, countries c
where l.country_id = c.country_id;
--2. 모든 사원의 이름, 소속 부서번호 및 부서 이름을 표시하는 query를 작성하시오.
select e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id;
--3. Toronto에 근무하는 사원에 대한 보고서를 필요로 합니다. 
--toronto에서 근무하는 모든 사원의 이름, 직무, 부서번호 및 부서 이름을 표시하시오.
select e.last_name, e.job_id, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id
and d.location_id = 1800;

select e.last_name, e.job_id, e.department_id, d.department_name
from employees e, departments d, locations l
where e.department_id = d.department_id
and l.location_id = d.location_id
and lower(l.city) = 'toronto';
--4. 사원의 이름 및 사원 번호를 해당 관리자의 이름 및 관리자 번호와 함께 표시하는 보고서를 작성하는데, 
--열 레이블을 각각 Employee, Emp#, Manager 및 Mgr#으로 지정하시오.
select  worker.last_name as "Employee", worker.employee_id as "Emp#", 
        manager.last_name as "Manager", worker.manager_id as "Mgr#"
from    employees worker, employees manager
where   worker.manager_id = manager.employee_id;
--5. King과 같이 해당 관리자가 지정되지 않은 사원도 표시하도록 4번 문장을 수정합니다. 
--사원 번호순으로 결과를 정렬하시오. 
select   worker.last_name as "Employee", worker.employee_id as "Emp#", 
         manager.last_name as "Manager", worker.manager_id as "Mgr#"
from     employees worker, employees manager
where    worker.manager_id = manager.employee_id(+)
order by worker.employee_id;
--6. 직무 등급 및 급여에 대한 보고서를 필요로 합니다. 먼저 JOB_GRADES 테이블의 구조를 표시한 다음 모든 사원의 이름, 직무, 부서 이름, 급여 및 등급을 표시하는 query를 작성하시오.
desc job_grades;
select *
from job_grades;
select e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
from employees e, departments d, job_grades j
where e.department_id = d.department_id
        and e.salary between j.lowest_sal and j.highest_sal;
    
    
-- 서브쿼리!
select last_name, salary
from   employees
where  salary in (select   max(salary)
                  from     employees
                  group by department_id);
select   max(salary)
from     employees
group by department_id;

select  last_name, salary
from    employees
where   salary > (select  salary
                  from    employees
                  where   last_name = 'Abel');
                  
select  employee_id, last_name, job_id
from    employees
where   job_id = (select job_id
                  from   employees
                  where  employee_id = 141)
and employee_id != 141;

select employee_id, last_name, job_id
from employees
where job_id = (select job_id
                from employees
                where employee_id = 141);
                
select  last_name, job_id, salary
from    employees
where   job_id = (select job_id
                  from employees
                  where last_name = 'Abel')
and     salary > (select salary
                  from employees
                  where last_name = 'Abel');
select *
from employees
where last_name = 'Taylor';

select  last_name, job_id, salary
from    employees
where   salary = (select min(salary)
                  from employees);
                
select   department_id, min(salary)
from     employees
group by department_id
having   min(salary) > (select min(salary)
                        from employees
                        where department_id = 50);
                        
select  employee_id, last_name, job_id, salary
from    employees
where   salary < any (select salary
                      from employees
                      where job_id = 'IT_PROG')
and     job_id <> 'IT_PROG';

select  employee_id, last_name, job_id, salary
from    employees
where   salary < all (select salary
                      from employees
                      where job_id = 'IT_PROG')
and     job_id <> 'IT_PROG';

select  employee_id, manager_id, department_id
from    empl_demo
where  (manager_id, department_id) in 
                                      (select manager_id, department_id
                                       from empl_demo
                                       where first_name = 'John')
and     first_name <> 'John';

select  employee_id, manager_id, department_id
from    empl_demo
where   manager_id in    (select manager_id
                          from empl_demo
                          where first_name = 'John')
and     department_id in (select department_id
                          from empl_demo
                          where first_name = 'John')
and     first_name <> 'John';

-- 모든컬럼에 데이터를 다 입력할때는 insert into에 ()안에 값 입력 안해도된다.
insert into departments(department_id, department_name, manager_id, location_id)
values (370, 'Public Relations', 100, 1700);
insert into departments
values (371, 'Public Relations', 100, 1700);

-- 특정컬럼에 데이터를 입력할때는 insert into에 ()안에 값 입력 해야함.
-- 암시적으로 널값을 입력.
insert into departments (department_id, department_name)
values (330, 'Purchasing');
-- 명시적으로 널값을 입력.
insert into departments
values      (400, 'Purchasing', null, null);

insert into departments
values (100, 'Finance', '', '');

select *
from departments;

insert into employees
values (113, 'Louis', 'Popp', 'LPOPP', '515.124.4567', sysdate, 'AC_ACCOUNT', 6900, null, 205, 110);

insert into employees
values (114, 'Den', 'Raphealy', 'DRAPHEAL', '515.127.4561', to_date('FEB 3, 1999', 'MON DD, YYYY'),
'SA_REP', 11000, 0.2, 100, 60);

insert into departments (department_id, department_name, location_id)
values (&department_id, '&department_name', &location);

select *
from employees;

select *
from sales_reps;
select *
from copy_emp;

insert into sales_reps
    select employee_id, last_name, salary, commission_pct
    from   employees
    where  job_id like '%REP%';

insert into copy_emp
    select *
    from employees;

-- 기본키의 값은 null이 될 수 없음.
-- 기본키의 값은 동일할 수 없음.
-- 외래키도 
insert into departments (department_id, department_name, manager_id)
values (130, 'YD', 100);
select *
from departments;

update employees
set    department_id = 51
where  employee_id = 113;

select *
from employees;
-- where 절이 중요함! 안쓰면 전체바뀜.
update copy_emp
set department_id = 110;

select *
from copy_emp;

update employees
set    job_id = 'IT_PROG', commission_pct = null
where  employee_id = 114;

rollback;


insert into copy_emp
    select *
    from employees;
select *
from copy_emp;
commit;
delete copy_emp;
rollback;

delete from departments
where department_name = 'Finance';

select *
from departments;

delete departments
where department_id in (30, 40);
rollback;

select *
from copy_emp;

delete copy_emp;

rollback;

truncate table copy_emp;
rollback;

CREATE TABLE my_employee
  (id         NUMBER(4) NOT NULL,
   last_name  VARCHAR2(25),
   first_name VARCHAR2(25),
   userid     VARCHAR2(8),
   salary     NUMBER(9,2));

--1. Zlotkey와 동일한 부서에 속한 모든 사원의 이름과 입사일을 표시하는 질의를 작성하시오. Zlotkey는 결과에서 제외하시오.
select last_name, hire_date
from   employees
where  department_id = (select department_id
                       from    employees
                       where   lower(last_name) = 'zlotkey')
and    lower(last_name) <> 'zlotkey';
--2. 급여가 평균 급여보다 많은 모든 사원의 사원 번호와 이름을 표시하는 질의를 작성하고 결과를 급여에 대해 오름차순으로 정렬하시오.
select   employee_id, last_name
from     employees
where    salary > (select avg(salary)
                  from    employees)
order by salary;
--3. 이름에 u가 포함된 사원과 같은 부서에서 일하는 모든 사원의 사원 번호와 이름을 표시하는 질의를 작성하고 질의를 실행하시오.
select employee_id, last_name
from   employees
where  department_id in (select department_id
                        from    employees
                        where   lower(last_name) like ('%u%'));
--4. 부서 위치 ID(location_id)가 1700인 모든 사원의 이름, 부서 번호 및 업무 ID를 표시하시오.
select last_name, department_id, job_id
from   employees
where  department_id in (select department_id
                        from    departments
                        where   location_id = 1700);
--5. King에게 보고하는(manager가 King) 모든 사원의 이름과 급여를 표시하시오.
select last_name, salary
from   employees
where  manager_id = (select employee_id
                     from    employees
                     where   lower(last_name) = 'king');
--6. Executive 부서의 모든 사원에 대한 부서 번호, 이름 및 업무 ID를 표시하시오.
select department_id, last_name, job_id
from   employees
where  department_id in (select department_id
                       from    departments
                       where   lower(department_name) = 'executive');
--7. 평균 급여보다 많은 급여를 받고 이름에 u가 포함된 사원과 같은 부서에서 근무하는 모든 사원의 사원 번호, 이름 및 급여를 표시하시오.
select employee_id, last_name, salary
from   employees
where  department_id in (select department_id
                        from    employees
                        where   lower(last_name) like ('%u%'))
and    salary > (select avg(salary)
                from    employees);

--3. 다음 예제 데이터를 MY_EMPLOYEE 테이블에 추가하시오.
--ID	LAST_NAME 	FIRST_NAME 	USERID 	SALARY
--1  	Patel 		Ralph 		Rpatel 	895
--2 	Dancs 		Betty 		Bdancs 	860
--3 	Biri 		Ben 		Bbiri 	1100
insert into my_employee
values (1, 'Patel', 'Ralph', 'Rpatel', 895);
insert into my_employee
values (2, 'Dancs', 'Betty', 'Bdancs', 860);
insert into my_employee
values (3, 'Biri', 'Ben', 'Bbiri', 1100);

--4. 테이블에 추가한 항목을 확인하시오.
select *
from   my_employee;
--6. 사원 3의 성을 Drexler로 변경하시오.
update my_employee
set    last_name = 'Drexler'
where  id = 3; 
--7. 급여가 900 미만인 모든 사원의 급여를 1000으로 변경하고 테이블의 변경 내용을 확인하시오.
update my_employee
set    salary = 1000
where  salary < 900;
select *
from   my_employee;
--8. MY_EMPLOYEE 테이블에서 사원 3을 삭제하고 테이블의 변경 내용을 확인하시오.
delete my_employee
where  id = 3;
select *
from   my_employee;
--11. 테이블의 내용을 모두 삭제하고 테이블 내용이 비어 있는지 확인하시오.
delete my_employee;
select *
from   my_employee;

commit;
select *
from employees
where employee_id = 176;

update employees
set salary = 77777
where employee_id = 176;

commit;

commit;

update employees
set salary = 99999
where employee_id = 176;

select *
from employees
where employee_id = 176;

rollback;

commit;

truncate table aa;

select table_name
from user_tables;

select distinct object_type
from user_objects;

select *
from user_catalog;

create table hire_dates
        (id       number(8),
        hire_date date default sysdate);
insert into hire_dates(id) 
values (35);

insert into hire_dates
values (45, null);

create table dept
        (deptno number(2),
        dname varchar2(14),
        loc varchar2(13),
        create_date date default sysdate);
describe dept;
select table_name from user_tables;

create table   dept80
    as 
        select employee_id, last_name,
               salary*12 ANNSAL,
               hire_date
        from   employees
        where  department_id = 80;

select *
from dept80;

alter table dept80
add         (job_id varchar2(9));

alter table dept80
add         (hdate date default sysdate);

alter table dept80
modify      (last_name varchar2(5));

alter table dept80
modify      (job_id number(10));
--값이 들어가있을땐 타입변경안됨.
alter table dept80
modify      (last_name number(15));

alter table dept80
drop        (job_id);

alter table dept80
set unused (last_name);
select *
from dept80;
-- unused 된 칼럼들을 모두 삭제함.
alter table dept80
drop unused columns;

drop table dept80;

select object_name, original_name, type
from user_recyclebin;

flashback table dept80 to before drop;
select *
from dept80;

drop table dept80 purge;

-- 휴지통 비우기
purge recyclebin;
-- 객체 이름변경
rename dept to dept80;
-- 테이블 절삭
truncate table dept80;

create table emp_test (
    empid number(5),
    empname varchar2(10) not null,
    duty varchar2(9),
    sal number(7,2),
    bonus number(7,2),
    mgr number(5),
    hire_date date,
    deptid number(2));

insert into emp_test(empid, empname)
values (10, null);
insert into emp_test(empid, empname)
values (10, 'YD');

create table dept_test (
    deptid number(2),
    dname  varchar2(14),
    loc    varchar2(13),
    unique(dname));

insert into dept_test(deptid, dname)
values (10,null);
insert into dept_test(deptid, dname)
values (20,'YD');
insert into dept_test(deptid, dname)
values (20,'YD');

drop table dept_test;

create table dept_test (
    deptid number(2) primary key,
    dname  varchar2(14),
    loc    varchar2(13),
    unique(dname));

insert into dept_test
values (10, 'YD', 'Deagu');
insert into dept_test
values (20, 'YD1', 'Deagu');
insert into dept_test
values (20, 'YD2', 'Deagu');
insert into dept_test
values (null, 'YD3', 'Deagu');
insert into dept_test
values (30, 'YD1', 'Deagu');

drop table emp_test;

create table emp_test (
    empid number(5),
    empname varchar2(10) not null,
    duty varchar2(9),
    sal number(7,2),
    bonus number(7,2),
    mgr number(5),
    hire_date date,
    deptid number(2),
    foreign key (deptid) references dept_test(deptid));
-- table 레벨에서 지정시 foreign key (칼럼명) references 부모테이블(칼럼명)
-- colum 레벨에서 지정시 deptid number(2) references dept_test(deptid)
insert into emp_test(empid, empname, deptid)
values (100, 'YD1', 10);
insert into emp_test(empid, empname, deptid)
values (200, 'YD2', null);
insert into emp_test(empid, empname, deptid)
values (300, 'YD3', 30);

drop table emp_test;

create table emp_test (
    empid number(5),
    empname varchar2(10) not null,
    duty varchar2(9),
    sal number(7,2),
    bonus number(7,2),
    mgr number(5),
    hire_date date,
    deptid number(2),
    foreign key (deptid) references dept_test(deptid) on delete set null);
    
insert into emp_test(empid, empname, deptid)
values (100, 'YD1', 10);
insert into emp_test(empid, empname, deptid)
values (200, 'YD2', null);

select *
from emp_test;

delete dept_test
where deptid = 10;

select *
from dept_test;

drop table emp_test;

create table emp_test (
    empid     number(5),
    empname   varchar2(10) not null,
    duty      varchar2(9),
    sal       number(7,2),
    bonus     number(7,2),
    mgr       number(5),
    hire_date date,
    deptid    number(2)check (deptid between 10 and 99),
    foreign key (deptid) references dept_test(deptid));
    
alter table emp_test
add   primary key(empid);

alter table emp_test
add   foreign key(mgr) references emp_test(empid);
-- not null 제약조건은 modify로 추가 가능
alter table emp_test
modify (duty not null);
select duty
from emp_test;
update emp_test
set duty = '1';

--제약조건 보기
select constraint_name, column_name
from   user_cons_columns;

desc user_cons_columns;

select constraint_name, table_name, column_name
from   user_cons_columns
where  table_name = 'EMP_TEST';

alter table emp_test
drop constraint SYS_C007022;

-- view(뷰)
create view empvu80
  as select employee_id, last_name, salary
     from   employees
     where  department_id = 80;

select *
from empvu80;

--뷰는 수정이 없고 or replace로 덮어쓰는것만 가능.
-- 수식이 들어가면 이유불문 컬럼알리아스를 써야함.
create view salvu50
  as select employee_id id_number, last_name name, -- salvu50(id_number,name,ann_salary)
            salary*12 ann_salary
     from   employees
     where  department_id = 50;

select *
from   salvu50;

create or replace view empvu80
   (id_number, name, sal, department_id)
as select employee_id, first_name || ' ' 
          || last_name, salary, department_id
   from   employees
   where  department_id = 80;

select *
from   empvu80;

create or replace view dept_sum_vu
   (name, minsal, maxsal, avgsal)
as select   d.department_name, min(e.salary),
            max(e.salary), avg(e.salary)
   from     employees e join departments d
   on       (e.department_id = d.department_id)
   group by d.department_name;
   
select *
from   dept_sum_vu;

select rownum, employee_id
from employees;

commit;

select *
from empvu80;

delete empvu80
where id_number = 176;

select *
from employees;

select *
from dept_sum_vu;

delete dept_sum_vu
where name = 'IT';

create view test_vu
as select department_name
   from   departments;

select *
from test_vu;

insert into test_vu
values ('YD');

create sequence dept_deptid_seq
    increment by 10
    start with 120
    maxvalue 9999
    nocache
    nocycle;
    
insert into departments(department_id,
            department_name, location_id)
values      (dept_deptid_seq.nextval,
            'Support', 2500);
select *
from departments;

rollback;

select *
from departments;

select dept_deptid_seq.currval
from dual;

create synonym d_sum
for dept_sum_vu;

select *
from d_sum;
select *
from dept_sum_vu;

select *
from system_privilege_map;

select level, employee_id, last_name, manager_id
from employees
start with manager_id is null
connect by prior employee_id = manager_id; -- == connect by manager_id = prior employee_id;

select level, employee_id, last_name, manager_id
from employees
start with manager_id is null
connect by prior manager_id = employee_id;

select level,
       lpad(' ', 4*(level-1))||employee_id employee,
       last_name, manager_id
from employees
start with manager_id is null
connect by prior employee_id = manager_id;






-- 1번
select employee_id, last_name, salary, department_id
from   employees
where  upper(last_name) like ('H%')
       and salary between 7000 and 12000;

-- 2번
select employee_id, last_name, to_char(hire_date, 'dd/mm/yyyy day'), to_char(salary*commission_pct,'$99,999.00') as incen
from employees
where commission_pct is not null
order by incen desc;

-- 3번
select employee_id, last_name, job_id, salary, department_id
from   employees
where  salary > 5000 
       and department_id in (50, 60);

-- 4번
select employee_id, last_name, department_id, case department_id when 20 then 'Canada'
                                                     when 80 then 'UK'
                                                    else 'USE'
                                                    end "근무지역"
from employees;

-- 5번
select e.employee_id, e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

-- 6번
select last_name, hire_date, case  when >= 05 then 'New employee' 
                                   when < 05 then 'Career employee' 
from employees
where employee_id = &employee_id;

-- 7번
select employee_id, last_name, salary, case  when salary <= 5000 then salary*0.2
                                when salary <= 10000 then salary*0.15
                                when salary <= 15000 then salary*0.1
                                when salary >= 15001 then salary*0
                                end as "인상된 급여"
from employees
where employee_id = &employee_id;

-- 8번
select d.department_id, d.department_name, l.city
from departments d, locations l
where d.location_id = l.location_id;

-- 9번
select employee_id, last_name, job_id
from employees
where department_id = (select department_id
                      from    departments
                      where   department_name = 'IT');
                      
-- 10번
select e.department_id, count(d.department_name), round(avg(e.salary))
from employees e, departments d
where e.department_id = d.department_id
group by e.department_id;

-- 11번
create table PROF (
    PROFNO number(4),
    NAME varchar2(15) not null,
    ID varchar2(15) not null,
    HIREDATE date,
    PAY number(4));

-- 12번
--(1)
insert into PROF
values (1001, 'Mark', 'm1001', to_date('07/03/01', yy/mm/dd), 800);
insert into PROF (PROFNO, NAME, ID, HIREDATE)
values (1003, 'Adam', 'a1003', '11/03/02');
commit;
--(2)
update PROF
set PAY = 1300
where PROFNO = 1001;
--(3)
delete PROF
where PROFNO = 1003;

-- 13번
--(1)
alter table PROF
add   constraint PROF_NO_PK primary key(PROFNO);
--(2)
alter table PROF
add         (gender char(3));
--(3)
alter table PROF
modify (name varchar2(20));

-- 14번
--(1)
create view prof_vu
  as select PROFNO as pno, NAME as pname, id
     from PROF;
--(2)
create or replace view prof_vu
  as select PROFNO as pno, NAME as pname, id, hiredate
     from PROF;

-- 15번
--(1)
drop table PROF purge;

