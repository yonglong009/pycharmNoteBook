import os
from PIL import Image
__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-


ascii_set = list("$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,\"^`'. ")


# 灰度值 ＝ 0.2126 * r + 0.7152 * g + 0.0722 * b
def get_char(r, b, g, alpha=256):
    if alpha == 0:
        return ' '
    length = len(ascii_set)
    gray = int(0.2126 * r + 0.7152 * g + 0.0722 * b)
    unit = (256.0 + 1)/length
    return ascii_set[int(gray/unit)]

if __name__ == '__main__':
    curr_dir = os.path.dirname(os.path.abspath(__file__))
    im = Image.open(os.path.join(curr_dir, "500_500_test.jpg"))
    width = 400
    height = 400
    im = im.resize((width, height), Image.NEAREST)
    txt = ''
    for i in range(height):
        for j in range(width):
            txt += get_char(*im.getpixel((j, i)))
        txt += '\n'
    print(txt)