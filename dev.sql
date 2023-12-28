create table board (
 board_no number primary key,
 title varchar2(100) not null,
 content varchar2(500) not null,
 writer varchar2(5) not null,
 writer_date date default sysdate,
 click_cnt number default 0,
 image varchar2(100)
);
alter table board
modify writer varchar2(50);

create sequence board_seq;
insert into board (board_no, title, writer, content)
values(board_seq.nextval, '첫번째 글', '홍길동', 'JSP 열심히 공부하자');
insert into board (board_no, title, writer, content)
values(board_seq.nextval, '오늘은 금요일', '김박사', '불코딩하자');
insert into board (board_no, title, writer, content)
values(board_seq.nextval, '우리반 화이팅!!', '김막내', '열심히 공부해요');

select *
from board;

select *
from student;
select *
from tab;

create table member (
 id varchar2(20) primary key,
 pw varchar2(10) not null,
 name varchar2(100) not null,
 responsibility varchar2(10) default 'User'
);

insert into member values('user1', '1111', '홍길동', 'User');
insert into member values('user2', '2222', '김철수', 'User');
insert into member values('user3', '3333', '관리자', 'Admin');
commit;

select * from member where id='user1' and pw='1111';

select * from member;
insert into member (id, pw, name)
	values('user10', '0000', '박민수');

delete from member where id = 'user10';

create table product (
 product_code char(8) primary key, -- P2023-01
 product_name varchar2(100) not null,
 product_desc varchar2(300) not null,
 origin_price number not null,
 sale_price number,
 like_it number default 3, --추천수
 image varchar2(50)
);

insert into product values('P2023-01', '과테말라 안티구아', '과테말라산 원두입니다.', 5000, 4500, 3, '과테말라.jpg');
insert into product values('P2023-02', '니카라구아 아라비카', '니카라구아산 원두입니다.', 5500, 4500, 4, '니카라구아 더치.jpg');
insert into product values('P2023-03', '브라질산토스', '브라질산 원두입니다.', 6000, 5000, 4, '브라질산토스.jpg');
insert into product values('P2023-04', '에티오피아 예가체프', '에티오피아산 원두입니다.', 4000, 3500, 5, '에티오피아 예가체프.jpg');
insert into product values('P2023-05', '케냐 오크라톡신', '케냐산 원두입니다.', 4500, 3000, 2, '케냐 오크라톡신.jpg');
insert into product values('P2023-06', '코스타리카 따라주', '코스타리카산 원두입니다.', 3500, 2500, 5, '코스타리카 따라주.jpg');

select * from product;

select * from(select *
from product
order by like_it desc)
where rownum in (1,2,3,4);