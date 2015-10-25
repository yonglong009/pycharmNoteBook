import os
import requests

__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-
curr_dir = os.path.dirname(os.path.abspath(__file__))

'''
# 简单使用
r = requests.get('https://github.com/timeline.json')
print(r.status_code)
print(r.headers['content-type'])
# print(r.json())
# print(r.text)
print(r.encoding)
r.encoding = 'ios-8859-1'
print(r.encoding)
# print(r.content)
print(r.text)
'''

'''
# 构造请求参数
# http://dict.youdao.com/search?q=english&keyfrom=dict.index
get_value = {"q": "python", "keyfrom": "dict.index"}
r_get = requests.get("http://dict.youdao.com/search", params=get_value)
print(r_get.status_code, r_get.headers['content-type'])
print(r_get.url)
# print(r_get.text)
'''

'''
# 自动认证github
r = requests.get('https://api.github.com/user', auth=('yonglong009', 'log009Git'))
print(r.status_code)
print(r.headers['content-type'])
# print(r.text)
print(r.json())
'''

# 练习1：
# 1.发起请求
url = "http://www.baidu.com"
r = requests.get(url)
print(r.url, r.status_code)
r = requests.post(url)
print(r.url, r.status_code)

# 2. url 传参
# Request URL:http://dict.baidu.com/s?wd=python
payload = {'wd': 'python'}
r = requests.get("http://dict.baidu.com/s", params=payload)
print(r.url, r.status_code)

# 3. post 数据
payload = {"city": "xining", "name": "mayl", "age": 26}
r = requests.post("http://dict.baidu.com/s", data=payload)
print(r.url, r.status_code)

print("===========================================")
# 4. 自定义 请求头
url = "http://www.baidu.com"
headers = {"User-Agent": "Mozilla/5.0"}
r = requests.get(url, headers=headers)
print(r.url, r.status_code)


print("===========================================")
r = requests.get('http://httpbin.org/get')
print(r.status_code, r.url, r.text)

import json
url = 'https://api.github.com/some/endpoint'
payload = {'some': 'data'}
headers = {'content-type': 'application/json'}
r = requests.post(url, data=json.dumps(payload), headers=headers)
print(r.url, r.status_code, r.headers)
print(r.headers['content-type'])



# 五、身份验证
# 基本身份认证(HTTP Basic Auth):
import requests
from requests.auth import HTTPBasicAuth

r = requests.get('https://httpbin.org/hidden-basic-auth/user/passwd', auth=HTTPBasicAuth('user', 'passwd'))
# r = requests.get('https://httpbin.org/hidden-basic-auth/user/passwd', auth=('user', 'passwd'))    # 简写
print(r.json())