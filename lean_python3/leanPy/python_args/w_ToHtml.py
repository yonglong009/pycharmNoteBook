import os

__author__ = 'Administrator'
nowPath = os.getcwd()
print(nowPath)
os.chdir("E:\About_CHM\CHM_python_tool\Test\in")
currPath = os.getcwd()
print(currPath)

file = open("howShow.html", "r", encoding="utf-8")
fileAdd = open("used_daily_.sh", "r", encoding="utf-8")

content = file.read()
contentAdd = fileAdd.read()
file.close()
fileAdd.close()

pos = content.find("</code>")
print(pos)

if pos != -1:
    os.chdir("E:\About_CHM\CHM_python_tool\Test\out")
    content = content[:pos] + contentAdd + content[pos:]
    outFile = open("out.html", "w", encoding="utf-8")
    outFile.write(content)
    outFile.close()
    print("OK.......")



