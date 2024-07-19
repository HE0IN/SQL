CREATE SCHEMA test_db;
use test_db;

create table member
(mem_id char(8) not null primary key,
mem_name varchar(10) not null,
mem_number int not null,
addr char(2) not null,
phone1 char(3),
phone2 char(8),
height smallint,
debut_date date);

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

drop table member;
drop table buy;

create table buy

(num int auto_increment not null primary key,
mem_id char(8) not null,
prod_name char(6) not null,
group_name char(4),
price int not null,
amount smallint not null,
foreign key (mem_id) references member(mem_id));

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

ALTER TABLE member
CHANGE COLUMN mem_nember mem_number int;

select * from member;
select * from buy;

# 문제1) 구매 금액이 1000원 이상인 회원 이름과 구매물품명, 구매 금액을 조회하시오.
SELECT M.mem_name "회원 이름", B.prod_name "구매물품명" , B.price* B.amount "구매 금액"
	FROM member M
		INNER JOIN buy B ON M.mem_id = B.mem_id
	WHERE (B.price*B.amount) >= 1000;
    
SELECT mem_name, prod_name, SUM(price * amount) 'price'
FROM buy B
INNER JOIN member M
ON B.mem_id = M.mem_id
GROUP BY mem_name, prod_name
HAVING SUM(price * amount) >= 1000;

# 문제2) 구매 분류가 디지털인 항목을 구매한 회원 명, 전화번호, 구매분류, 물품명, 구매금액을 조회하시오.
SELECT M.mem_name "그룹이름", concat(M.phone1, '-' ,M.phone2) "전화번호", B.group_name "구매분류", B.prod_name "물품명", B.price "구매금액"
	FROM member M
		INNER JOIN buy B ON M.mem_id = B.mem_id
	WHERE B.group_name = '디지털';

# 문제3) 인원이 6명 이상인 회원이 구매한 물품, 회원명, 회원수, 구매금액을 가격 높은순으로 조회하시오.
SELECT B.prod_name "구매한 물품", M.mem_name "그룹이름", M.mem_number "회원 수", B.price "구매 금액"
    FROM member M
		INNER JOIN buy B ON M.mem_id = B.mem_id
	WHERE M.mem_number >= 6
	ORDER BY B.price DESC;

# 문제4) 가장 비싼 단가를 가진 물품을 구매한 회원의 회원명, 구매단가, 구매물품, 국번전화번호, 평균키, 데뷔일자를 구하시오. 국번 전화번호의 값은 중간에 '-'으로 연결, 나온 결과값의 정렬은 데뷔 일자가 가장 빠른 순으로 구하시오.
SELECT M.mem_name "회원 명", B.price "구매 금액", B.prod_name "구매한 물품", concat(M.phone1, '-', M.phone2) "전화번호",
		M.height "평균 키", M.debut_date "데뷔 일자"
    FROM member M
		INNER JOIN buy B ON M.mem_id = B.mem_id
	WHERE B.price = (SELECT max(price) FROM buy)
    ORDER BY M.debut_date;

# 문제5) 키가 165 이하이고 총 구매 금액이 500이 넘는 회원의 회원 아이디, 회원 키, 총구매 금액을 총 구매 수량이 많은 순으로 탑 3까지 조회
SELECT M.mem_id "회원 아이디", M.height "회원 키", SUM(B.price * B.amount) "총 구매 금액"
    FROM member M
		INNER JOIN buy B ON M.mem_id = B.mem_id
    	GROUP BY M.mem_id
        HAVING M.height <= 165 and SUM(B.price * B.amount) > 500
    ORDER BY SUM(B.amount) DESC
    limit 3;

# 문제6) 서울 출생이고 구매하지 않는 회원의 회원 아이디, 데뷔일자를 데뷔 일자가 빠른 순으로 탑 2까지 조회
SELECT M.mem_id "회원 아이디", M.debut_date "데뷔 일자"
	FROM member M
		LEFT JOIN buy B 
        ON M.mem_id = B.mem_id
	WHERE M.addr = '서울' AND B.prod_name IS NULL
	ORDER BY M.debut_date
	limit 2;

# 문제7) 아이즈원은 거제 출생이고, 폰은 없다. 평균키는 170이며 데뷔 날짜 및 멤버수는 검색, ID는 IVE 이다. 아이즈원은 청바지워 에어팟을 각 3개씩 샀다. insert 하시오.
INSERT INTO member VALUES('IVE', '아이즈원', 12,'거제', NULL, NULL, 170, '2018.10.29');
INSERT INTO buy VALUES(NULL, 'IVE', '에어팟', '디지털', 80, 3);
INSERT INTO buy VALUES(NULL, 'IVE', '청바지', '패션', 50, 3);

# 문제8) 마마무가 자신들의 평균키가 166이라고 정정해달라는 요청이 왔다. 이를 UPDATE 하시오.
UPDATE member
	SET height = 166
    WHERE mem_name = '마마무';


# 문제9) 멤버 이름이 4글자인 멤버의 총 평균 키를 조회하시오.
SELECT AVG(height) "멤버 이름이 4글자인 멤버의 총 평균 키"
	FROM member
    WHERE CHAR_LENGTH(mem_name) = 4;
    

SELECT mem_name AS "멤버 이름", height AS "키", NULL AS "평균 키"
FROM member
UNION ALL
SELECT '전체 평균' AS "멤버 이름", NULL AS "키", AVG(height) AS "평균 키"
FROM member;

# 문제10) 서적이 모두 환불 되었습니다. 서적을 구매한 회원 네임과 멤버의 전화번호, 환불한 총 구매 금액을 조회하시오.
SELECT M.mem_name "회원 이름", CONCAT(M.phone1, '-', M.phone2) "전화번호", SUM(B.price * B.amount) "환불한 총 금액"
	FROM member M
		INNER JOIN buy B ON M.mem_id = B.mem_id
	WHERE B.group_name = '서적'
    GROUP BY
		M.mem_id;
        
        
