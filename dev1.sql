CREATE SEQUENCE reserve_seq
START WITH 100
INCREMENT BY 1
MINVALUE 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

create table test1(
test_1 varchar2(100) primary key);

INSERT INTO test1 (test_1) VALUES ( 'No_' || reserve_seq.nextval );
update room
set rooms_no = 605
where room_no =605;
alter table room
drop colum room_no;
alter table room
drop primary key cascade;
alter table room
modify (rooms_no number primary key);
alter table reserve
modify (room_no number);
select * from room;
select test_1 from test1;
ALTER TABLE members DROP Foreign Key cascade;

 create table reserve (
 reserve_no varchar2(100) primary key,
 customer_name varchar2(100) not null,
 check_in varchar2(100),
 check_out varchar2(100),
 payment number,
 room_no number,
 members_grade varchar2(100),
 foreign key (room_no) references room(rooms_no));
 
 select *
 from reserve;

select members_grade, members_discount,\r\n" + "room_price + (room_price*members_discount)
from reserve
where reserve_no = (select testSeq.currval from reserve);

 select re.reserve_no, re.customer_name, re.check_in, re.check_out,
 re.room_no, r.room_grade, r.room_price,
 m.members_grade, m.members_discount*100, 
 r.room_price-(r.room_price*m.members_discount)
 from reserve re, room r, members m
 where re.room_no = r.room_no
 and re.member_grade = m.member_grade;

select test_1
from test1;
select test_1
from test1
where rownum = (select rownum;
select test_1
from(select test_1 
    from test1
    order by rownum desc)
where rownum = 1;
ALTER TABLE RESERVE DROP MEMBERS_NO;
drop table reserve;

insert into test1 (test_1) values ('HRN' || reserve_seq.nextval);
select test_1
from test1;
select members_no, members_name
from members;
insert into test1 (test_1) 
values ('HRN' || reserve_seq.nextval);
where members_name = ;

alter table reserve
modify (CHECK_out VARCHAR2(100));

create table test2(
test_2 varchar2(100) primary key);

CREATE SEQUENCE members_seq
START WITH 100
INCREMENT BY 1
MINVALUE 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

select test_2
from(select test_2 
    from test2
    order by rownum desc)
where rownum = 1;

select case members_grade when  then '브라운'
from members;
select test_2
from test2;

select *
from members;

select *
from reserve;

select m.members_grade, m.members_discount, r.room_price + (r.room_price*m.members_discount)
from room r, members m
where room_no = (select testSeq.currval from reserve);

select r.room_price - (r.room_price*m.members_discount)
from room r, members m
where r.room_no = ?;

select *
from members;
select count(r.reserve_no)
from members m, reserve r
where m.members_no = r.members_no;

--안시조인으로 해보자. where문 넣고해서
select case m.members_grade when '브라운' then r.room_price - (r.room_price*0.03)
                          when '실버' then r.room_price - (r.room_price*0.05)
                          when '골드' then r.room_price - (r.room_price*0.07)
                          when '다이아몬드' then r.room_price - (r.room_price*0.10)
                          else r.room_price
                          end as "payment"
from room r, members m
where room_no = 505;

select room_price
from room
where room_no = (select room_no
from 

select *
from reserve;
create table grade (
 members_grade varchar2(100),
 lowest_stay number,
 highest_stay number;

select room_price
from room 
where room_no = 301;

select r.room_price-(r.room_price*m.members_discount)
from room r, members m, reserve re
where r.room_no = re.room_no
and re.members_grade = m.members_grade;

select re.reserve_no, re.customer_name, re.check_in, re.check_out, re.room_no, r.room_grade, r.room_price,
m.members_grade, m.members_discount, re.payment
from reserve re, room r, members m
where r.room_no = re.room_no
and re.members_grade = m.members_grade;