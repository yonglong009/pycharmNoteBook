import requests
from bs4 import BeautifulSoup

__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-


# http://dict.youdao.com/search?q=python&keyfrom=dict.index
word = "capture"
q_value = {"q": word, "keyform": "dict.index"}
r = requests.get("http://dict.youdao.com/search", params=q_value)
soup = BeautifulSoup(r.text, "html5lib")
trans_div = soup.find_all(id="phrsListTab")
li = trans_div[0].find_all('div', "trans-container")
res = li[0].find_all("li")
for res_tag in res:
    print(res_tag.string)
