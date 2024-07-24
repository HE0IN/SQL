import sys
from PyQt5.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout, QComboBox, QTableWidget,
    QTableWidgetItem, QPushButton, QTextEdit, QLabel, QMessageBox, QHeaderView,
    QTabWidget
)
from PyQt5.QtCore import Qt
import pymysql

class App(QWidget):
    def __init__(self):
        super().__init__()
        self.title = 'MySQL Database 연결 GUI'
        self.left = 100
        self.top = 100
        self.width = 800
        self.height = 600
        self.combo_box = None  # 여기에 combo_box 속성을 추가합니다.
        self.initUI()

    
    def initUI(self):
        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)
        
        main_layout = QVBoxLayout()
        main_layout.setContentsMargins(50, 20, 10, 20)
        
        self.setStyleSheet("background-color: white;")
        
        self.tabs = QTabWidget()
        self.tabs.tabCloseRequested.connect(self.close_tab)
        self.tabs.currentChanged.connect(self.tab_changed)
        self.default_tab = QWidget()
        self.tabs.addTab(self.default_tab, "기본 쿼리")
        
        self.default_tab_layout = QVBoxLayout(self.default_tab)

        combo_button_layout = QHBoxLayout()
        combo_button_layout.setContentsMargins(0, 0, 0, 0)
        combo_button_layout.setAlignment(Qt.AlignLeft)

        self.combo_box = QComboBox(self.default_tab)  # self.combo_box를 클래스 속성으로 정의
        self.combo_box.setFixedWidth(700)
        self.combo_box.setFixedHeight(45)
        self.load_combo_box(self.combo_box)
        self.combo_box.currentIndexChanged.connect(lambda: self.load_query(self.default_tab))


        combo_button_layout.addWidget(self.combo_box)

        self.query_button = QPushButton('실행', self.default_tab)
        self.query_button.clicked.connect(self.execute_query)
        self.query_button.setStyleSheet("border: 1px solid black; font-weight: bold;")
        self.query_button.setFixedWidth(150)
        self.query_button.setFixedHeight(35)
        combo_button_layout.addWidget(self.query_button)

        self.new_query_button = QPushButton('새 쿼리', self.default_tab)
        self.new_query_button.clicked.connect(self.open_new_query_tab)
        self.new_query_button.setStyleSheet("border: 1px solid black; font-weight: bold;")
        self.new_query_button.setFixedWidth(150)
        self.new_query_button.setFixedHeight(35)
        combo_button_layout.addWidget(self.new_query_button)

        self.delete_tab_button = QPushButton('탭 삭제', self.default_tab)
        self.delete_tab_button.clicked.connect(self.delete_current_tab)
        self.delete_tab_button.setStyleSheet("border: 1px solid black; font-weight: bold;")
        self.delete_tab_button.setFixedWidth(150)
        self.delete_tab_button.setFixedHeight(35)
        combo_button_layout.addWidget(self.delete_tab_button)

        self.default_tab_layout.addLayout(combo_button_layout)

        query_layout = QHBoxLayout()
        query_layout.setContentsMargins(0, 20, 0, 20)
        query_layout.setAlignment(Qt.AlignLeft)

        self.query_text = QTextEdit(self.default_tab)
        self.query_text.setStyleSheet("border: 1px solid blue;")
        self.query_text.setFixedWidth(700)
        query_layout.addWidget(self.query_text)

        self.default_tab_layout.addLayout(query_layout)
        self.default_tab.setLayout(self.default_tab_layout)

        self.table_widget = QTableWidget(self.default_tab)
        self.table_widget.setAlternatingRowColors(True)
        self.table_widget.setStyleSheet("""
            QTableWidget {
                border: 1px solid white;
                gridline-color: white;
                font-size: 14px;
            }
            QTableWidget::item {
                padding: 5px;
                background-color: #e6f7ff;
            }
            QTableWidget::item:alternate {
                background-color: #cceeff;
            }
            QHeaderView::section {
                background-color: #3e6f9e;
                color: white;
                border: 1px solid white;
                font-weight: bold;
            }
            QTableCornerButton::section {
                background-color: #3e6f9e;
                border: 1px solid white;
            }
        """)
        self.table_widget.setFixedWidth(700)
        self.table_widget.setFixedHeight(200)
        self.table_widget.setStyleSheet("border: 1px solid blue;")
        self.table_widget.verticalHeader().setVisible(False)
        self.table_widget.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.default_tab_layout.addWidget(self.table_widget)

        main_layout.addWidget(self.tabs)
        self.setLayout(main_layout)

    def tab_changed(self, index):
        current_tab = self.tabs.widget(index)
        if current_tab == self.default_tab:
            self.load_query(current_tab)

    def open_new_query_tab(self):
        new_tab = QWidget()
        new_tab_layout = QVBoxLayout(new_tab)

        query_layout = QHBoxLayout()
        query_layout.setContentsMargins(0, 20, 0, 20)
        query_layout.setAlignment(Qt.AlignLeft)

        query_text = QTextEdit(new_tab)
        query_text.setStyleSheet("border: 1px solid blue;")
        query_text.setFixedWidth(700)
        query_layout.addWidget(query_text)

        new_tab_layout.addLayout(query_layout)

        combo_button_layout = QHBoxLayout()
        combo_button_layout.setContentsMargins(0, 0, 0, 0)
        combo_button_layout.setAlignment(Qt.AlignLeft)

        run_button = QPushButton("실행", new_tab)
        run_button.setObjectName("query_button")
        run_button.clicked.connect(lambda: self.execute_custom_query(query_text, new_tab))
        run_button.setStyleSheet("border: 1px solid black; font-weight: bold;")
        run_button.setFixedWidth(150)
        run_button.setFixedHeight(35)
        combo_button_layout.addWidget(run_button)

        new_query_button = QPushButton('새 쿼리', new_tab)
        new_query_button.setObjectName("new_query_button")
        new_query_button.clicked.connect(self.open_new_query_tab)
        new_query_button.setStyleSheet("border: 1px solid black; font-weight: bold;")
        new_query_button.setFixedWidth(150)
        new_query_button.setFixedHeight(35)
        combo_button_layout.addWidget(new_query_button)

        delete_tab_button = QPushButton('탭 삭제', new_tab)
        delete_tab_button.setObjectName("delete_tab_button")
        delete_tab_button.clicked.connect(lambda: self.tabs.removeTab(self.tabs.indexOf(new_tab)))
        delete_tab_button.setStyleSheet("border: 1px solid black; font-weight: bold;")
        delete_tab_button.setFixedWidth(150)
        delete_tab_button.setFixedHeight(35)
        combo_button_layout.addWidget(delete_tab_button)

        new_tab_layout.addLayout(combo_button_layout)

        table_widget = QTableWidget(new_tab)
        table_widget.setAlternatingRowColors(True)
        table_widget.setStyleSheet("""
            QTableWidget {
                border: 1px solid white;
                gridline-color: white;
                font-size: 14px;
            }
            QTableWidget::item {
                padding: 5px;
                background-color: #e6f7ff;
            }
            QTableWidget::item:alternate {
                background-color: #cceeff;
            }
            QHeaderView::section {
                background-color: #3e6f9e;
                color: white;
                border: 1px solid white;
                font-weight: bold;
            }
            QTableCornerButton::section {
                background-color: #3e6f9e;
                border: 1px solid white;
            }
        """)
        table_widget.setFixedWidth(700)
        table_widget.setFixedHeight(200)
        table_widget.setStyleSheet("border: 1px solid blue;")
        table_widget.verticalHeader().setVisible(False)
        table_widget.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)

        new_tab_layout.addWidget(table_widget)
        new_tab.setLayout(new_tab_layout)

        self.tabs.addTab(new_tab, "새 쿼리")
        self.tabs.setCurrentWidget(new_tab)

    def load_combo_box(self, combo_box):
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
                cursor.execute("SELECT description FROM query_options")
                results = cursor.fetchall()
                combo_box.clear()
                for row in results:
                    combo_box.addItem(row['description'])
        except pymysql.MySQLError as e:
            QMessageBox.critical(self, "Database Error", f"Error loading query descriptions: {e}")
        finally:
            connection.close()

    def load_query(self, tab):
        query_text = tab.findChild(QTextEdit)
        if tab == self.default_tab:
            if self.combo_box and query_text:  # self.combo_box 사용
                index = self.combo_box.currentIndex()
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
                        cursor.execute("SELECT query FROM query_options LIMIT %s, 1", (index,))
                        result = cursor.fetchone()
                        if result:
                            query_text.setPlainText(result['query'])
                        else:
                            query_text.clear()
                except pymysql.MySQLError as e:
                    QMessageBox.critical(self, "Database Error", f"Error loading query: {e}")
                finally:
                    connection.close()


    def execute_query(self):
        query = self.query_text.toPlainText().strip()
        if query:
            self.run_query(query, self.table_widget)
            QMessageBox.information(self, "Query Executed", "조회 쿼리가 성공적으로 실행되었습니다.")

    def execute_custom_query(self, query_text, tab):
        query = query_text.toPlainText().strip()
        table_widget = tab.findChild(QTableWidget)
        if query and table_widget:
            self.run_query(query, table_widget)
            QMessageBox.information(self, "Query Executed", "쿼리가 성공적으로 실행되었습니다.")

    def run_query(self, query, table_widget):
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
                    self.update_table_widget(results, table_widget)
                else:
                    QMessageBox.information(self, "Empty Result", "데이터가 없습니다.")
        except pymysql.MySQLError as e:
            QMessageBox.critical(self, "Query Execution Error", f"Error executing query: {e}")
        finally:
            connection.close()

    def update_table_widget(self, results, table_widget):
        table_widget.setColumnCount(len(results[0]))
        table_widget.setRowCount(len(results))
        table_widget.setHorizontalHeaderLabels(results[0].keys())
        for row_idx, row_data in enumerate(results):
            for col_idx, (col_name, col_value) in enumerate(row_data.items()):
                table_widget.setItem(row_idx, col_idx, QTableWidgetItem(str(col_value)))
        table_widget.resizeColumnsToContents()
        table_widget.resizeRowsToContents()

    def delete_current_tab(self):
        current_index = self.tabs.currentIndex()
        if current_index != 0:
            self.tabs.removeTab(current_index)

    def close_tab(self, index):
        if index != 0:
            self.tabs.removeTab(index)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    ex.show()
    sys.exit(app.exec_())
