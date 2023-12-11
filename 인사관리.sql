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