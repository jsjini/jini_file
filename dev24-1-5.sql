-- 댓글(댓글번호, 게시글번호, 내용, 작성자, 작성일시)
create table reply (
    reply_no number primary key,
    board_no number not null,
    reply varchar2(100) not null,
    replyer varchar2(30) not null,
    reply_date date default sysdate
);
create sequence reply_seq;
insert into reply (reply_no, board_no, reply, replyer)
values (reply_seq.nextval, 3, '안녕', '전상진');
insert into reply (reply_no, board_no, reply, replyer)
values (reply_seq.nextval, 3, '안녕2', '전상진');
insert into reply (reply_no, board_no, reply, replyer)
values (reply_seq.nextval, 3, '안녕3', '도승민');
insert into reply (reply_no, board_no, reply, replyer)
values (reply_seq.nextval, 4, '나도안녕', '도승민');
insert into reply (reply_no, board_no, reply, replyer)
values (reply_seq.nextval, 4, '나도안녕2', '최승민');
insert into reply (reply_no, board_no, reply, replyer)
values (reply_seq.nextval, 4, '나도안녕3', '김현준');
insert into reply (reply_no, board_no, reply, replyer)
values (reply_seq.nextval, 7, '나도안녕', '박지웅');

select *
from reply r, board b
where b.board_no = r.board_no and b.board_no = 3 ;
select *
from reply
where board_no = 3
order by 1;

select name
from member;

select m.name
from reply r
join member m
on r.replyer = m.id
where board_no = 3 order by 1;

select r.*, m.name
  	from reply r
  	join member m
  	on r.replyer = m.id
  	where reply_no = 39;
    
select *
from reply
order by 1;


select *
from reply
where board_no = 3
order by 1;

-- 댓글 페이징.
select b.* from
(select rownum rn, a. * from
(
select r.*, m.name
from reply r
join member m
on r.replyer = m.id
where board_no = 3
order by 1 desc
) a ) b
where b.rn > (2-1)*5 and b.rn <= 2*5;

insert into reply
values (reply_seq.nextval, 4, '테스트', 'user5', sysdate);

select b.* from
	(select rownum rn, a. * from
	(
	select r.*, m.name
	from reply r
	join member m
	on r.replyer = m.id
	where board_no = 3
	order by 1 desc
	) a ) b
	where b.rn > (1-1)*5 and b.rn <= 1*5;

select count(*) from reply where board_no = 3;
delete from reply where reply_no = '6';

select * from reply;
select * from member;

select replyer, count(*)
from reply
group by replyer;

insert into member values('user5', '5555', '김사랑', 'User');

select name, count(*)
from reply r
join member m
on r.replyer = m.id
group by name;