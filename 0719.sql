CREATE DATABASE naver_db;

CREATE TABLE sample_table (num INT);

DROP DATABASE IF EXISTS naver_db;
CREATE DATABASE naver_db;

USE naver_db;
DROP TABLE IF EXISTS member;
CREATE TABLE member(
mem_id		CHAR(8) NOT NULL PRIMARY KEY,
mem_name	VARCHAR(10) NOT NULL,
mem_number	TINYINT NOT NULL,
addr		CHAR(2) NOT NULL,
phone1		CHAR(3) NULL,
phone2		CHAR(8) NULL,
height		TINYINT UNSIGNED NULL,
debut_date	DATE NULL
);

DROP TABLE IF EXISTS buy;
CREATE TABLE buy(
num			INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
mem_id		CHAR(8) NOT NULL,
prod_name	CHAR(6) NOT NULL,
group_name 	CHAR(4) NULL,
price		INT UNSIGNED NOT NULL,
amount		SMALLINT UNSIGNED NOT NULL,
FOREIGN KEY(mem_id) REFERENCES member(mem_id)
);

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015-10-19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016-8-8');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015-1-15');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로', '디지털', 1000, 1);

USE naver_db;
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member(
	mem_id CHAR(8) NOT NULL PRIMARY KEY,
    mem_name VARCHAR(10) NOT NULL,
    height TINYINT UNSIGNED NULL);
    
DROP TABLE IF EXISTS member;
CREATE TABLE member(
mem_id CHAR(8) NOT NULL,
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED NULL,
PRIMARY KEY(mem_id));

DROP TABLE IF EXISTS member;
CREATE TABLE member(
mem_id CHAR(8) NOT NULL,
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED NULL);
ALTER TABLE member
	ADD CONSTRAINT
    PRIMARY KEY(mem_id);
    
# 기본 키에 이름저장
DROP TABLE IF EXISTS member;
CREATE TABLE member(
mem_id CHAR(8) NOT NULL,
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED NULL,
CONSTRAINT PRIMARY KEY PK_member_mem_id (mem_id));


DROP TABLE IF EXISTS buy, member;
CREATE TABLE member(
mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED NULL);
CREATE TABLE buy(
num			INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
mem_id		CHAR(8) NOT NULL,
prod_name	CHAR(6) NOT NULL,
FOREIGN KEY(mem_id) REFERENCES member(mem_id));

DROP TABLE IF EXISTS buy; 
CREATE TABLE buy(
num		INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
mem_id	CHAR(8) NOT NULL,
prod_name CHAR(6) NOT NULL);
ALTER TABLE buy
	ADD CONSTRAINT
    FOREIGN KEY(mem_id)
    REFERENCES member(mem_id);
    
INSERT INTO member VALUES('BLK', '블랙핑크', 163);
INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');

SELECT M.mem_id, M.mem_name, B.prod_name
	FROM buy B
    INNER JOIN member M
    ON B.mem_id = M.mem_id;
    
UPDATE member SET mem_id = 'PINK' WHERE mem_id = 'BLK';
DELETE FROM member WHERE mem_id='BLK';

DROP TABLE IF EXISTS buy; 
CREATE TABLE buy(
num		INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
mem_id	CHAR(8) NOT NULL,
prod_name CHAR(6) NOT NULL);
ALTER TABLE buy
	ADD CONSTRAINT
    FOREIGN KEY(mem_id)
    REFERENCES member(mem_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
    
INSERT INTO buy VALUES(NULL, 'BLK', '지갑');
INSERT INTO buy VALUES(NULL, 'BLK', '맥북');
UPDATE member SET mem_id = 'PINK' WHERE mem_id = 'BLK';

SELECT M.mem_id, M.mem_name, B.prod_name
	FROM buy B
		INNER JoIN member M
        ON B.mem_id = M.mem_id;
        
DELETE FROM member WHERE mem_id = 'PINK';

SELECT * FROM buy;

#기타 제약 조건
DROP TABLE IF EXISTS buy, member;
CREATE TABLE member(
mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED NULL,
email CHAR(30) NULL UNIQUE
);

INSERT INTO member VALUES('BLK', '블랙핑크', 163, 'pink@gmail.com');
INSERT INTO member VALUES('TWC', '트와이스', 167, NULL);
INSERT INTO member VALUES('APN', '에이핑크', 164, 'pink@gmail.com');

DROP TABLE IF EXISTS member;
CREATE TABLE member(
mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED NULL CHECK (height >= 100),
phone1 CHAR(3) NULL
);

INSERT INTO member VALUES('BLK', '블랙핑크', 163, NULL);
INSERT INTO member VALUES('TWC', '트와이스', 99, NULL);

ALTER TABLE member
	ADD CONSTRAINT
    CHECK (phone1 IN('02','031','032','054','055','061'));
    
INSERT INTO member VALUES('TWC', '트와이스', 167, '02');
INSERT INTO member VALUES('OMY', '오마이걸', 167, '010');

DROP TABLE IF EXISTS member;
CREATE TABLE member(
mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
height TINYINT UNSIGNED DEFAULT 160,
phone1 CHAR(3) NULL
);

ALTER TABLE member
	ALTER COLUMN phone1 SET DEFAULT '02';
    
INSERT INTO member VALUES('RED', '레드벨벳', 161, '054');
INSERT INTO member VALUES('SPC', '우주소녀', default, default);

SELECT * from member;