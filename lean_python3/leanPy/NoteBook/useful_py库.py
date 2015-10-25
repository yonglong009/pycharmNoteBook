# 非常酷的日期/时间库 delorean
# Dolorean是一个非常酷的日期/时间库。类似JavaScript的moment，拥有非常完善的技术文档。
from delorean import Delorean
import sh

TIME_ZONE = 'Asia/Shanghai'
date = Delorean(timezone=TIME_ZONE)
print(date.datetime)

# prettytable 浏览器或终端构造表格
from prettytable import PrettyTable
from colorama import Fore
table = PrettyTable(field_names=["name", "age", "lang", "schollnae", "nowTime"])
table.align["name"] = "1"
table.padding_width = 1
redName = Fore.RED + "mayl" + Fore.RESET
table.add_row([redName, 26, "python", "YBU", date.datetime])
table.add_row(["mayt", 23, "python", "ZJU", date.datetime])
table.sort_key("age")
# table.reversesort = True
print(table)

# python中使用shell命令,用os.popen()执行命令cmd,还有其他方法。。。。。
import os
output = os.popen("ls $HOME/bin")
print(output.read(), type(output))
# -----------
from sh import ifconfig
print(ifconfig("wlan0"))


# progressbar是一个进度条库，该库提供了一个文本模式的progressbar。



# sudo pip3 install colorama
from colorama import Fore
print(Fore.BLUE + "red text ============================================================")

# Python 程序员应该知道的 10 个库 http://blog.jobbole.com/52355/

# http://www.cnblogs.com/scgw/archive/2009/11/09/1599378.html
# http://developer.51cto.com/art/201003/186941.htm
# http://www.pythontab.com/
