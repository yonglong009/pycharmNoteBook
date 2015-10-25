import os
import re
from prettytable import PrettyTable
__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-


# 处理以字母开头的文件名
def rename_asc_begin(src_dir, pattern, replace_to=""):
    tab = PrettyTable(["old_name", "new_name"])
    for filename in os.listdir(src_dir):
        if os.path.isfile(os.path.join(src_dir, filename)) and filename.endswith('.mp3'):
            if re.match(pattern, filename):
                new_name = re.sub(pattern, replace_to, filename)
                tab.add_row([filename, new_name])
                # 实际操作开关：
                os.rename(os.path.join(src_dir, filename), os.path.join(src_dir, new_name))
    print(tab)


# 处理以汉字开头的文件名
def rename_gbk_begin(src_dir, hanzi_pattern, subfix_as=""):
    tab = PrettyTable(["old_name", "new_name"])
    for filename in os.listdir(src_dir):
        if os.path.isfile(os.path.join(src_dir, filename)) and filename.endswith('.mp3'):
            if re.match(hanzi_pattern, filename):
                temp = re.sub(hanzi_pattern, "", filename)
                new_name = filename.replace(temp.split(".")[0], subfix_as)
                tab.add_row([filename, new_name])
                # 实际操作开关：
                os.rename(os.path.join(src_dir, filename), os.path.join(src_dir, new_name))
    print(tab)


# 调用方式：
# like: LRTS#第08集#6057#8.mp3 , 只好留汉字作为文件名
# re学习：http://www.cnblogs.com/huxi/archive/2010/07/04/1771073.html
# [\u4e00-\u9fa5]  表示汉字 , FF0C ，  ( 汉语标点转utf-8：http://tool.114la.com/site/utf8/)


if __name__ == "__main__":
    src_dir = r"C:\Users\Administrator\Desktop\test\src"
    # step.1
    rename_asc_begin(src_dir, r"^LRTS#", replace_to="")
    # step.2
    rename_gbk_begin(src_dir, r"^[0-9_\uFF0C\u4e00-\u9fa5]+", subfix_as="")
