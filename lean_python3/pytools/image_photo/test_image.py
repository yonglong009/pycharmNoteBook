from __future__ import print_function  # 查看属性
from PIL import Image    # 文档：http://pillow.readthedocs.org/en/latest/index.html
import os

__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-
curr_dir = os.path.dirname(os.path.abspath(__file__))

photo = Image.open(os.path.join(curr_dir, "yxb_photo.png"))
print(photo.format, photo.size, photo.mode)   # PNG (1366, 768) RGB

# 1.显示图片：
# photo.show()

# 2.图片格式转换：
# Image模块中的save()函数可以保存图片，除非你指定文件格式，那么文件名中的扩展名用来指定文件格式
# save函数的第二个参数可以用来指定图片格式，如果文件名中没有给出一个标准的图像格式，那么第二个参数是必须的
filename, subfix = os.path.splitext(os.path.basename(os.path.join(curr_dir, "yxb_photo.png")))
try:
    Image.open(os.path.join(curr_dir, "yxb_photo.png")).save(os.path.join(curr_dir, filename + ".jpg"))
    print("the image format", subfix, "to .jpg is OK.....Done & ")
except IOError:
    print("cannot convert")


# 3.创建缩略图
resize = (200, 200)
filename, subfix = os.path.splitext(os.path.basename(os.path.join(curr_dir, "yxb_photo.png")))
try:
    im = Image.open(os.path.join(curr_dir, "yxb_photo.png"))
    im.thumbnail(resize)
    im.save(os.path.join(curr_dir, filename + "_thumb" + subfix))
    print("create thumb is OK.....Done & ", im.format, im.size, im.mode)
except IOError:
    print("cannot convert to thumb")


# 4.Copying a subrectangle from an image, 从图片截取矩形
#  (left, upper, right, lower)
im = Image.open(os.path.join(curr_dir, "yxb_photo.png"))
box = (100, 100, 400, 400)
region = im.crop(box)
# region.show()
# im.show()

# 旋转：
region = region.transpose(Image.ROTATE_180)
# region.show()
im.paste(region, box)
# im.show()

# 其他：
