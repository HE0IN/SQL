import sys
import os
from PyQt5.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout, QComboBox, QTableWidget,
    QTableWidgetItem, QPushButton, QTextEdit, QLabel, QMessageBox, QHeaderView
)
from PyQt5.QtCore import Qt
import pymysql

# 커스텀 콤보박스 클래스
class CustomComboBox(QComboBox):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setFixedWidth(700)  # 콤보박스의 너비 고정
        self.setFixedHeight(45)  # 콤보박스의 높이 고정

# 메인 애플리케이션 클래스
class App(QWidget):
    def __init__(self):
        super().__init__()
        self.title = 'PYQT5를 이용한 GUI 응용 프로그램'
        self.left = 100
        self.top = 100
        self.width = 800
        self.height = 400
        self.initUI()
    
    # UI 초기화 메서드
    def initUI(self):
        # 기본 UI 설정
        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)
        
        main_layout = QVBoxLayout()  # 메인 레이아웃
        main_layout.setContentsMargins(50, 20, 10, 20)  # 상하좌우 패딩 설정
        
        # 배경 색상 설정
        self.setStyleSheet("background-color: white;")
        
        # 콤보박스와 조회 버튼을 위한 레이아웃
        combo_layout = QHBoxLayout()
        combo_layout.setContentsMargins(0, 0, 0, 0)  # 콤보박스 레이아웃 패딩 설정
        combo_layout.setAlignment(Qt.AlignLeft)

        # 콤보박스 설정
        self.combo_box = CustomComboBox(self)
        self.combo_box.addItems([
            "① 구매 금액이 1000원 이상인 회원 이름과 구매 물품명, 구매 금액을 조회 하시오.",
            "② 구매 분류가 디지털인 항목을 구매한 회원 명, 전화번호, 구매분류, 물품명, 구매금액을 조회하시오.",
            "③ 인원이 6명 이상인 회원이 구매한 물품, 회원명, 회원수, 구매금액을 가격 높은순으로 조회 하시오.",
            "④ 가장 비싼 단가를 가진 물품을 구매한 회원의 회원명, 구매단가, 구매물품, 국번전화번호, 평균키, 데뷔 일자를 구하시오.",
            "⑤ 키가 165 이하이고 총 구매 금액이 500이 넘는 회원의 회원 아이디, 회원 키, 총구매 금액을 총 구매 수량이 많은 순으로 탑3 까지 조회",
            "⑥ 서울 출생이고 구매하지 않는 회원의 회원 아이디, 데뷔일자를 데뷔 일자가 빠른 순으로 탑2 까지 조회",
            "⑦ 아이즈원은 거제 출생이고, 폰은 없다. 평균키는 170이며 데뷔 날짜및 멤버수는 검색, ID는 IVE 이다. 아이즈 원은 청바지와 에어팟을 각 3개씩 샀다. insert 하세요.",
            "⑧ 마마무가 자신들의 평균키가 166이라고 정정해달라는 요청이 왔다. 이를 update 하시오.",
            "⑨ 멤버 이름이 4글자인 멤버의 총 평균 키를 조회하시오.",
            "⑩ 서적이 모두 환불 되었습니다. 서적을 구매한 회원 네임과 멤버의 전화번호, 환불할 총 구매 금액을 조회 하시오."
        ])
        self.combo_box.currentIndexChanged.connect(self.load_query)
        
        self.combo_box.setStyleSheet(f"""
            QComboBox {{
                border: 1px solid blue;
                padding: 5px 10px;
                font-size: 12px;
                color: blue;
                font-weight: bold;
            }}

            QComboBox::drop-down {{
                subcontrol-origin: padding;
                subcontrol-position: top right;
                width: 30px;
                border-left-width: 1px;
                border-left-color: white;
                border-left-style: solid;
                border-top-right-radius: 3px;
                border-bottom-right-radius: 3px;
                background-color: white;
            }}

            QComboBox::down-arrow {{
                image: url({'C:/Users/duddl/OneDrive/SQL/파이썬 연동/0723 project/image.png'});
                width: 30px;
                height: 30px;
            }}
            
            /* 클릭 이펙트 제거 */
            QComboBox::drop-down:pressed {{
                background-color: transparent;
            }}

            QComboBox::down-arrow:on {{
                top: 0px; /* 클릭했을 때 위치 변경을 제거 */
                left: 0px;
            }}
        """)

        combo_layout.addWidget(self.combo_box)
        
        # 조회 버튼 설정
        self.query_button = QPushButton('조회', self)
        self.query_button.clicked.connect(self.execute_query)
        self.query_button.setStyleSheet("border: 1px solid black; font-weight: bold;")
        self.query_button.setFixedWidth(150)  # 조회 버튼 가로 길이
        self.query_button.setFixedHeight(35)  # 조회 버튼 세로 길이
        combo_layout.addWidget(self.query_button)

        main_layout.addLayout(combo_layout)
        
        # SQL 쿼리 섹션
        query_layout = QHBoxLayout()
        query_layout.setContentsMargins(0, 20, 0, 20)  # 쿼리 레이아웃 패딩 설정
        query_layout.setAlignment(Qt.AlignLeft)  # 쿼리 레이아웃을 왼쪽 정렬로 설정

        self.query_text = QTextEdit(self)
        self.query_text.setStyleSheet("border: 1px solid blue;")  # 테두리 파란색 설정
        self.query_text.setFixedWidth(700)  # 쿼리 박스 가로 길이
        self.load_query()  # 초기 쿼리 로드
        query_layout.addWidget(self.query_text)

        # 버튼 레이아웃
        button_layout = QVBoxLayout()
        button_layout.setContentsMargins(0, 0, 0, 0)  # 버튼 레이아웃 패딩 설정
        button_layout.setAlignment(Qt.AlignTop)

        buttons = [
            ('입력', self.execute_insert_query),
            ('수정', self.execute_update_query),
            ('member 테이블 조회', self.view_member_table),
            ('member 테이블 삭제', self.delete_member_table),
            ('member 테이블 생성', self.create_member_table),
            ('member 데이터 입력', self.insert_member_data),
            ('buy 테이블 조회', self.view_buy_table),
            ('buy 테이블 삭제', self.delete_buy_table),
            ('buy 테이블 생성', self.create_buy_table),
            ('buy 데이터 입력', self.insert_buy_data)
        ]
        for text, method in buttons:
            button = QPushButton(text, self)
            button.clicked.connect(method)
            button.setStyleSheet("border: 1px solid black; font-weight: bold;")
            button.setFixedWidth(150)
            button.setFixedHeight(35)
            button_layout.addWidget(button)

        query_layout.addLayout(button_layout)
        main_layout.addLayout(query_layout)

        # 결과 테이블 섹션
        self.table_widget = QTableWidget()
        self.table_widget.setAlternatingRowColors(True)
        self.table_widget.setStyleSheet("""
            QTableWidget {
                border: 1px solid white;
                gridline-color: white;
                font-size: 14px;
            }
            QTableWidget::item {
                padding: 5px;
                background-color: #e6f7ff; /* 홀수 행 배경색 */
            }
            QTableWidget::item:alternate {
                background-color: #cceeff; /* 짝수 행 배경색 */
            }
            QHeaderView::section {
                background-color: #3e6f9e; /* 헤더 배경색 */
                color: white; /* 헤더 텍스트 색상 */
                border: 1px solid white;
                font-weight: bold;
            }
            QTableCornerButton::section {
                background-color: #3e6f9e; /* 코너 버튼 배경색 */
                border: 1px solid white;
            }
        """)
        self.table_widget.setFixedWidth(700)  # 테이블 가로 길이
        self.table_widget.setFixedHeight(200)  # 테이블 세로 길이
        self.table_widget.verticalHeader().setVisible(False)  # 인덱스 번호 숨기기
        self.table_widget.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)  # 열 너비를 동일하게 설정
        main_layout.addWidget(self.table_widget)

        self.setLayout(main_layout)
    
    # 쿼리 로드 메서드
    def load_query(self):
        index = self.combo_box.currentIndex()
        queries = [
            """
            SELECT M.mem_name "회원 이름", B.pro_name "제품 이름", (B.price * B.amount) AS '구매 금액'
            FROM buy B
            INNER JOIN member M ON B.mem_id = M.mem_id
            WHERE (B.price * B.amount) >= 1000;
            """,
            """
            SELECT M.mem_name "회원 이름", CONCAT(M.phone1, '-', M.phone2) AS '전화번호', B.group_name "분류", B.pro_name "제품 이름", (B.price * B.amount) AS '구매 금액'
            FROM buy B
            INNER JOIN member M ON B.mem_id = M.mem_id
            WHERE B.group_name = '디지털';
            """,
            """
            SELECT B.pro_name "제품 이름", M.mem_name "회원 이름", M.mem_number "회원 수", (B.price * B.amount) AS '구매 금액'
            FROM buy B
            INNER JOIN member M ON B.mem_id = M.mem_id
            WHERE M.mem_number >= 6
            ORDER BY (B.price * B.amount) DESC;
            """,
            """
            SELECT M.mem_name "회원 이름", B.price "단가", B.pro_name "제품 이름", CONCAT(M.phone1, '-', M.phone2) "전화번호", M.height "회원 키", M.debut_date "데뷔 날짜"
            FROM buy B
            INNER JOIN member M ON B.mem_id = M.mem_id
            ORDER BY B.price DESC, M.debut_date
            LIMIT 1;
            """,
            """
            SELECT M.mem_id "회원 아이디", M.height "회원 키", SUM(B.price * B.amount) AS '총 구매 금액'
            FROM buy B
            INNER JOIN member M ON B.mem_id = M.mem_id
            WHERE M.height <= 165
            GROUP BY M.mem_id, M.height
            HAVING SUM(B.price * B.amount) > 500
            ORDER BY SUM(B.amount) DESC
            LIMIT 3;
            """,
            """
            SELECT M.mem_id "회원 아이디", M.debut_date "데뷔 날짜"
            FROM member M
            LEFT JOIN buy B ON M.mem_id = B.mem_id
            WHERE M.addr = '서울' AND B.mem_id IS NULL
            ORDER BY M.debut_date
            LIMIT 2;
            """,
            """
            INSERT INTO member (mem_id, mem_name, mem_number, addr, height, debut_date) VALUES
            ('IVE', '아이즈원', 12, '거제', 170, '2018-10-29')
            ON DUPLICATE KEY UPDATE
            mem_name = VALUES(mem_name),
            mem_number = VALUES(mem_number),
            addr = VALUES(addr),
            height = VALUES(height),
            debut_date = VALUES(debut_date);
            INSERT INTO buy (mem_id, pro_name, group_name, price, amount) VALUES
            ('IVE', '청바지', '패션', 50, 3),
            ('IVE', '에어팟', '디지털', 80, 3);
            """,
            """
            UPDATE member
            SET height = 166
            WHERE mem_name = '마마무';
            """,
            """
            SELECT mem_name "회원 이름", AVG(height) AS '평균 키'
            FROM member
            WHERE CHAR_LENGTH(mem_name) = 4
            GROUP BY mem_name;
            """,
            """
            SELECT M.mem_name "회원 이름", CONCAT(M.phone1, '-', M.phone2) AS '전화번호', SUM(B.price * B.amount) AS '환불 총 금액'
            FROM buy B
            INNER JOIN member M ON B.mem_id = M.mem_id
            WHERE B.group_name = '서적'
            GROUP BY M.mem_name, M.phone1, M.phone2;
            """
        ]
        self.query_text.setPlainText(queries[index])

    # 조회 쿼리 실행 메서드
    def execute_query(self):
        query = self.query_text.toPlainText().strip()
        if query:
            self.run_query(query)
            QMessageBox.information(self, "Query Executed", "조회 쿼리가 성공적으로 실행되었습니다.")

    # 입력 쿼리 실행 메서드
    def execute_insert_query(self):
        queries = self.query_text.toPlainText().split(';')
        success = False
        for query in queries:
            query = query.strip()
            if query.startswith("INSERT"):
                self.run_query(query)
                success = True
        if success:
            QMessageBox.information(self, "Query Executed", "입력 쿼리가 성공적으로 실행되었습니다.")
        else:
            QMessageBox.warning(self, "Invalid Query", "입력 쿼리가 아닙니다.")

    # 수정 쿼리 실행 메서드
    def execute_update_query(self):
        queries = self.query_text.toPlainText().split(';')
        success = False
        for query in queries:
            query = query.strip()
            if query.startswith("UPDATE"):
                self.run_query(query)
                success = True
        if success:
            QMessageBox.information(self, "Query Executed", "수정 쿼리가 성공적으로 실행되었습니다.")
        else:
            QMessageBox.warning(self, "Invalid Query", "수정 쿼리가 아닙니다.")

    # 데이터 존재 여부 확인 메서드
    def check_table_data(self, table_name):
        query = f"SELECT COUNT(*) AS cnt FROM {table_name}"
        try:
            connection = pymysql.connect(
                host='localhost',
                user='root',
                password='0000',
                db='sql_project',
                charset='utf8',
                cursorclass=pymysql.cursors.DictCursor
            )
            with connection.cursor() as cursor:
                cursor.execute(query)
                result = cursor.fetchone()
                return result['cnt']
        except pymysql.MySQLError as e:
            QMessageBox.critical(self, "Query Execution Error", f"Error executing query: {e}")
            return 0
        finally:
            connection.close()

    # member 테이블 조회 메서드
    def view_member_table(self):
        member_count = self.check_table_data('member')
        if member_count == 0:
            QMessageBox.information(self, "Empty Table", "member 테이블에 데이터가 없습니다.")
        else:
            self.run_query("SELECT * FROM member")
            QMessageBox.information(self, "Query Executed", "member 테이블 조회가 성공적으로 실행되었습니다.")

    # member 테이블 삭제 메서드
    def delete_member_table(self):
        buy_count = self.check_table_data('buy')
        member_count = self.check_table_data('member')
        if buy_count > 0:
            QMessageBox.warning(self, "Cannot Delete", "buy 테이블의 데이터 때문에 member 테이블을 삭제할 수 없습니다.")
        elif member_count == 0:
            QMessageBox.information(self, "Empty Table", "member 테이블에 데이터가 없습니다.")
        else:
            self.run_query("DROP TABLE IF EXISTS member")
            QMessageBox.information(self, "Query Executed", "member 테이블 삭제가 성공적으로 실행되었습니다.")

    # member 테이블 생성 메서드
    def create_member_table(self):
        create_table_query = """
        CREATE TABLE IF NOT EXISTS member (
            mem_id VARCHAR(255) PRIMARY KEY,
            mem_name VARCHAR(255),
            mem_number INT,
            addr VARCHAR(255),
            height FLOAT,
            debut_date DATE,
            phone1 VARCHAR(10),
            phone2 VARCHAR(10)
        )
        """
        self.run_query(create_table_query)
        QMessageBox.information(self, "Query Executed", "member 테이블 생성이 성공적으로 실행되었습니다.")

    # member 데이터 입력 메서드
    def insert_member_data(self):
        insert_query = """
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
        ('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015-01-15')
        ON DUPLICATE KEY UPDATE
        mem_name = VALUES(mem_name),
        mem_number = VALUES(mem_number),
        addr = VALUES(addr),
        phone1 = VALUES(phone1),
        phone2 = VALUES(phone2),
        height = VALUES(height),
        debut_date = VALUES(debut_date);
        """
        self.run_query(insert_query)
        QMessageBox.information(self, "Query Executed", "member 데이터 입력이 성공적으로 실행되었습니다.")

    # buy 테이블 조회 메서드
    def view_buy_table(self):
        buy_count = self.check_table_data('buy')
        if buy_count == 0:
            QMessageBox.information(self, "Empty Table", "buy 테이블에 데이터가 없습니다.")
        else:
            self.run_query("SELECT * FROM buy")
            QMessageBox.information(self, "Query Executed", "buy 테이블 조회가 성공적으로 실행되었습니다.")

    # buy 테이블 삭제 메서드
    def delete_buy_table(self):
        buy_count = self.check_table_data('buy')
        if buy_count == 0:
            QMessageBox.information(self, "Empty Table", "buy 테이블에 데이터가 없습니다.")
        else:
            self.run_query("DROP TABLE IF EXISTS buy")
            QMessageBox.information(self, "Query Executed", "buy 테이블 삭제가 성공적으로 실행되었습니다.")

    # buy 테이블 생성 메서드
    def create_buy_table(self):
        create_table_query = """
        CREATE TABLE IF NOT EXISTS buy (
            mem_id VARCHAR(255),
            pro_name VARCHAR(255),
            group_name VARCHAR(255),
            price FLOAT,
            amount INT,
            FOREIGN KEY (mem_id) REFERENCES member(mem_id)
        )
        """
        self.run_query(create_table_query)
        QMessageBox.information(self, "Query Executed", "buy 테이블 생성이 성공적으로 실행되었습니다.")

    # buy 데이터 입력 메서드
    def insert_buy_data(self):
        insert_query = """
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
        """
        self.run_query(insert_query)
        QMessageBox.information(self, "Query Executed", "buy 데이터 입력이 성공적으로 실행되었습니다.")

    # 쿼리 실행 메서드
    def run_query(self, query):
        try:
            connection = pymysql.connect(
                host='localhost',
                user='root',
                password='0000',
                db='sql_project',
                charset='utf8',
                cursorclass=pymysql.cursors.DictCursor
            )
            with connection.cursor() as cursor:
                cursor.execute(query)
                connection.commit()
                results = cursor.fetchall()
                if results:
                    self.update_table_widget(results)
                else:
                    QMessageBox.information(self, "Empty Result", "데이터가 없습니다.")
        except pymysql.MySQLError as e:
            QMessageBox.critical(self, "Query Execution Error", f"Error executing query: {e}")
        finally:
            connection.close()

    def update_table_widget(self, results):
        self.table_widget.setColumnCount(len(results[0]))
        self.table_widget.setRowCount(len(results))
        self.table_widget.setHorizontalHeaderLabels(results[0].keys())
        for row_idx, row_data in enumerate(results):
            for col_idx, (col_name, col_value) in enumerate(row_data.items()):
                self.table_widget.setItem(row_idx, col_idx, QTableWidgetItem(str(col_value)))
        self.table_widget.resizeColumnsToContents()
        self.table_widget.resizeRowsToContents()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    ex.show()
    sys.exit(app.exec_())
