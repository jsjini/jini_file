select * from tab;

create table student (
 student_no varchar2(10) primary key,
 student_name varchar2(100) not null,
 eng number default 80,
 math number default 70);

--등록, 수정, 삭제, 단건조회, 목록
--등록
insert into student (student_no, student_name, eng, math)
values      ('23-001', '홍길동', 70, 75);
insert into student (student_no, student_name)--, eng, math)
values      ('23-005', '김철수');
--수정
update student
set    eng = 85, math = 75
where  student_no = '23-002';
--삭제
delete from student where student_no = '23-002';
--단건조회
select *
from student where student_no = '23-002';
--목록
select *
from   student
order by 1;

delete from student where student_name = '';

-- 북테이블
create table book (
 book_no varchar2(10) primary key,
 book_title varchar2(100) not null,
 author varchar2(10),
 press varchar2(10),
 price number);
 
alter table book
rename COLUMN book_price to price;
insert into book
values      ('B001', '이것이 자바다', '신용권', '이지스', 30000);
insert into book
values      ('C003', 'Oracle 기초', '고경희', '개발', 38000);
insert into book
values      ('D001', 'CSS 고급', '김용권', '퍼블리싱', 58000);

select *
from book;

