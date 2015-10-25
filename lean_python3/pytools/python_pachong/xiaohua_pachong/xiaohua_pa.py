import os
import requests
from bs4 import BeautifulSoup

__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-

page = 1
url = 'http://www.qiushibaike.com/hot/page/' + str(page)

r = requests.get(url)
soup = BeautifulSoup(r.text, "html5lib")
# dramaList = soup.findAll('div', attrs={'class':'list_block1 align_c'})
div = soup.find_all('div', attrs={'class': "content"})
print(len(div))
for d in div:
    for i in range(len(div)):
        print(div[i].text)

# print(soup.prettify())

