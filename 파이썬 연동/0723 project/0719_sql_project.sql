CREATE DATABASE sql_project;

use sql_project;

drop table buy;
drop table member;

CREATE TABLE member
(mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
mem_number INT NOT NULL,
addr CHAR(2) NOT NULL,
phone1 CHAR(3),
phone2 CHAR(8),
height SMALLINT,
debut_date DATE
);

INSERT INTO member (mem_id, mem_name, mem_number, addr, phone1, phone2, height, debut_date) VALUES
('APN', '에이핑크', 6, '경기', '031', '77777777', 164, '2011-02-10'),
('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016-08-08'),
('GRL', '소녀시대', 8, '서울', '02', '44444444', 168, '2007-08-02'),
('ITZ', '잇지', 5, '경남', NULL, NULL, 167, '2019-02-12'),
('MMU', '마마무', 4, '전남', '061', '99999999', 165, '2014-06-19'),
('OMY', '오마이걸', 7, '서울', NULL, NULL, 160, '2015-04-21'),
('RED', '레드벨벳', 4, '경북', '054', '55555555', 161, '2014-08-01'),
('SPC', '우주소녀', 13, '서울', '02', '88888888', 162, '2016-02-25'),
('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015-10-19'),
('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015-01-15');

CREATE TABLE query_options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    query TEXT NOT NULL
);

-- 데이터베이스 선택
USE sql_project;

-- query_options 테이블 생성 (존재하지 않는 경우)
CREATE TABLE IF NOT EXISTS query_options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255),
    query TEXT
);

-- query_options 테이블에 데이터 삽입
INSERT INTO query_options (description, query) VALUES
('① 구매 금액이 1000원 이상인 회원 이름과 구매 물품명, 구매 금액을 조회 하시오.',
 'SELECT M.mem_name "회원 이름", B.pro_name "제품 이름", (B.price * B.amount) AS "구매 금액" FROM buy B INNER JOIN member M ON B.mem_id = M.mem_id WHERE (B.price * B.amount) >= 1000;'),
('② 구매 분류가 디지털인 항목을 구매한 회원 명, 전화번호, 구매분류, 물품명, 구매금액을 조회하시오.',
 'SELECT M.mem_name "회원 이름", CONCAT(M.phone1, "-", M.phone2) AS "전화번호", B.group_name "분류", B.pro_name "제품 이름", (B.price * B.amount) AS "구매 금액" FROM buy B INNER JOIN member M ON B.mem_id = M.mem_id WHERE B.group_name = "디지털";'),
('③ 인원이 6명 이상인 회원이 구매한 물품, 회원명, 회원수, 구매금액을 가격 높은순으로 조회 하시오.',
 'SELECT B.pro_name "제품 이름", M.mem_name "회원 이름", M.mem_number "회원 수", (B.price * B.amount) AS "구매 금액" FROM buy B INNER JOIN member M ON B.mem_id = M.mem_id WHERE M.mem_number >= 6 ORDER BY (B.price * B.amount) DESC;'),
('④ 가장 비싼 단가를 가진 물품을 구매한 회원의 회원명, 구매단가, 구매물품, 국번전화번호, 평균키, 데뷔 일자를 구하시오.',
 'SELECT M.mem_name "회원 이름", B.price "단가", B.pro_name "제품 이름", CONCAT(M.phone1, "-", M.phone2) "전화번호", M.height "회원 키", M.debut_date "데뷔 날짜" FROM buy B INNER JOIN member M ON B.mem_id = M.mem_id ORDER BY B.price DESC, M.debut_date LIMIT 1;'),
('⑤ 키가 165 이하이고 총 구매 금액이 500이 넘는 회원의 회원 아이디, 회원 키, 총구매 금액을 총 구매 수량이 많은 순으로 탑3 까지 조회',
 'SELECT M.mem_id "회원 아이디", M.height "회원 키", SUM(B.price * B.amount) AS "총 구매 금액" FROM buy B INNER JOIN member M ON B.mem_id = M.mem_id WHERE M.height <= 165 GROUP BY M.mem_id, M.height HAVING SUM(B.price * B.amount) > 500 ORDER BY SUM(B.amount) DESC LIMIT 3;'),
('⑥ 서울 출생이고 구매하지 않는 회원의 회원 아이디, 데뷔일자를 데뷔 일자가 빠른 순으로 탑2 까지 조회',
 'SELECT M.mem_id "회원 아이디", M.debut_date "데뷔 날짜" FROM member M LEFT JOIN buy B ON M.mem_id = B.mem_id WHERE M.addr = "서울" AND B.mem_id IS NULL ORDER BY M.debut_date LIMIT 2;'),
('⑦ 아이즈원은 거제 출생이고, 폰은 없다. 평균키는 170이며 데뷔 날짜및 멤버수는 검색, ID는 IVE 이다. 아이즈 원은 청바지와 에어팟을 각 3개씩 샀다. insert 하세요.',
 'INSERT INTO member (mem_id, mem_name, mem_number, addr, height, debut_date) VALUES ("IVE", "아이즈원", 12, "거제", 170, "2018-10-29") ON DUPLICATE KEY UPDATE mem_name = VALUES(mem_name), mem_number = VALUES(mem_number), addr = VALUES(addr), height = VALUES(height), debut_date = VALUES(debut_date); INSERT INTO buy (mem_id, pro_name, group_name, price, amount) VALUES ("IVE", "청바지", "패션", 50, 3), ("IVE", "에어팟", "디지털", 80, 3);'),
('⑧ 마마무가 자신들의 평균키가 166이라고 정정해달라는 요청이 왔다. 이를 update 하시오.',
 'UPDATE member SET height = 166 WHERE mem_name = "마마무";'),
('⑨ 멤버 이름이 4글자인 멤버의 총 평균 키를 조회하시오.',
 'SELECT mem_name "회원 이름", AVG(height) AS "평균 키" FROM member WHERE CHAR_LENGTH(mem_name) = 4 GROUP BY mem_name;'),
('⑩ 서적이 모두 환불 되었습니다. 서적을 구매한 회원 네임과 멤버의 전화번호, 환불할 총 구매 금액을 조회 하시오.',
 'SELECT M.mem_name "회원 이름", CONCAT(M.phone1, "-", M.phone2) AS "전화번호", SUM(B.price * B.amount) AS "환불 총 금액" FROM buy B INNER JOIN member M ON B.mem_id = M.mem_id WHERE B.group_name = "서적" GROUP BY M.mem_name, M.phone1, M.phone2;');



CREATE TABLE buy
(num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
mem_id CHAR(8) NOT NULL,
pro_name CHAR(6) NOT NULL,
group_name CHAR(4),
price INT NOT NULL,
amount SMALLINT NOT NULL,
FOREIGN KEY (mem_id) REFERENCES member(mem_id)
);

INSERT INTO buy (mem_id, pro_name, group_name, price, amount) VALUES
('twc', '지갑', NULL, 30, 2),
('BLK', '맥북프로', '디지털', 1000, 1),
('APN', '아이폰', '디지털', 200, 1),
('MMU', '아이폰', '디지털', 200, 5),
('BLK', '청바지', '패션', 50, 3),
('MMU', '에어팟', '디지털', 80, 10),
('GRL', '혼공SQL', '서적', 15, 5),
('APN', '혼공SQL', '서적', 15, 2),
('APN', '청바지', '패션', 50, 1),
('MMU', '지갑', NULL, 30, 1),
('APN', '혼공SQL', '서적', 15, 1),
('MMU', '지갑', NULL, 30, 4);