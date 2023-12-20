-- �� ���̺�
create table room (
room_no varchar2(100) primary key,
room_grade varchar2(100) not null,
room_floor number not null,
room_view varchar2(100) not null,
room_price number not null);

-- ȸ�� ���̺�
create table members (
members_no varchar2(100) primary key,
members_grade varchar2(100),
members_name varchar2(100) not null,
members_tel varchar2(100) not null,
members_area varchar2(100) not null,
members_discount number(10,2));

-- ���� ���̺�
create table reserve (
reserve_no varchar2(100) primary key,
customer_name varchar2(100) not null,
check_in date,
check_out date,
payment number(10,2),
room_no varchar2(100),
members_grade varchar2(100),
foreign key (room_no) references room(room_no));

-- 101ȣ���� 605ȣ���� �� 34�� ���� ���� 
insert into room
values ('101', '���Ĵٵ�', 1, '��', 150000);

-- reserve_no �� �� ��ȣ����� ������ ����
CREATE SEQUENCE reserve_seq
START WITH 100
INCREMENT BY 1
MINVALUE 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

-- ���������� ��ȣ�� �޾Ƽ� reserve_no �� �� ������� ���̺� ����
create table test1(
test_1 varchar2(100) primary key);

-- reserve_no �� �� �� ����. HRN = (Hotel Reserve Number�� ���)
insert into test1 (test_1) values ( 'HRN' || reserve_seq.nextval );

-- ���������� ��ȣ�� �޾Ƽ� members_no �� �� ������� ���̺� ����
create table test2(
test_2 varchar2(100) primary key);

-- members_no �� �� ��ȣ����� ������ ����
CREATE SEQUENCE members_seq
START WITH 100
INCREMENT BY 1
MINVALUE 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

-- members_no �� �� �� ����. HMN = (Hotel Member Number�� ���)
insert into test2 (test_2) values ('HMN' || members_seq.nextval);
