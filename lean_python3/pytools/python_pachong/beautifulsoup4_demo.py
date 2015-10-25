import os
import re
from bs4 import BeautifulSoup

# pip install beautifulsoup4
# pip install lxml

# http://www.crummy.com/software/BeautifulSoup/bs4/doc/index.html  <--- BeautifulSoup's DOCS
# 下面是第一次练习：
"""
__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-

curr_dir = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(curr_dir, "html_doc.html"), "r") as mark_up:
    soup = BeautifulSoup(mark_up, "html5lib")     # 指定解析器
    # print(soup.prettify())
    print(soup.body.a)
    print("==========================================")
    a_link = soup.find_all('a')
    for a in a_link:
        print(a)
        # print(a.contents)
    length = len(soup.contents)
    print(soup.contents[0].name)

    for chil in soup.head.children:
        print(chil)
        print("head 还有子节点：")
    for desecond in soup.head.descendants:
        print(desecond)
    #
    print("==========================================")
    print(soup.head.string)

    for string in soup.stripped_strings:
        pass   # print(string)
    title_tag = soup.title
    print(title_tag)
    print(title_tag.parent)
    print(title_tag.parent.string)
    print("==========================================")
    # tags = soup.find_all('a', attrs={'class': 'sister'})
    tags = soup.find_all('a', 'sister')
    print(tags[1].string)

    # soup.find(text=re.compile("sisters"))
    tags = soup.find_all(text=re.compile("sisters"))

"""

# 下面是第二次练习：
html_doc = """
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title"><b>The Dormouse's story</b></p>
<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>
<p class="story">...</p>
"""
soup = BeautifulSoup(html_doc, "html5lib")
# print(soup.prettify())
print(soup.head)
print(soup.head.title)
print("===============")
print(soup.head.string)
print(soup.head.title.string)
print("===============")
print(soup.a, type(soup.a), soup.a['href'], soup.a['id'])
print(soup.find_all('a')[0])
print(soup.find_all('a')[0]['href'])
print("===============")
a_link = soup.find_all('a')
for a in a_link:
    print(a['href'])
print("===============")
print(soup.find(id="link3"))
print(soup.find(id="link3")['href'])
print("===============")
for link in soup.find_all("a"):
    print(link.get('href'))   # 同：print(link.['href'])
print("===============")
# extracting all the text from a page:
print(soup.get_text())
print(soup.head.get_text())
tag = soup.find_all("a")
print("===============")
for t in tag:
    print(t.get_text())
print("===============")
soup = BeautifulSoup('<b class="boldest" set="mayonglong" >Extremely bold</b>', "html5lib")
tag = soup.b
print(tag, tag['class'], tag.get_text(), tag.string, type(tag))
print(tag.name, type(tag.name))
tag.name = 's'  # 该表tag名称
print(tag)
print(tag["class"], tag['set'])
print(tag.attrs)
tag['set'] = 'mayongtao'
print(tag.attrs)

print("===============")
css_soup = BeautifulSoup('<p class="body strikeout"></p>', "html5lib")
print(css_soup.p['class'])

print("===============")
rel_soup = BeautifulSoup('<p>Back to the <a rel="index">homepage</a></p>', "html5lib")
print(rel_soup.a['rel'])
rel_soup.a['rel'] = ['mayl', 'mayt']
print(rel_soup.a['rel'])
# print(rel_soup.prettify())
print(rel_soup.a.string)
print(rel_soup.p.string)  # None
print(rel_soup.p.get_text())
print(rel_soup.p.text)

print("===============")
print(rel_soup.a.string)
rel_soup.a.string.replace_with("mayl's page")   # 修改string
print(rel_soup.a.string)

# comments:
markup = "<b><!--Hey, buddy. Want to buy a used parser?--></b>"
comm_soup = BeautifulSoup(markup, "html5lib")
print(comm_soup.b.string, type(comm_soup.b.string))   # <class 'bs4.element.Comment'>
# print(comm_soup.prettify())  # show as comment
print("===============")


html_doc = """
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title"><b>The Dormouse's story</b></p>
<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>
<p class="story">...</p>
"""
# Navigating the tree
soup = BeautifulSoup(html_doc, "html5lib")
print(soup.title)
print(soup.title.parent)
print(soup.body.p, '=?', soup.p)
for a in soup.find_all("a"):
    print(a['href'])

# .contents and .children
# 1.A tag’s children are available in a list called .contents:
print(soup.body.contents)
print(soup.body.contents[1], type(soup.body.contents[1]))

print(soup.contents[0].name, "==================================")

print(soup.body.children, type(soup.body.children))  # <list_iterator object at 0x0200E6F0>
# Instead of getting them as a list, you can iterate over a tag’s children using the .children generator:
for child in soup.body.children:
    pass  # print(child)
print('================================')
print(soup.title.contents)

print(soup.body.children)
# print(list(soup.body.children))  # 将list_iterator 强转为 list

print('================================')
print(soup.title.parent)
print(soup.head)
print(soup.head.string.parent)
print(type(soup.html.parent))
print(type(soup.html.parent.parent))

link = soup.a
print(link)
for parent in link.parents:
    if parent is None:
        print(parent)
    else:
        print(parent.name)

# Going sideways
sibling_soup = BeautifulSoup("<a><b>text1</b><c>text2</c></b></a>", "html5lib")
# print(sibling_soup.prettify())
print(sibling_soup.b.next_sibling, sibling_soup.c.previous_sibling)
print(sibling_soup.b.previous_sibling)
if sibling_soup.b.previous_sibling is None:
    print("None+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
print(sibling_soup.b.string, sibling_soup.b.next_sibling.string)
print("=================================")
print(soup.a.next_sibling)   # a comma ????
print(soup.a.next_sibling.next_sibling)
print(soup.a.next_sibling.next_sibling.next_sibling.next_sibling)

print("=================================")
# You can iterate over a tag’s siblings with .next_siblings or .previous_siblings:
tag_class = type(soup.a)
print(tag_class)
for sibling in soup.a.next_siblings:   # 不包含a
    # print(repr(sibling), type(sibling))
    if isinstance(sibling, tag_class):
        print(sibling)
print("=================================")
print(soup.a.next_siblings)
print(list(soup.a.next_siblings))


# Searching the tree
print("=======================================================================")
# Searching the tree
# based on a tag’s name, on its attributes, on the text of a string, or on some combination of these.
html_doc = """
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title"><b>The Dormouse's story</b></p>
<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>
<p class="story">...</p>
"""
soup = BeautifulSoup(html_doc, "html5lib")
# print(soup.prettify())
# print(soup.find_all(re.compile(r"^b")), len(soup.find_all(re.compile(r"^b"))))
for tag in soup.find_all(re.compile(r"^t")):
    print(tag.string)

print(soup.find_all(['b', 'a']))   # a list !!!!
print("===================================true==")


# passing a function:
def has_class_but_no_id(tag):
    return tag.has_attr('class') and not tag.has_attr('id')
tag_list = soup.find_all(has_class_but_no_id)
# print(tag_list)
print(soup.find_all("title"))
print(soup.find_all("a", "sister"))
print(soup.find_all(class_="title"))
print(soup.find_all(id="link2"))
print("===================================")
# Signature: find_all(name, attrs, recursive, string, limit, **kwargs)
res = soup.find(string=re.compile("sisters"))   # find string ___________________________________________________
print(res)
print(soup.find_all(href=re.compile("lacie")))
print(soup.find_all(id=re.compile("link.*")))
print("===================================")
print(soup.find_all(id=["link1", "link3"]), "passing A List")  # a list  *************************************** !

'''
This code finds all tags whose id attribute has a value, regardless of what the value is:
'''
print(soup.find_all(id=True))

'''
You can filter multiple attributes at once by passing in more than one keyword argument: '''
print(soup.find_all(href=True, id=re.compile("3")), "-----------------------")

'''
Some attributes, like the data-* attributes in HTML 5, have names that can’t be used as the names of keyword arguments:
data_soup = BeautifulSoup('<div data-foo="value">foo!</div>')
data_soup.find_all(data-foo="value")
# SyntaxError: keyword can't be an expression

You can use these attributes in searches by putting them into a dictionary and passing the dictionary
into find_all() as the attrs argument:

data_soup.find_all(attrs={"data-foo": "value"})
# [<div data-foo="value">foo!</div>]
'''
data_soup = BeautifulSoup('<div data-foo="value">foo!</div>', "html5lib")
# print(data_soup.find_all(date-foo="value"))     # SyntaxError: keyword can't be an expression
print(data_soup.find_all(attrs={"data-foo": "value"}))

print(soup.find_all(string="Tillie"), type(soup.find_all(string="Tillie")), type(soup.find_all(string="Tillie")[0]))
print(soup.find_all("a", string=re.compile(r"Tilli.*")))


print("---------------------------------------")
print(soup.find_all("a", href=re.compile("com"), limit=1))
