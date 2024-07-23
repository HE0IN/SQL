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

select mem_id "회원 아이디", sum(amount) "총 구매 개수" from buy group by mem_id;

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
    WHERE sum(price * amount) > 1000
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
    
drop table hongong1;
create table hongong1 (toy_id int, toy_name char(4), age int);
insert into hongong1 values (1, '우디', 25);



insert into hongong1 (toy_id, toy_name) values(2,'버즈');

insert into hongong1(toy_name, age, toy_id) values('제시', 20,3);

create table hongong2(
	toy_id int auto_increment primary key,
    toy_name char(4),
    age int);
drop table hongong2;

delete from hongong2 where toy_id = 2;
delete from buy where mem_id = 'BLK';

insert into hongong2 values (null, '보핍', 25);
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
    

SELECT * FROM city_popul WHERE city_name = '서울';


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

update city_populr
	set city_name = '뉴욕', population = 0
    where city_name = 'new york';
select * from city_popul where city_name = '뉴욕';

#update 구문은 where 없이 하지 않기 안그러면 모든 요소가 서울로 변함
-- update city_popul
-- 	set city_name = '서울';
    
update city_popul
	set population = population/10000;
select * from city_popul limit 10;

delete from city_popul
	where city_name like 'New%';
    
delete from city_popul
	where city_name like 'New%'
    limit 5;
    
#데이터를 지우는 방법
-- Delete from ~ ;     # 하나하나 삭제해서 오래걸림
-- drop table ~ ;		# 테이블 자체를 날려버림
-- truncate table ~ ;	# delete와 동일하지만 속도가 무척 빠름

use market_db;
create table hongong4 (
	tinyint_col TINYINT,
	smallint_col SMALLINT,
    int_col INT,
    bigint_col BIGINT);

insert into hongong4 values(127, 32767, 2147483647, 90000000000000000);
insert into hongong4 values(128, 32767, 2147483648, 90000000000000001);

create table member(
mem_id	char(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
mem_number INT NOT NULL,
addr CHAR(2) NOT NULL,
phone1 CHAR(3),
phone2 CHAR(8),
height SMALLINT UNSIGNED,
debut_date DATE);

create database netflix_db;

use netflix_db;
create table movie(
movie_id int,
movie_title varchar(30),
movie_director varchar(30),
movie_star varchar(30),
movie_script longtext,
movie_film longblob);

SET @변수이름 = 변수의 값;   #변수의 선언 값 대입
SELECT @변수이름;          #출력

USE market_db;
SET @myVar1 = 5;			
SET @myVar2 = 4.25;			#변수 선언 및 실수 대입

SELECT @myVar1;				#변수 내용 출력
SELECT @myVar1 + @myVar2;	#변수끼리 연산 후 출력

SET @txt = '가수 이름 ==>';	
SET @height = 166 ;			#변수 선언 후 문자열 및 정수 대입
SELECT @txt, mem_name FROM member WHERE height > @height ;	#테이블 조회하며 변수 사용

set @count = 3;
SELECT mem_name, height FROM member ORDER BY height LIMIT @count;

set @count = 3;
use market_db;
prepare mysql from 'select mem_name, height from member order by height limit ?';
execute mysql using @count;  # = select mem_name, height from member order by height limit 3;
select mem_name, height from member order by height limit 3;
select avg(price) as '평균가격' from buy;

select cast(avg(price) as signed) '평균 가격' from buy;
# = select convert(avg(price) signed) '평균 가격' from buy;

select cast('2022$12$12' as date);
select cast('2022/12/12' as date);
select cast('2022%12%12' as date);
select cast('2022@12@12' as date);

select num, concat(cast(price as char), 'x', cast(amount as char), '=')
	'가격x수량', price*amount '구매액'
    from buy;
    
select '100' + '200'; # 실행결과 = 300
select concat('100','200'); # 실행결과 = 100200
select concat(100, '200'); # 실행결과 = 100200
select 100 + '200'; # 실행결과 = 300


select *
	from buy
    inner join member
    on buy.mem_id = member.mem_id
    where buy.mem_id = 'GRL';
    
select *
	from buy
    inner join member
    on buy.mem_id = member.mem_id;
    
select buy.mem_id, mem_name, prod_name, addr, concat(phone1, phone) '연락처'
	from buy
    inner join member
    on buy.mem_id = member.mem_id;

select  buy.mem_id, member.mem_name, buy.prod_name, member.addr, concat(member.phone1, member.phone) '연락처'
	from buy
    inner join member
    on buy.mem_id = member.mem_id;

select B.mem_id, M.mem_name, B.prod_name, M.addr, concat(M.phone1, M.phone) '연락처'
	from buy B
    inner join member M
    on B.mem_id = M.mem_id;

select distinct M.mem_id, M.mem_name,M.addr
	from buy B
    inner join member M
    on B.mem_id = M.mem_id
	order by M.mem_id;

select M.mem_id, M.mem_name, B.prod_name, M.addr
	from member M
    left outer join buy b
    on M.mem_id = B.mem_id
	order by M.mem_id;

select M.mem_id, M.mem_name, B.prod_name, M.addr
	from buy B
    right outer join member M
    on M.mem_id = B.mem_id
	order by M.mem_id;
    
select distinct M.mem_id, B.prod_name, M.mem_name, M.addr
	from member M
    left outer join buy B
    on M.mem_id = B.mem_id
    where B.prod_name is null
    order by M.mem_id;
    
select *
from buy
cross join member;

select count(*) "데이터 개수"
	from sakila.inventory
		cross join world.city;
        
create table cross_table
	select *
		from sakila.actor
			cross join world.country;

select * from cross_table limit 5;

create table emp_table (emp char(4), manager char(4), phone varchar(8));
insert into emp_table values('대표', null, '0000');
insert into emp_table values('영업이사', '대표', '1111');
insert into emp_table values('관리이사', '대표', '2222');
insert into emp_table values('정보이사', '대표', '3333');
insert into emp_table values('영업과장', '영업이사', '1111-1');
insert into emp_table values('경리부장', '관리이사', '2222-1');
insert into emp_table values('인사부장', '관리이사', '2222-2');
insert into emp_table values('개발팀장', '정보이사', '3333-1');
insert into emp_table values('개발주임', '정보이사', '4444-1-1');

drop table emp_table;

select A.emp "직원", B.emp "직속상관", B.phone "직속상관 연락처"
	from emp_table A
		inner join emp_table B
        on a.manager = B.emp
	where A.emp = '경리부장';
    
DROP PROCEDURE IF EXISTS ifProc1;
DELIMITER $$
CREATE PROCEDURE ifProc1()
BEGIN
	IF 100 = 100 THEN
		SELECT '100은 100과 같습니다.';
	END IF;
END $$
DELIMITER ;
CALL ifProc1();

DROP PROCEDURE IF EXISTS ifProc2;
DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN
	DECLARE myNum INT;
    SET myNum = 200;
    IF myNum = 100 THEN
		SELECT '100입니다.';
	ELSE
		SELECT '100이 아닙니다.';
	END IF;
END $$
DELIMITER ;
CALL ifProc2();

DROP PROCEDURE IF EXISTS ifProc3;
DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
	DECLARE debutDate DATE;
    DECLARE curDate DATE;
    DECLARE days INT;
    SELECT debut_date INTO debutDate
		from market_db.member
        WHERE mem_id = 'APN';
	SET curDate = CURRENT_DATE();
    SET days = DATEDIFF(curDate, debutDate);
    IF(days/365) >= 5 THEN
        SELECT CONCAT('데뷔한 지 ', days, '일이나 지났습니다. 핑순이들 축하합니다!');
	ELSE
		SELECT CONCAT('데뷔한 지 ' , days , '일밖에 안되었네요. 핑순이들 화이팅 ~');
	END IF;
END $$
DELIMITER ;
CALL ifProc3();

SELECT CURRENT_DATE(), DATEDIFF('2021-12-31', '2000-1-1');

DROP PROCEDURE IF EXISTS caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
	DECLARE point INT;
    DECLARE credit CHAR(1);
    SET point = 88;
    
    CASE
		WHEN point >= 90 THEN
			SET credit = 'A';
		WHEN point >= 80 THEN
			SET credit = 'B';
		WHEN point >= 70 THEN
			SET credit = 'C';
		WHEN point >= 60 THEN
			SET credit = 'D';
		ELSE
			SET credit = 'F';
		END CASE;
        SELECT CONCAT('취득점수==>', point), CONCAT('학점==>', credit);
	END $$
    DELIMITER ;
    CALL caseProc();

select mem_id, SUM(price*amount) "총 구매액"
	FROM buy
	GROUP BY mem_id;
    
SELECT mem_id, SUM(price*amount) "총 구매액"
	FROM buy
	GROUP By mem_id
    ORDER BY SUM(price*amount) DESC;
    
SELECT B.mem_id, M.mem_name, SUM(price*amount) "총 구매액"
	FROM buy B
		INNER JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY B.mem_id
    ORDER BY SUM(price*amount) DESC;

SELECT M.mem_id, M.mem_name, SUM(price*amount) "총 구매액"
	FROM buy B
		RIGHT JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY M.mem_id
    ORDER BY SUM(price*amount) DESC;
    
SELECT M.mem_id, M.mem_name, SUM(price*amount) "총 구매액",
	CASE
	WHEN (SUM(price*amount) >= 1500) THEN '최우수고객'
	WHEN (SUM(price*amount) >= 1000) THEN '우수고객'
	WHEN (SUM(price*amount) >= 1) THEN '일반고객'
	ELSE '유령고객'
	END "회원 등급"
	FROM buy B
		RIGHT JOIN member M
        ON B.mem_id = M.mem_id
	GROUP BY M.mem_id
    ORDER BY SUM(price*amount) DESC;
    
DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
    SET i = 1;
    SET hap = 0;
    
    WHILE (i <= 100) DO
		SET hap = hap + i;
        SET i = i + 1;
	END WHILE;
    SELECT '1부터 100까지의 합 ==>', hap;
    END $$
    DELIMITER ;
    CALL whileProc();

DROP PROCEDURE IF EXISTS whileProc2;
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
	DECLARE i INT;
    DECLARE hap INT;
    SET i = 1;
    SET hap = 0;
    
    myWhile:
    WHILE (i <= 100) DO
		IF(i%4 = 0) THEN
        SET i = i + 1;
        ITERATE mywhile;
        
        END IF;
		SET hap = hap + i;
		IF(hap > 1000) THEN
			LEAVE mywhile;
		
        END IF;
        SET i = i + 1;
	END WHILE;
    SELECT '1부터 100까지의 합(4의 배수 제외), 1000 넘으면 종료 ==>', hap;
    END $$
    DELIMITER ;
    CALL whileProc2();

#동적 SQL
use market_db;
PREPARE myQuery FROM 'SELECT * FROM member WHERE mem_id = "BLK"';
EXECUTE myQuery;
DEALLOCATE PREPARE myQuery;

DROP TABLE IF EXISTS gate_table;
CREATE TABLE gate_table (id INT AUTO_INCREMENT PRIMARY KEY, entry_time DATETIME);
SET @curDate = CURRENT_TIMESTAMP();

PREPARE myQuery FROM 'INSERT INTO gate_table VALUES(NULL, ?)';
EXECUTE myQUery USING @curDate;
DEALLOCATE PREPARE myQuery;

SELECT * FROM gate_table;



CREATE DATABASE multiplication;
USE multiplication;
CREATE TABLE numbers1 (
    num1 INT
);
CREATE TABLE numbers2 (
    num2 INT
);
DROP TABLE numbers1;
INSERT INTO numbers1 (num1) VALUES (2), (3), (4), (5), (6), (7), (8), (9);
INSERT INTO numbers2 (num2) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9);
SELECT 
    n1.num1 AS "숫자 1", 
    n2.num2 AS "숫자 2", 
    (n1.num1 * n2.num2) AS "결과"
FROM 
    numbers1 n1
CROSS JOIN 
    numbers2 n2
ORDER BY 
    n1.num1, n2.num2;












DROP PROCEDURE IF EXISTS multiple_table;
DELIMITER $$
CREATE PROCEDURE multiple_table()
BEGIN
	DROP TABLE numbers1;
	DROP TABLE numbers2;
    
	CREATE TABLE numbers1 (num1 INT);
	CREATE TABLE numbers2 (num2 INT);
    
	INSERT INTO numbers1 (num1) VALUES (2), (3), (4), (5), (6), (7), (8), (9);
	INSERT INTO numbers2 (num2) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9);
    SELECT n1.num1 "단",  n2.num2 "곱해지는 수",  (n1.num1 * n2.num2) "구구단 결과"
		FROM 
			numbers1 n1
		CROSS JOIN 
			numbers2 n2
	ORDER BY 
		n1.num1, n2.num2;
END $$
DELIMITER ;
CALL multiple_table();
#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

DROP PROCEDURE IF EXISTS multiple;
DELIMITER $$
CREATE PROCEDURE multiple(IN input_num INT)
BEGIN
    DROP TABLE IF EXISTS numbers;
    CREATE TABLE numbers (num INT);

    INSERT INTO numbers (num) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9);
    SELECT input_num AS "단", num AS "곱해지는 수", (input_num * num) AS "구구단 결과"
    FROM numbers;
END$$
DELIMITER ;

CALL multiple(5);

#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

DROP PROCEDURE IF EXISTS multiple;
DELIMITER $$
CREATE PROCEDURE multiple(IN input_num INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DROP TABLE IF EXISTS numbers;
    CREATE TABLE numbers (num INT);

    WHILE i <= 9 DO
        INSERT INTO numbers (num) VALUES (i);
        SET i = i + 1;
    END WHILE;

    SELECT input_num AS "단", num AS "곱해지는 수", (input_num * num) AS "구구단 결과"
    FROM numbers;
END$$
DELIMITER ;

CALL multiple(5);

#ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
DROP PROCEDURE IF EXISTS multiple_table;
DELIMITER $$

CREATE PROCEDURE multiple_table(IN input_num INT)
BEGIN
    DROP TABLE IF EXISTS numbers1;
    DROP TABLE IF EXISTS numbers2;

    CREATE TABLE numbers1 (num1 INT);
    CREATE TABLE numbers2 (num2 INT);

    INSERT INTO numbers1 (num1) VALUES (2), (3), (4), (5), (6), (7), (8), (9);
    INSERT INTO numbers2 (num2) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9);

    SELECT n1.num1 AS "단", n2.num2 AS "곱해지는 수", (n1.num1 * n2.num2) AS "구구단 결과"
    FROM numbers1 n1
    CROSS JOIN numbers2 n2
    WHERE n1.num1 = input_num
    ORDER BY n2.num2;
END$$
DELIMITER ;

CALL multiple_table(7);

