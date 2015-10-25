from datetime import datetime
import hashlib

# set time ,使用构造函数
tm = datetime(2015, 10, 1, 12, 12, 12)
print(tm, type(tm))

now = datetime.now()
print(now, type(now))

# epoch time 秒数
epoch = now.timestamp()
print(epoch, type(epoch))

# timestamp转换为datetime
print(epoch, "----->", datetime.fromtimestamp(epoch))

# str转换为datetime
cday = datetime.strptime('2015-6-1 18:19:59', '%Y-%m-%d %H:%M:%S')
print(cday, type(cday))


# hashlib 密码加密
user, passwd = "mayl", "yonglong009@yeah.net"
the_md5 = hashlib.md5()
the_md5.update(passwd.encode('utf-8'))
print("USER:", user, "PASSWD:", the_md5.hexdigest())





