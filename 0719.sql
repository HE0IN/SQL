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


use market_db;
CREATE VIEW v_member
AS
	SELECT mem_id, mem_name, addr FROM member;
SELECT * FROM v_member;

SELECT mem_name, addr FROM v_member
	WHERE addr IN ('서울', '경기');

SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, CONCAT(M.phone1, M.phone) '연락처'
	FROM buy B
		INNER JOIN member M
		ON B.mem_id = M.mem_id;

CREATE VIEW v_memberbuy
AS 
	SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, CONCAT(M.phone1, M.phone) '연락처'
	FROM buy B
		INNER JOIN member M
		ON B.mem_id = M.mem_id;

SELECT * FROM v_memberbuy WHERE mem_name = '블랙핑크';

CREATE VIEW v_viewtest1
AS
	SELECT B.mem_id 'Member ID', M.mem_name AS 'Member Name', B.prod_name "Product Name",
		CONCAT(M.phone1, M.phone) AS "office phone"
        FROM buy B
			INNER JOIN member M
            ON B.mem_id = M.mem_id;

SELECT * FROM v_viewtest1;

SELECT DISTINCT `Member ID`, `Member Name` FROM v_viewtest1;

ALTER VIEW v_viewtest1
AS
	SELECT B.mem_id '회원 아이디', M.mem_name AS '회원 이름', B.prod_name "제품 이름",
		CONCAT(M.phone1, M.phone) AS "연락처"
        FROM buy B
			INNER JOIN member M
            ON B.mem_id = M.mem_id;
SELECT DISTINCT `회원 아이디`, `회원 이름` FROM v_viewtest1;

DROP VIEW v_viewtest1;

CREATE OR REPLACE VIEW v_viewtest2
AS
	SELECT mem_id, mem_name, addr FROM member;

DESCRIBE v_viewtest2;
DESCRIBE member;

SHOW CREATE VIEW v_viewtest2;

UPDATE v_member SET addr = '부산' WHERE mem_id = 'BLK';

INSERT INTO v_member(mem_id, mem_name, addr) VALUES('BTS', '방탄소년단', '경기');

CREATE VIEW v_height167
AS
	SELECT * FROM member WHERE height >= 167;
SELECT * FROM v_height167;
DELETE FROM v_height167 WHERE height <167;

INSERT INTO v_height167 VALUES('TRA', '티아라', 6, '서울', NULL,NULL, 159, '2005-01-01');

SELECT * FROM v_height167;

ALTER VIEW v_height167
AS
	SELECT * FROM member WHERE height >= 167
			WITH CHECK OPTION;
            
INSERT INTO v_height167 VALUES('TOB', '텔레토비', 4, '영국', NULL,NULL, 140, '1995-01-01');

DROP TABLE IF EXISTS buy, member;

SELECT * FROM v_height167;

CHECK TABLE v_height167;

CREATE TABLE member(
mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
mem_number INT NOT NULL,
addr CHAR(2) NOT NULL,
phone1	CHAR(3),
phone2	CHAR(8),
height	SMALLINT,
debut_date DATE);

CREATE TABLE buy(
num	INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
mem_id CHAR(8) NOT NULL,
prod_name CHAR(6) NOT NULL,
group_name CHAR(4),
price INT NOT NULL,
amount SMALLINT NOT NULL,
FOREIGN KEY (mem_id) REFERENCES member(mem_id));

CREATE TABLE table1(
	col1 INT PRIMARY KEY,
    col2 INT ,
    col3 INT );

SHOW INDEX FROM table1;

CREATE TABLE table2(
	col1 INT PRIMARY KEY,
    col2 INT UNIQUE,
    col3 INT UNIQUE);

SHOW INDEX FROM table2;

DROP TABLE IF EXISTS buy, member;
CREATE TABLE member(
mem_id char(8),
mem_name VARCHAR(10),
mem_number INT,
addr CHAR(2));

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울');
SELECT * FROM member;

ALTER TABLE member
	ADD CONSTRAINT
    PRIMARY KEY (mem_id);
SELECT * FROM member;

ALTER TABLE member DROP PRIMARY KEY;
ALTER TABLE member
	ADD CONSTRAINT
    PRIMARY KEY(mem_name);
SELECT * FROM member;

INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울');
SELECT * FROM member;

DROP TABLE IF EXISTS member;
CREATE TABLE member(
mem_id CHAR(8),
mem_name VARCHAR(10),
mem_number INT,
addr CHAR(2));

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울');
SELECT * FROM member;

ALTER TABLE member
	ADD CONSTRAINT
    UNIQUE (mem_id);
SELECT * FROM member;

ALTER TABLE member
	ADD CONSTRAINT
    UNIQUE (mem_name);
SELECT * FROM member;

INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울');
SELECT * FROM member;

CREATE TABLE cluster(
mem_id		CHAR(8),
mem_name	VARCHAR(10));

INSERT INTO cluster VALUES('TWC', '트와이스');
INSERT INTO cluster VALUES('BLK', '블랙핑크');
INSERT INTO cluster VALUES('WMN', '여자친구');
INSERT INTO cluster VALUES('OMY', '오마이걸');
INSERT INTO cluster VALUES('GRL', '소녀시대');
INSERT INTO cluster VALUES('ITZ', '잇지');
INSERT INTO cluster VALUES('RED', '레드벨벳');
INSERT INTO cluster VALUES('APN', '에이핑크');
INSERT INTO cluster VALUES('SPC', '우주소녀');
INSERT INTO cluster VALUES('MMU', '마마무');

SELECT * FROM cluster;

ALTER TABLE cluster
	ADD CONSTRAINT
    PRIMARY KEY(mem_id);
    
SELECT * FROM cluster;

CREATE TABLE second(
mem_id		CHAR(8),
mem_name	VARCHAR(10));

INSERT INTO second VALUES('TWC', '트와이스');
INSERT INTO second VALUES('BLK', '블랙핑크');
INSERT INTO second VALUES('WMN', '여자친구');
INSERT INTO second VALUES('OMY', '오마이걸');
INSERT INTO second VALUES('GRL', '소녀시대');
INSERT INTO second VALUES('ITZ', '잇지');
INSERT INTO second VALUES('RED', '레드벨벳');
INSERT INTO second VALUES('APN', '에이핑크');
INSERT INTO second VALUES('SPC', '우주소녀');
INSERT INTO second VALUES('MMU', '마마무');

ALTER TABLE second
	ADD CONSTRAINT
    UNIQUE (mem_id);
SELECT * FROM second;

DROP TABLE member;

CREATE TABLE member
(mem_id char(8) not null primary key,
mem_name varchar(10) not null,
mem_nember int not null,
addr char(2) not null,
phone1 char(3),
phone char(8),
height smallint,
debut_date date);

ALTER TABLE member 
CHANGE COLUMN mem_nember mem_number INT NOT NULL,
CHANGE COLUMN phone phone2 CHAR(8);


INSERT INTO member VALUES('APN', '에이핑크', 6, '경기', '031', '77777777', 164, '2011.02.10');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016.08.08');
INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울', '02', '44444444', 168, '2007.08.02');
INSERT INTO member VALUES('ITZ', '잇지', 5, '경남', NULL, NULL, 167, '2019.02.12');
INSERT INTO member VALUES('MMU', '마마무', 4, '전남', '061', '99999999', 165, '2014.06.19');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울', NULL, NULL, 160, '2015.04.21');
INSERT INTO member VALUES('RED', '레드벨벳', 4, '경북', '054', '55555555', 161, '2014.08.01');
INSERT INTO member VALUES('SPC', '우주소녀', 13, '서울', '02', '88888888', 162, '2016.02.25');
insert into member values('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015.10.19');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015.01.15');

SELECT * FROM member;

SHOW INDEX FROM member;

SHOW TABLE STATUS LIKE 'member';

CREATE INDEX idx_member_addr
	ON member(addr);
    
SHOW INDEX FROM member;

SHOW TABLE STATUS LIKE 'member';

ANALYZE TABLE member;
SHOW TABLE STATUS LIKE 'member';

CREATE UNIQUE INDEX idx_member_mem_number
	ON member (mem_number);

CREATE UNIQUE INDEX idx_member_mem_name
	ON member(mem_name);

SHOW INDEX FROM member;

INSERT INTO member VALUES('MOO', '마마무', 2, '태국', '001', '12341234', 155, '2020-10-10');

ANALYZE TABLE member;
SHOW INDEX FROM member;

SELECT * FROM member;

SELECT mem_id, mem_name, addr FROM member;

SELECT mem_id, mem_name, addr
	FROM member
    WHERE mem_name = '에이핑크';
    
CREATE INDEX idx_member_mem_number
	ON member (mem_number);
ANALYZE TABLE member;

SELECT mem_name, mem_number
	FROM member
    WHERE mem_number >= 7;
    
SELECT mem_name, mem_number
	FROM member
    WHERE mem_number >= 1;

SELECT mem_name, mem_number
	FROM member
    WHERE mem_number*2 >= 14;
    
SELECT mem_name, mem_number
	FROM member
    WHERE mem_number >= 14/2;
    
    SHOW INDEX FROM member;
    
DROP INDEX idx_member_mem_name ON member;
DROP INDEX idx_member_addr ON member;
DROP INDEX idx_member_mem_number ON member;

ALTER TABLE member
	DROP PRIMARY KEY;
    
SELECT table_name, constraint_name
	FROM information_schema.referential_constraints
    WHERE constraint_schema = 'market_db';

ALTER TABLE buy
	DROP FOREIGN KEY buy_ibfk_1;
ALTER TABLE member
	DROP PRIMARY KEY;

DROP PROCEDURE IF EXISTS user_proc;
DELIMITER $$
CREATE PROCEDURE user_proc()
BEGIN
	SELECT * FROM member;
END $$
DELIMITER ;

CALL user_proc();

DROP PROCEDURE user_proc;

DROP PROCEDURE IF EXISTS user_proc1;
DELIMITER $$
CREATE PROCEDURE user_proc1(IN userName VARCHAR(10))
BEGIN
	SELECT * FROM member WHERE mem_name = userName;
END$$
DELIMITER ;

CALL user_proc1('에이핑크');

DROP PROCEDURE IF EXISTS user_proc2;
DELIMITER $$
CREATE PROCEDURE user_proc2(IN userNumber INT, IN userHeight INT)
BEGIN
	SELECT * FROM member
		WHERE mem_number > userNumber AND height > userHeight;
END$$
DELIMITER ;

CALL user_proc2(6, 165);

DROP PROCEDURE IF EXISTS user_proc3;
DELIMITER $$
CREATE PROCEDURE user_proc3(IN txtValue CHAR(10), OUT outValue INT)
BEGIN
	INSERT INTO noTable VALUES(NULL,txtValue);
    SELECT MAX(id) INTO outValue FROM noTable;
END$$
DELIMITER ;

DESC noTable;

CREATE TABLE IF NOT EXISTS noTable(
	id INT AUTO_INCREMENT PRIMARY KEY,
	txt CHAR(10));
    
CALL user_proc3 ('테스트', @myValue);
SELECT CONCAT('입력된 ID 값 ==>', @myValue);

DROP PROCEDURE IF EXISTS ifelse_proc;
DELIMITER $$
CREATE PROCEDURE ifelse_proc(
	IN memName VARCHAR(10)
    )
BEGIN
	DECLARE debutYear INT;
    SELECT YEAR(debut_date) into debutYear FROM member
		WHERE mem_name = memName;
	IF (debutYear >= 2015) THEN
		SELECT '신인 가수네요. 화이팅 하세요.' AS '메시지';
	else
		SELECT '고참 가수네요. 그동안 수고하셨어요.' AS '메시지';
	END IF;
END$$
DELIMITER ;

CALL ifelse_proc('오마이걸');

DROP PROCEDURE IF EXISTS while_proc;
DELIMITER $$
CREATE PROCEDURE while_proc()
BEGIN
	DECLARE hap INT;
    DECLARE num INT;
    SET hap = 0;
    SET num = 1;
	
    WHILE (num <= 100) DO
		SET hap = hap + num;
        SET num = num +1;
	END WHILE;
    SELECT hap AS '1 ~ 100 합계';
END$$
DELIMITER ;

CALL while_proc();

DROP PROCEDURE IF EXISTS dynamic_proc;
DELIMITER $$
CREATE PROCEDURE dynamic_proc(
	IN tableName VARCHAR(20)
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT * FROM ', tableName);
    PREPARE myQuery FROM @sqlQuery;
    EXECUTE myQuery;
    DEALLOCATE PREPARE myQuery;
END$$
DELIMITER ;

CALL dynamic_proc('member');

SET GLOBAL log_bin_trust_function_creators=1;

DROP FUNCTION IF EXISTS sumFunc;
DELIMITER $$
CREATE FUNCTION sumFunc(number1 INT, number2 INT)
	RETURNS INT
BEGIN
	RETURN number1 + number2;
END $$
DELIMITER ;

SELECT sumFunc(100, 200) AS '합계';

DROP FUNCTION IF EXISTS calcYearFunc;
DELIMITER $$
CREATE FUNCTION calcYearFunc(dYear INT)
	RETURNS INT
BEGIN
	DECLARE runYear INT;
    SET runYear = YEAR(CURDATE()) - dYear;
    RETURN runYear;
END $$
DELIMITER ;

SELECT calcYearFunc(2010) AS '활동 햇수';

SELECT calcYearFunc(2007) INTO @debut2007;
SELECT calcYearFunc(2013) INTO @debut2013;
SELECT @debut2007-@debut2013 AS '2007과 2013 차이';

SELECT mem_id, mem_name, calcYearFunc(YEAR(debut_date)) AS '활동 햇수'
	FROM member;
    
SHOW CREATE FUNCTION calcYearFunc;

DROP FUNCTION calcYearFunc;

DECLARE memNumber INT;
DECLARE cnt INT DEFAULT 0;
DECLARE totNumber INT DEFAULT 0;
DECLARE end0fRow BOOLEAN DEFAULT FALSE;

DECLARE membarCursor CURSOR FOR
	SELECT mem_number FROM member;

DECLARE CONTINUE HANDLER
	FOR NOT FOUND SET end0fRow = TRUE;
    
OPEN memberCursor;

IF end0fRow THEN
	LEAVE cursor_loop;
END IF

cursor_loop: LOOP
	FETCH memberCursor INTO memNumber;
    IF end0fRow THEN
		LEAVE cursor_loop;
	END IF;
    
    SET cnt = cnt + 1;
    SET totNumber = totNumber + memNumber;
END LOOP cursor_loop;

SELECT (totNumber/cnt) AS '회원의 평균 인원 수';

CLOSE memberCursor

DROP PROCEDURE IF EXISTS cursor_proc;
DELIMITER $$
CREATE PROCEDURE cursor_proc()
BEGIN
	DECLARE memNumber INT;
	DECLARE cnt INT DEFAULT 0;
	DECLARE totNumber INT DEFAULT 0;
	DECLARE end0fRow BOOLEAN DEFAULT FALSE;

	DECLARE memberCursor CURSOR FOR
		SELECT mem_number FROM member;
	
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET end0fRow = TRUE;
        
	OPEN memberCursor;
    
    cursor_loop: LOOP
		FETCH memberCursor INTO memNumber;
		IF end0fRow THEN
			LEAVE cursor_loop;
		END IF;
		
		SET cnt = cnt + 1;
		SET totNumber = totNumber + memNumber;
	END LOOP cursor_loop;
    
    SELECT (totNumber/cnt) AS '회원의 평균 인원 수';
    CLOSE memberCursor;
END $$
DELIMITER ;

CALL cursor_proc();

CREATE TABLE IF NOT ExISTS trigger_table (id INT, txt VARCHAR(10));
INSERT INTO trigger_table VALUES(1, '레드벨벳');
INSERT INTO trigger_table VALUES(2, '잇지');
INSERT INTO trigger_table VALUES(3, '블랙핑크');

DROP TRIGGER IF EXISTS myTrigger;
DELIMITER $$
CREATE TRIGGER myTrigger
	AFTER DELETE
    ON trigger_table
    FOR EACH ROW
BEGIN
	SET @msg = '가수 그룹이 삭제됨';
END $$
DELIMITER ;

SET @msg = '';
INSERT INTO trigger_table VALUES(4, '마마무');
SELECT @masg;
UPDATE trigger_table SET txt = '블핑' WHERE id = 3;
SELECT @masg;

DELETE FROM trigger_table WHERE id = 4;
SELECT @msg;

CREATE TABLE singer (SELECT mem_id, mem_name, mem_number, addr FROM member);

CREATE TABLE backup_singer(
	mem_id		CHAR(8) NOT NULL,
    mem_name	VARCHAR(10) NOT NULL,
    mem_number	INT NOT NULL,
    addr		CHAR(2) NOT NULL,
    modType		CHAR(2),
    modDate		DATE,
    modUser		VARCHAR(30));
    
DROP TRIGGER IF EXISTS singer_updateTrg;
DELIMITER $$
CREATE TRIGGER singer_updateTrg
	AFTER UPDATE
    ON singer
    FOR EACH ROW
BEGIN
	INSERT INTO backup_singer VALUES( OLD.mem_id, OLD.mem_name, OLD.mem_number, 
											OLD.addr, '수정', CURDATE(), CURRENT_USER() );
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS singer_deleteTrg;
DELIMITER $$
CREATE TRIGGER singer_deleteTrg
	AFTER DELETE
	ON singer
    FOR EACH ROW
BEGIN
	INSERT INTO backup_singer VALUES( OLD.mem_id, OLD.mem_name, OLD.mem_number, 
											OLD.addr, '삭제', CURDATE(), CURRENT_USER() );
END $$
DELIMITER ;

UPDATE singer SET addr = '영국' WHERE mem_id = 'BLK';
DELETE FROM singer WHERE mem_number >= 7;

SELECT * FROM backup_singer;

TRUNCATE TABLE singer;

SELECT * FROM backup_singer;












