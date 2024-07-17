use market_db;
create table member
(mem_id char(8) not null primary key,
mem_name varchar(10) not null,
mem_nember int not null,
addr char(2) not null,
phone1 char(3),
phone char(8),
height smallint,
debut_date date);

create table buy
(num int auto_increment not null primary key,
mem_id char(8) not null,
prod_name char(6) not null,
group_name char(4),
price int not null,
amount smallint not null,
foreign key (mem_id) references member(mem_id));

insert into member values('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015.10.19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016.08.08');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015.01.15');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울', NULL, NULL, 160, '2015.04.21');
INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울', '02', '44444444', 168, '2007.08.02');
INSERT INTO member VALUES('ITZ', '잇지', 5, '경남', NULL, NULL, 167, '2019.02.12');
INSERT INTO member VALUES('RED', '레드벨벳', 4, '경북', '054', '55555555', 161, '2014.08.01');
INSERT INTO member VALUES('APN', '에이핑크', 6, '경기', '031', '77777777', 164, '2011.02.10');
INSERT INTO member VALUES('SPC', '우주소녀', 13, '서울', '02', '88888888', 162, '2016.02.25');
INSERT INTO member VALUES('MMU', '마마무', 4, '전남', '061', '99999999', 165, '2014.06.19');

-- delete from member where mem_id = 'BLK';
-- delete from buy where mem_id = 'BLK';
-- delete from buy where mem_id = 'twc';

INSERT INTO buy VALUES(NULL, 'twc', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy VALUES(NULL, 'APN', '아이폰', '디지털', 200, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '아이폰', '디지털', 200, 5);
INSERT INTO buy VALUES(NULL, 'BLK', '청바지', '패션', 50, 3);
INSERT INTO buy VALUES(NULL, 'MMU', '에어팟', '디지털', 80, 10);
INSERT INTO buy VALUES(NULL, 'GRL', '혼공SQL', '서적', 15, 5);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 2);
INSERT INTO buy VALUES(NULL, 'APN', '청바지', '패션', 50, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 1);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 4);

DROP TABLE buy;
DROP TABLE member;

-- select * from buy;

use market_db;
select * from member;

-- select 			# 열 이름
-- 	from			# 테이블 이름
--     where		# 조건식
--     group by		# 열 이름
--     having		# 조건식
--     order by		# 열 이름
--     limit		# 숫자

SELECT * FROM market_db.member;
select * from member;             #이 두개는 동일함 보통 데이터베이스를 생략

select mem_name from member;         #한 개의 열을 가져옴 
select addr, debut_date, mem_name from member;  #여러개를 가져오려면 ','로 더 작성
select addr 주소, debut_date "데뷔일자", mem_name from member; #별칭을 적을 수 도 있음

select * from member where mem_name ='블랙핑크';

ALTER TABLE member
CHANGE COLUMN mem_nember mem_number INT;

select * 
	from member
	where mem_number = 4;

select mem_id, mem_name
	from member
    where height <= 162;

select mem_name, height, mem_number
	from member
    where height >= 165 and mem_number >6;

select mem_name,height,  mem_number
	from member
    where height >= 165 or mem_number > 6;

select mem_name, height
	from member
    where height >= 163 and height <= 165;


select mem_name, height
	from member
    where height between 163 and 165;


select mem_name, addr
	from member
    where addr = '경기' or addr = '전남' or addr = '경남';

select mem_name, addr
	from member
    where addr in('경기', '전남', '경남');

select *
	from member
    where mem_name Like '우%';

select *
	from member
    where mem_name like '__핑크';

select height from member where mem_name = '에이핑크';
select mem_name, height from member where height > 164;

select mem_name, height from member
	where height > (select height from member where mem_name = '에이핑크');

select mem_id, mem_name, debut_date
	from member
	order by debut_date;

select mem_id, mem_name, debut_date
	from member
	order by debut_date desc;

select mem_id, mem_name, debut_date
	from member
	where height >= 164
    order by debut_date desc;


select mem_id, mem_name, debut_date
	from member
	where height >= 164
    order by height desc, debut_date asc;

select *
	from member
    limit 3;


select mem_name, debut_date
	from member
    order by debut_date
    limit 3;


select mem_name, height
	from member
    order by height desc
    limit 3, 2;

select addr from member;

select addr from member order by addr;

select distinct addr from member;

select mem_id, amount from buy order by mem_id;

select mem_id, sum(amount) from buy group by mem_id;

select mem_id "회원 아이디", sum(price*amount) "총 구매 금액"
	from buy group by mem_id;

select avg(amount) "평균 구매 개수" from buy;


select mem_id, AVG(amount) "평균 구매 개수" 
	from buy
    group by mem_id;

select count(*) from member;

select count(phone1) "연락처가 있는 회원" from member;

select mem_id "회원 아이디", sum(price*amount) "총 구매 금액"
	from buy
    group by mem_id;
    
select mem_id "회원 아이디", sum(price*amount) "총 구매 금액"
	from buy
    group by mem_id
    having sum(price * amount) > 1000;
    

select mem_id "회원 아이디", sum(price*amount) "총 구매 금액"
	from buy
    group by mem_id
    having sum(price * amount) > 1000
    order by sum(price*amount) desc;

create table hongong1 (toy_id int, toy_name char(4), age int);
drop table hongong1;
insert into hongong1 values (1, '우디', 25);

insert into hongong1 (toy_id, toy_name) values(2,'버즈');

insert into hongong1(toy_name, age, toy_id) values('제시', 20,3);

create table hongong2(
	toy_id int auto_increment primary key,
    toy_name char(4),
    age int);
drop table hongong2;
insert into hongong2 values (null, '보핍', 25);
delete from hongong2 where toy_id = 2;
delete from buy where mem_id = 'BLK';
insert into hongong2 values (null, '슬링키', 22);
insert into hongong2 values (null, '렉스', 21);
select * from hongong2;

select last_insert_id();

alter table hongong2 auto_increment = 100;
insert into hongong2 values (null, '재남', 35);
select * from hongong2;

create table hongong3(
	toy_id int auto_increment primary key,
    toy_name char(4),
    age int);
    
alter table hongong3 auto_increment = 1000;
set @@auto_increment_increment = 3;

insert into hongong3 values (null, '토마스', 20);
insert into hongong3 values (null, '제임스', 23);
insert into hongong3 values (null, '고든', 25);
select * from hongong3;

#insert into hongong3 values(null, '토마스', 20),(null, '제임스', 23),(null, '고든', 25); 도 가능

select count(*) from world.city;

select * from world.city limit 5;
select * from world.city;
create table city_popul (city_name char(35), population int);
insert into city_popul values ('서울', 9981619);
insert into city_popul
	select name, population from world.city;

update city_popul
	set city_name = '서울'
    where city_name = 'Seoul';
    
select * from city_popul where city_name = '서울';

SELECT * FROM city_popul WHERE city_name = '서울';

insert into hongong1 values (1, '우디', 25);

WITH ranked_city AS (
    SELECT 
        city_name, 
        population,
        ROW_NUMBER() OVER (PARTITION BY city_name, population ORDER BY city_name) AS rnk
    FROM city_popul
)
DELETE FROM city_popul
WHERE (city_name, population) IN (
    SELECT city_name, population FROM ranked_city WHERE rnk > 1
);

update city_popul
	set city_name = '뉴욕', population = 0
    where city_name = 'new york';
select * from city_popul where city_name = '뉴욕';

update city_popul
	set city_name = '서울';
    
update city_popul
	set population = population/10000;
select * from city_popul limit 10;

delete from city_popul
	where city_name like 'New%';
    
delete from city_popul
	where city_name like 'New%'
    limit 5;