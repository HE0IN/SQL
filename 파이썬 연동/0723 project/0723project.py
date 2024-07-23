import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QHBoxLayout, QTableWidget, QTableWidgetItem, QPushButton, QTextEdit, QComboBox, QLabel, QMessageBox
from PyQt5.QtCore import Qt
import pymysql

class App(QWidget):
    def __init__(self):
        super().__init__()
        self.title = 'PYQT5를 이용한 GUI 응용 프로그램'
        self.left = 100
        self.top = 100
        self.width = 800
        self.height = 400
        self.initUI()
    
    def initUI(self):
        # 기본 UI 설정
        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)
        
        main_layout = QVBoxLayout()  # 메인 레이아웃
        main_layout.setContentsMargins(50, 20, 10, 20)  # 상하좌우 패딩 설정
        
        # 배경 색상 설정
        self.setStyleSheet("background-color: white;")
        
        # ComboBox for problems and query button
        combo_layout = QHBoxLayout()
        combo_layout.setContentsMargins(0, 0, 0, 0)  # 콤보박스 레이아웃 패딩 설정
        combo_layout.setAlignment(Qt.AlignLeft)

        self.combo_box = QComboBox(self)
        self.combo_box.setFixedWidth(600)  # 콤보박스의 가로 길이 조정
        self.combo_box.setFixedHeight(35)  # 콤보박스의 세로 길이 조정
        self.combo_box.addItem("① 구매 금액이 1000원 이상인 회원 이름과 구매 물품명, 구매 금액을 조회 하시오.")
        self.combo_box.addItem("② 구매 분류가 디지털인 항목을 구매한 회원 명, 전화번호, 구매분류, 물품명, 구매금액을 조회하시오.")
        self.combo_box.addItem("③ 인원이 6명 이상인 회원이 구매한 물품, 회원명, 회원수, 구매금액을 가격 높은순으로 조회 하시오.")
        self.combo_box.addItem("④ 가장 비싼 단가를 가진 물품을 구매한 회원의 회원명, 구매단가, 구매물품, 국번전화번호, 평균키, 데뷔 일자를 구하시오.")
        self.combo_box.addItem("⑤ 키가 165 이하이고 총 구매 금액이 500이 넘는 회원의 회원 아이디, 회원 키, 총구매 금액을 총 구매 수량이 많은 순으로 탑3 까지 조회")
        self.combo_box.addItem("⑥ 서울 출생이고 구매하지 않는 회원의 회원 아이디, 데뷔일자를 데뷔 일자가 빠른 순으로 탑2 까지 조회")
        self.combo_box.addItem("⑦ 아이즈원은 거제 출생이고, 폰은 없다. 평균키는 170이며 데뷔 날짜및 멤버수는 검색, ID는 IVE 이다. 아이즈 원은 청바지와 에어팟을 각 3개씩 샀다. insert 하세요.")
        self.combo_box.addItem("⑧ 마마무가 자신들의 평균키가 166이라고 정정해달라는 요청이 왔다. 이를 update 하시오.")
        self.combo_box.addItem("⑨ 멤버 이름이 4글자인 멤버의 총 평균 키를 조회하시오.")
        self.combo_box.addItem("⑩ 서적이 모두 환불 되었습니다. 서적을 구매한 회원 네임과 멤버의 전화번호, 환불할 총 구매 금액을 조회 하시오.")
        self.combo_box.currentIndexChanged.connect(self.load_query)
        combo_layout.addWidget(self.combo_box)
        
        self.combo_box.setStyleSheet("""
            QComboBox {
            border: 1px solid blue;
            padding: 5px 10px;
            font-size: 12px;
            color: blue;
            font-weight: bold;  /* 텍스트를 굵게 만듭니다 */
            }

            QComboBox::drop-down {
            subcontrol-origin: padding;
            subcontrol-position: top right;
            width: 30px;
            border-left-width: 1px;
            border-left-color: white;
            border-left-style: solid;
            border-top-right-radius: 3px;
            border-bottom-right-radius: 3px;
            background-color: white;
        
            }

            QComboBox::down-arrow {
                image: url(down_arrow.png);  # 드롭다운 화살표 이미지 경로 설정
                width: 10px;
                height: 10px;
            }
            QComboBox::down-arrow:on {  # 눌렀을 때
                top: 1px;
                left: 1px;
            }
        """)

        self.query_button = QPushButton('조회', self)
        self.query_button.clicked.connect(self.execute_query)
        self.query_button.setStyleSheet("border: 1px solid black; font-weight: bold;")  # 테두리 파란색 설정
        self.query_button.setFixedWidth(80)  # 조회 버튼 가로 길이
        self.query_button.setFixedHeight(30)  # 조회 버튼 세로 길이
        combo_layout.addWidget(self.query_button)
        main_layout.addLayout(combo_layout)
        
        # SQL query section
        query_layout = QHBoxLayout()
        query_layout.setContentsMargins(0, 20, 0, 20)  # 쿼리 레이아웃 패딩 설정
        query_layout.setAlignment(Qt.AlignLeft)  # 쿼리 레이아웃을 왼쪽 정렬로 설정
        

        self.query_text = QTextEdit(self)
        self.query_text.setStyleSheet("border: 1px solid blue;")  # 테두리 파란색 설정
        self.query_text.setFixedWidth(600)  # 쿼리 박스 가로 길이
        self.load_query()  # 초기 쿼리 로드
        query_layout.addWidget(self.query_text)

        main_layout.addLayout(query_layout)

        
        # Result table section
        # Result table section
        self.table_widget = QTableWidget()
        self.table_widget.setAlternatingRowColors(True)
        self.table_widget.setStyleSheet("QTableWidget { alternate-background-color: #f2f2f2; background-color: #ffffff;}")  # 테두리 파란색 설정
        self.table_widget.setFixedWidth(600)  # 테이블 가로 길이
        self.table_widget.setFixedHeight(100)  # 테이블 세로 길이
        main_layout.addWidget(self.table_widget)

        
        self.setLayout(main_layout)
    
    def load_query(self):
        # 콤보박스에서 선택한 쿼리를 텍스트 박스에 로드
        index = self.combo_box.currentIndex()
        if index == 0:
            self.query_text.setPlainText("""
SELECT M.mem_name '회원 이름', B.pro_name '물품 명', (B.price * B.amount) AS '구매 금액'
FROM buy B
INNER JOIN member M ON B.mem_id = M.mem_id
WHERE (B.price * B.amount) >= 1000;
""")
        elif index == 1:
            self.query_text.setPlainText("""
SELECT M.mem_name, CONCAT(M.phone1, '-', M.phone2) AS '전화번호', B.group_name, B.pro_name, (B.price * B.amount) AS '구매 금액'
FROM buy B
INNER JOIN member M ON B.mem_id = M.mem_id
WHERE B.group_name = '디지털';
""")
        elif index == 2:
            self.query_text.setPlainText("""
SELECT B.pro_name, M.mem_name, M.mem_number, (B.price * B.amount) AS '구매 금액'
FROM buy B
INNER JOIN member M ON B.mem_id = M.mem_id
WHERE M.mem_number >= 6
ORDER BY (B.price * B.amount) DESC;
""")
        elif index == 3:
            self.query_text.setPlainText("""
SELECT M.mem_name, B.price, B.pro_name, CONCAT(M.phone1, '-', M.phone2), M.height, M.debut_date
FROM buy B
INNER JOIN member M ON B.mem_id = M.mem_id
ORDER BY B.price DESC, M.debut_date
LIMIT 1;
""")
        elif index == 4:
            self.query_text.setPlainText("""
SELECT M.mem_id, M.height, SUM(B.price * B.amount) AS '총 구매 금액'
FROM buy B
INNER JOIN member M ON B.mem_id = M.mem_id
WHERE M.height <= 165
GROUP BY M.mem_id, M.height
HAVING SUM(B.price * B.amount) > 500
ORDER BY SUM(B.amount) DESC
LIMIT 3;
""")
        elif index == 5:
            self.query_text.setPlainText("""
SELECT M.mem_id, M.debut_date
FROM member M
LEFT JOIN buy B ON M.mem_id = B.mem_id
WHERE M.addr = '서울' AND B.mem_id IS NULL
ORDER BY M.debut_date
LIMIT 2;
""")
        elif index == 6:
            self.query_text.setPlainText("""
INSERT INTO member (mem_id, mem_name, mem_number, addr, height, debut_date) VALUES
('IVE', '아이즈원', 12, '거제', 170, '2018-10-29');
INSERT INTO buy (mem_id, prod_name, group_name, price, amount) VALUES
('IVE', '청바지', '패션', 50, 3),
('IVE', '에어팟', '디지털', 80, 3);
""")
        elif index == 7:
            self.query_text.setPlainText("""
UPDATE member
SET height = 166
WHERE mem_name = '마마무';
""")
        elif index == 8:
            self.query_text.setPlainText("""
SELECT mem_name, AVG(height) AS '평균 키'
FROM member
WHERE CHAR_LENGTH(mem_name) = 4
GROUP BY mem_name;
""")
        elif index == 9:
            self.query_text.setPlainText("""
SELECT M.mem_name, CONCAT(M.phone1, '-', M.phone2) AS '전화번호', SUM(B.price * B.amount) AS '환불 총 금액'
FROM buy B
INNER JOIN member M ON B.mem_id = M.mem_id
WHERE B.group_name = '서적'
GROUP BY M.mem_name, M.phone1, M.phone2;
""")
    
    def execute_query(self):
        query = self.query_text.toPlainText()
        
        # MySQL 데이터베이스에 연결
        try:
            connection = pymysql.connect(
                host='localhost',
                user='root',
                password='0000',
                db='sql_project',
                charset='utf8',
                cursorclass=pymysql.cursors.DictCursor
            )
        except pymysql.MySQLError as e:
            QMessageBox.critical(self, "Database Connection Error", f"Error connecting to database: {e}")
            return
        
        try:
            with connection.cursor() as cursor:
                cursor.execute(query)
                results = cursor.fetchall()
                
                if results:
                    self.table_widget.setColumnCount(len(results[0]))
                    self.table_widget.setRowCount(len(results))
                    self.table_widget.setHorizontalHeaderLabels(results[0].keys())
                    
                    for row_idx, row_data in enumerate(results):
                        for col_idx, (col_name, col_value) in enumerate(row_data.items()):
                            self.table_widget.setItem(row_idx, col_idx, QTableWidgetItem(str(col_value)))
                    
                    self.table_widget.resizeColumnsToContents()
                    self.table_widget.resizeRowsToContents()
                    
                    header = self.table_widget.horizontalHeader()
                    header.setStyleSheet("QHeaderView::section { background-color: #f2f2f2; font-weight: bold; }")
                else:
                    self.table_widget.setRowCount(0)
                    self.table_widget.setColumnCount(0)
        
        except pymysql.MySQLError as e:
            QMessageBox.critical(self, "Query Execution Error", f"Error executing query: {e}")
        
        finally:
            connection.close()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    ex.show()
    sys.exit(app.exec_())
