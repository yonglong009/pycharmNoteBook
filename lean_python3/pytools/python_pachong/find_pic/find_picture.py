import os
import re
from PIL import Image
import requests
from bs4 import BeautifulSoup

__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-

# PWD = "/jiaoben/python/meizitu/pic/"
downpath = r"C:\Users\Administrator\Desktop\test\dest"
timeout = 5
photo_name = 0
subfix = '.jpeg'
for page in range(1, 2):
    site = "http://www.meizitu.com/a/qingchun_3_%d.html" %page
    r = requests.get(site, timeout=timeout)
    print(r.status_code, r.headers['content-type'], r.encoding)
    mark_up = r.text
    soup = BeautifulSoup(mark_up, "html5lib")
    ul_wp_list = soup.find_all('ul', attrs={'class': 'wp-list'})
    print(len(ul_wp_list))
    img_src = ul_wp_list[0].find_all('h3', class_='tit')
    # print(len(img_src), img_src[0].a.get("href"))
    for inside in img_src:
        url = inside.a.get("href")
        r = requests.get(url, timeout=timeout)
        inside_soup = BeautifulSoup(r.text, "html5lib")
        pic_stc = inside_soup.find_all('div', id='picture')
        pic_src_p = pic_stc[0].find_all("img")
        for pic_big in pic_src_p:
            url = pic_big.get("src")
            photo_name += 1
            photo = str(photo_name) + subfix
            r = requests.get(url, stream=True, timeout=timeout)
            # print(r.status_code, r.headers['content-type'])
            with open(os.path.join(downpath, photo), "wb") as f:
                for chunk in r.iter_content():
                    f.write(chunk)
                print("----------------------------", photo, "--------------------ok-down")






# 例如，以请求返回的二进制数据创建一张图片，你可以使用如下代码:
# from PIL import Image
# from StringIO import StringIO
# i = Image.open(StringIO(r.content))