select department_id, department_name
from departments;

select last_name, department_name
from   employees, departments;

select count(*)
from departments;

-- ���̺� �̸����� ���ξ�� ������!
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

-- ���� ����
select worker.last_name || ' works for ' || manager.last_name
from employees worker, employees manager
where worker.manager_id = manager.employee_id;

-- ���⼭���� ANSI����
-- ���� ����
select last_name, department_name
from employees cross join departments;
-- �ڿ� ���� -�Ⱦ��°� ����.
select department_id, department_name, location_id, city
from departments natural join locations;
desc departments;
desc locations;
-- using �� ����
select employee_id, last_name, location_id,
       department_id
from   employees join departments 
                        using (department_id);
-- ���ǿ� �˸��ƽ� ����.
select l.city, d.department_name
from   locations l join departments d
                        using (location_id)
where  location_id = 1400;

-- ON �� ���� �߿�!
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

-- ANSI���ΰ� �ٸ��� ����Ŭ������ full �ƿ��� ������ ���������� �ʽ��ϴ�.
select e.last_name, e.department_id, d.department_name
from employees e full outer join departments d
        on (e.department_id = d.department_id);
-- �߰�����  and , where �Ѵ� ����   
select e.last_name, e.department_id, d.department_name
from   employees e join departments d
            on (e.department_id = d.department_id)
            and e.manager_id = 149;
select e.last_name, e.department_id, d.department_name
from   employees e join departments d
            on (e.department_id = d.department_id)
where  e.manager_id = 149;

--1. LOCATIONS �� COUNTRIES ���̺��� ����Ͽ� ��� �μ��� �ּҸ� �����ϴ� query�� �ۼ��Ͻÿ�. 
--��¿� ��ġID(location_id), �ּ�(street_address), ��/��(city), ��/��(state_province) �� ����(country_name)�� ǥ���Ͻÿ�.
select l.location_id, l.street_address, l.city, l.state_province, c.country_name
from locations l, countries c
where l.country_id = c.country_id;
--2. ��� ����� �̸�, �Ҽ� �μ���ȣ �� �μ� �̸��� ǥ���ϴ� query�� �ۼ��Ͻÿ�.
select e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id;
--3. Toronto�� �ٹ��ϴ� ����� ���� ������ �ʿ�� �մϴ�. 
--toronto���� �ٹ��ϴ� ��� ����� �̸�, ����, �μ���ȣ �� �μ� �̸��� ǥ���Ͻÿ�.
select e.last_name, e.job_id, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id
and d.location_id = 1800;

select e.last_name, e.job_id, e.department_id, d.department_name
from employees e, departments d, locations l
where e.department_id = d.department_id
and l.location_id = d.location_id
and lower(l.city) = 'toronto';
--4. ����� �̸� �� ��� ��ȣ�� �ش� �������� �̸� �� ������ ��ȣ�� �Բ� ǥ���ϴ� ������ �ۼ��ϴµ�, 
--�� ���̺��� ���� Employee, Emp#, Manager �� Mgr#���� �����Ͻÿ�.
select  worker.last_name as "Employee", worker.employee_id as "Emp#", 
        manager.last_name as "Manager", worker.manager_id as "Mgr#"
from    employees worker, employees manager
where   worker.manager_id = manager.employee_id;
--5. King�� ���� �ش� �����ڰ� �������� ���� ����� ǥ���ϵ��� 4�� ������ �����մϴ�. 
--��� ��ȣ������ ����� �����Ͻÿ�. 
select   worker.last_name as "Employee", worker.employee_id as "Emp#", 
         manager.last_name as "Manager", worker.manager_id as "Mgr#"
from     employees worker, employees manager
where    worker.manager_id = manager.employee_id(+)
order by worker.employee_id;
--6. ���� ��� �� �޿��� ���� ������ �ʿ�� �մϴ�. ���� JOB_GRADES ���̺��� ������ ǥ���� ���� ��� ����� �̸�, ����, �μ� �̸�, �޿� �� ����� ǥ���ϴ� query�� �ۼ��Ͻÿ�.
desc job_grades;
select *
from job_grades;
select e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
from employees e, departments d, job_grades j
where e.department_id = d.department_id
        and e.salary between j.lowest_sal and j.highest_sal;
    
    
-- ��������!
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

-- ����÷��� �����͸� �� �Է��Ҷ��� insert into�� ()�ȿ� �� �Է� ���ص��ȴ�.
insert into departments(department_id, department_name, manager_id, location_id)
values (370, 'Public Relations', 100, 1700);
insert into departments
values (371, 'Public Relations', 100, 1700);

-- Ư���÷��� �����͸� �Է��Ҷ��� insert into�� ()�ȿ� �� �Է� �ؾ���.
-- �Ͻ������� �ΰ��� �Է�.
insert into departments (department_id, department_name)
values (330, 'Purchasing');
-- ��������� �ΰ��� �Է�.
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

-- �⺻Ű�� ���� null�� �� �� ����.
-- �⺻Ű�� ���� ������ �� ����.
-- �ܷ�Ű�� 
insert into departments (department_id, department_name, manager_id)
values (130, 'YD', 100);
select *
from departments;

update employees
set    department_id = 51
where  employee_id = 113;

select *
from employees;
-- where ���� �߿���! �Ⱦ��� ��ü�ٲ�.
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

--1. Zlotkey�� ������ �μ��� ���� ��� ����� �̸��� �Ի����� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�. Zlotkey�� ������� �����Ͻÿ�.
select last_name, hire_date
from   employees
where  department_id = (select department_id
                       from    employees
                       where   lower(last_name) = 'zlotkey')
and    lower(last_name) <> 'zlotkey';
--2. �޿��� ��� �޿����� ���� ��� ����� ��� ��ȣ�� �̸��� ǥ���ϴ� ���Ǹ� �ۼ��ϰ� ����� �޿��� ���� ������������ �����Ͻÿ�.
select   employee_id, last_name
from     employees
where    salary > (select avg(salary)
                  from    employees)
order by salary;
--3. �̸��� u�� ���Ե� ����� ���� �μ����� ���ϴ� ��� ����� ��� ��ȣ�� �̸��� ǥ���ϴ� ���Ǹ� �ۼ��ϰ� ���Ǹ� �����Ͻÿ�.
select employee_id, last_name
from   employees
where  department_id in (select department_id
                        from    employees
                        where   lower(last_name) like ('%u%'));
--4. �μ� ��ġ ID(location_id)�� 1700�� ��� ����� �̸�, �μ� ��ȣ �� ���� ID�� ǥ���Ͻÿ�.
select last_name, department_id, job_id
from   employees
where  department_id in (select department_id
                        from    departments
                        where   location_id = 1700);
--5. King���� �����ϴ�(manager�� King) ��� ����� �̸��� �޿��� ǥ���Ͻÿ�.
select last_name, salary
from   employees
where  manager_id = (select employee_id
                     from    employees
                     where   lower(last_name) = 'king');
--6. Executive �μ��� ��� ����� ���� �μ� ��ȣ, �̸� �� ���� ID�� ǥ���Ͻÿ�.
select department_id, last_name, job_id
from   employees
where  department_id in (select department_id
                       from    departments
                       where   lower(department_name) = 'executive');
--7. ��� �޿����� ���� �޿��� �ް� �̸��� u�� ���Ե� ����� ���� �μ����� �ٹ��ϴ� ��� ����� ��� ��ȣ, �̸� �� �޿��� ǥ���Ͻÿ�.
select employee_id, last_name, salary
from   employees
where  department_id in (select department_id
                        from    employees
                        where   lower(last_name) like ('%u%'))
and    salary > (select avg(salary)
                from    employees);

--3. ���� ���� �����͸� MY_EMPLOYEE ���̺� �߰��Ͻÿ�.
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

--4. ���̺� �߰��� �׸��� Ȯ���Ͻÿ�.
select *
from   my_employee;
--6. ��� 3�� ���� Drexler�� �����Ͻÿ�.
update my_employee
set    last_name = 'Drexler'
where  id = 3; 
--7. �޿��� 900 �̸��� ��� ����� �޿��� 1000���� �����ϰ� ���̺��� ���� ������ Ȯ���Ͻÿ�.
update my_employee
set    salary = 1000
where  salary < 900;
select *
from   my_employee;
--8. MY_EMPLOYEE ���̺��� ��� 3�� �����ϰ� ���̺��� ���� ������ Ȯ���Ͻÿ�.
delete my_employee
where  id = 3;
select *
from   my_employee;
--11. ���̺��� ������ ��� �����ϰ� ���̺� ������ ��� �ִ��� Ȯ���Ͻÿ�.
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
--���� �������� Ÿ�Ժ���ȵ�.
alter table dept80
modify      (last_name number(15));

alter table dept80
drop        (job_id);

alter table dept80
set unused (last_name);
select *
from dept80;
-- unused �� Į������ ��� ������.
alter table dept80
drop unused columns;

drop table dept80;

select object_name, original_name, type
from user_recyclebin;

flashback table dept80 to before drop;
select *
from dept80;

drop table dept80 purge;

-- ������ ����
purge recyclebin;
-- ��ü �̸�����
rename dept to dept80;
-- ���̺� ����
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
-- table �������� ������ foreign key (Į����) references �θ����̺�(Į����)
-- colum �������� ������ deptid number(2) references dept_test(deptid)
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
-- not null ���������� modify�� �߰� ����
alter table emp_test
modify (duty not null);
select duty
from emp_test;
update emp_test
set duty = '1';

--�������� ����
select constraint_name, column_name
from   user_cons_columns;

desc user_cons_columns;

select constraint_name, table_name, column_name
from   user_cons_columns
where  table_name = 'EMP_TEST';

alter table emp_test
drop constraint SYS_C007022;

-- view(��)
create view empvu80
  as select employee_id, last_name, salary
     from   employees
     where  department_id = 80;

select *
from empvu80;

--��� ������ ���� or replace�� ����°͸� ����.
-- ������ ���� �����ҹ� �÷��˸��ƽ��� �����.
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






-- 1��
select employee_id, last_name, salary, department_id
from   employees
where  upper(last_name) like ('H%')
       and salary between 7000 and 12000;

-- 2��
select employee_id, last_name, to_char(hire_date, 'dd/mm/yyyy day'), to_char(salary*commission_pct,'$99,999.00') as incen
from employees
where commission_pct is not null
order by incen desc;

-- 3��
select employee_id, last_name, job_id, salary, department_id
from   employees
where  salary > 5000 
       and department_id in (50, 60);

-- 4��
select employee_id, last_name, department_id, case department_id when 20 then 'Canada'
                                                     when 80 then 'UK'
                                                    else 'USE'
                                                    end "�ٹ�����"
from employees;

-- 5��
select e.employee_id, e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

-- 6��
select last_name, hire_date, case  when >= 05 then 'New employee' 
                                   when < 05 then 'Career employee' 
from employees
where employee_id = &employee_id;

-- 7��
select employee_id, last_name, salary, case  when salary <= 5000 then salary*0.2
                                when salary <= 10000 then salary*0.15
                                when salary <= 15000 then salary*0.1
                                when salary >= 15001 then salary*0
                                end as "�λ�� �޿�"
from employees
where employee_id = &employee_id;

-- 8��
select d.department_id, d.department_name, l.city
from departments d, locations l
where d.location_id = l.location_id;

-- 9��
select employee_id, last_name, job_id
from employees
where department_id = (select department_id
                      from    departments
                      where   department_name = 'IT');
                      
-- 10��
select e.department_id, count(d.department_name), round(avg(e.salary))
from employees e, departments d
where e.department_id = d.department_id
group by e.department_id;

-- 11��
create table PROF (
    PROFNO number(4),
    NAME varchar2(15) not null,
    ID varchar2(15) not null,
    HIREDATE date,
    PAY number(4));

-- 12��
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

-- 13��
--(1)
alter table PROF
add   constraint PROF_NO_PK primary key(PROFNO);
--(2)
alter table PROF
add         (gender char(3));
--(3)
alter table PROF
modify (name varchar2(20));

-- 14��
--(1)
create view prof_vu
  as select PROFNO as pno, NAME as pname, id
     from PROF;
--(2)
create or replace view prof_vu
  as select PROFNO as pno, NAME as pname, id, hiredate
     from PROF;

-- 15��
--(1)
drop table PROF purge;

