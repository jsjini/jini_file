create table room (
 room_no varchar2(100) primary key,
 room_grade varchar2(100) not null,
 room_floor number not null,
 room_view varchar2(100) not null,
 room_price number not null,
 room_state varchar2(100) default 'empty');

 create table members (
 members_no varchar2(100) primary key,
 members_grade varchar2(100) default '일반',
 members_name varchar2(100) not null ,
 members_tel varchar2(100) not null,
 members_area varchar2(100) not null,
 members_discount number(10,2));
 
 create table reserve (
 reserve_no varchar2(100) primary key,
 customer_name varchar2(100) not null,
 check_in date,
 check_out date,
 payment number(10,2),
 room_no varchar2(100),
 members_no varchar2(100),
 foreign key (room_no) references room(room_no),
 foreign key (members_no) references members(members_no));
 
select *
from room;

update room
set room_state = 'empty'
where room_no = '101호';

update room
set room_no =   '605'
where room_no = '605호';

insert into room
values ('604호','프리미어',6,'바다',300000,'empty');
insert into room
values ('605호','로열 스위트',6,'바다',1500000,'empty');

select count(room_state)
from room
where room_grade = '스탠다드'
and room_state = 'empty';

select room_no, room_floor, room_view, to_char(room_price, '9,999,999') room_price
from room
where room_grade= '스위트'
and room_state = 'empty';

select room_grade
from room
where room_no = ?