select '고객님께서는 '||members_grade||'등급으로 ',
members_discount*100||'% 할인 적용되어',
room_price + (room_price*members_discount)||'원 결제되었습니다.\n감사합니다.'
from room, members
where room_no = ? ;

select room_price + (room_price*members_discount) as room_price
from room, members
where room_no = ? ;

insert into reserve
values(?, ?, ?, ?, ?, ?);


select members_grade, members_discount,
room_price + (room_price*members_discount)
from reserve
where reserve_no = (SELECT testSeq.CURRVAL FROM DUAL);

CREATE SEQUENCE reserve_seq
INCREMENT BY 1
MINVALUE 100
MAXVALUE 99999
NOCYCLE
NOCACHE;

 create table reserve (
 reserve_no varchar2(100) primary key,
 customer_name varchar2(100) not null,
 check_in date,
 check_out date,
 payment number(10,2),
 room_no varchar2(100),
 members_no varchar2(100));
 
 create table test1(
 test_1 varchar2(100) primary key,
 ghghgh varchar2(100),
 glglgl number);
 INSERT INTO testt (hkhkhk) VALUES ( 'No_' || reserve_seq.nextval );
 select *
 from testt;
 
 select re.reserve_no, re.reserve_name, re.check_in, re.check_out,
 re.room_no, r.room_grade, r.room_price,
 m.members_grade, m.members_discount*100, 
 r.room_price-(r.room_price*m.members_discount)
 from reserve re, room r, members m
 where re.room_no = r.room_no
 and re.member_no = m.member_no;