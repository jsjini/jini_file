select * from tab;

create table student (
 student_no varchar2(10) primary key,
 student_name varchar2(100) not null,
 eng number default 80,
 math number default 70);

--���, ����, ����, �ܰ���ȸ, ���
--���
insert into student (student_no, student_name, eng, math)
values      ('23-001', 'ȫ�浿', 70, 75);
insert into student (student_no, student_name)--, eng, math)
values      ('23-005', '��ö��');
--����
update student
set    eng = 85, math = 75
where  student_no = '23-002';
--����
delete from student where student_no = '23-002';
--�ܰ���ȸ
select *
from student where student_no = '23-002';
--���
select *
from   student
order by 1;

delete from student where student_name = '';

-- �����̺�
create table book (
 book_no varchar2(10) primary key,
 book_title varchar2(100) not null,
 author varchar2(10),
 press varchar2(10),
 price number);
 
alter table book
rename COLUMN book_price to price;
insert into book
values      ('B001', '�̰��� �ڹٴ�', '�ſ��', '������', 30000);
insert into book
values      ('C003', 'Oracle ����', '�����', '����', 38000);
insert into book
values      ('D001', 'CSS ���', '����', '�ۺ���', 58000);

select *
from book;

