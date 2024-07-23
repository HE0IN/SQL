import pymysql

conn, cur = None, None
data1, data2, data3, data4 = "", "", "", ""

conn = pymysql.connect(host='127.0.0.1', user = 'root', password='0000', db='soloDB', charset='utf8')
cur = conn.cursor()

while 1:
    data1= input("사용자 ID ==> ")
    if data1 == "":
        break;
    data2 = input("사용자 이름 ==> ")
    data3 = input("사용자 이메일 ==> ")
    data3 = input("사용자 출생년도 ==> ")
    sql = "INSERT INTO userTable VALUES('" + data1 + "','" + data2 + "','" + data3 + "'," + data4 + ")"
    cur.execute(sql)

onn.commit()
conn.close()