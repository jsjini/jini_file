-- 룸 테이블
create table room (
room_no varchar2(100) primary key,
room_grade varchar2(100) not null,
room_floor number not null,
room_view varchar2(100) not null,
room_price number not null);

-- 회원 테이블
create table members (
members_no varchar2(100) primary key,
members_grade varchar2(100),
members_name varchar2(100) not null,
members_tel varchar2(100) not null,
members_area varchar2(100) not null,
members_discount number(10,2));

-- 예약 테이블
create table reserve (
reserve_no varchar2(100) primary key,
customer_name varchar2(100) not null,
check_in date,
check_out date,
payment number(10,2),
room_no varchar2(100),
members_grade varchar2(100),
foreign key (room_no) references room(room_no));

-- 101호부터 605호까지 총 34개 객실 생성 
insert into room
values ('101', '스탠다드', 1, '산', 150000);

-- reserve_no 에 들어갈 번호만드는 시퀀스 생성
CREATE SEQUENCE reserve_seq
START WITH 100
INCREMENT BY 1
MINVALUE 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

-- 시퀀스에서 번호를 받아서 reserve_no 에 들어갈 값만드는 테이블 생성
create table test1(
test_1 varchar2(100) primary key);

-- reserve_no 에 들어갈 값 생성. HRN = (Hotel Reserve Number의 약어)
insert into test1 (test_1) values ( 'HRN' || reserve_seq.nextval );

-- 시퀀스에서 번호를 받아서 members_no 에 들어갈 값만드는 테이블 생성
create table test2(
test_2 varchar2(100) primary key);

-- members_no 에 들어갈 번호만드는 시퀀스 생성
CREATE SEQUENCE members_seq
START WITH 100
INCREMENT BY 1
MINVALUE 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

-- members_no 에 들어갈 값 생성. HMN = (Hotel Member Number의 약어)
insert into test2 (test_2) values ('HMN' || members_seq.nextval);
