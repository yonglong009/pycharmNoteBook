import os
from bs4 import BeautifulSoup
import requests
__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-


url = "https://github.com/session"
passwd = {'user': 'yonglong009', 'password': 'log009Git'}

s = requests.Session()
# r = s.post(url, data=passwd, verify=True)
r = s.get('https://api.github.com/user', auth=('yonglong009', 'log009Git'))
print(r.status_code)
mark_up = r.text
print(r.headers)
print(r.json())

soup = BeautifulSoup(mark_up, "html5lib")
#print(soup.prettify())

##############################################################
# python实现百度、CSDN、淘宝、人人自动登录（第一季）
# http://blog.csdn.net/zhangzhenhu/article/details/6157077


# 用Python实现人人网爬虫，获取用户全部状态信息
# http://www.xgezhang.com/python_renren_spider_1.html