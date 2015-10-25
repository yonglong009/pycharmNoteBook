import os
import codecs

src_dir = r"C:\Users\Administrator\Desktop\test\src"
dest_dir = r"C:\Users\Administrator\Desktop\test\dest"

# 先将src_dir下的文件用全部转码为utf-8
'''
for filename in os.listdir(src_dir):
    with codecs.open(os.path.join(src_dir, filename), "r",
                     encoding="gb18030", errors="ignore") as f:
        bstr = f.read()
        with codecs.open(os.path.join(src_dir, "utf8_" + filename), "w",
                         encoding="utf-8", errors="ignore") as f_utf8:
            f_utf8.write(bstr)
'''

# ??? sub compile replace


#
template_dir = os.path.dirname(os.path.abspath(__file__))     # 模板html文件放在程序目录
with open(os.path.join(template_dir, "template.html"), "r", encoding="utf-8") as html:
    context = html.read()
    pos = context.find("<p></p>")
    if pos != -1:
        for filename in os.listdir(src_dir):
            with open(os.path.join(src_dir, filename), "r", encoding="utf-8") as input_file:
                with open(os.path.join(dest_dir, filename.split(".")[0] + ".html"), "w", encoding="utf-8") \
                        as output_file:
                    input_file = input_file.read()
                    offset = pos + 3
                    output_file.write(context[:offset] + input_file + context[offset:])

