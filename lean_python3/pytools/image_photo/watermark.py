import os
# Image, ImageEnhance, ImageDraw, ImageFont
from PIL import Image, ImageEnhance, ImageDraw, ImageFont
# http://pillow.readthedocs.org/en/latest/index.html     pillow文档

__author__ = 'MaYonglong'
# -*- coding: utf-8 -*-


def watermark(img_source, img_water, img_new, offset_x, offset_y):
    try:
        im = Image.open(img_source)
        wm = Image.open(img_water)
        layer = Image.new('RGBA', im.size)
        layer.paste(wm, (im.size[0] - offset_x, im.size[1] - offset_y))
        newIm = Image.composite(layer, im, layer)
        newIm.save(img_new)
    except Exception as e:
        print(">>>>>>>>>>> WaterMark EXCEPTION:  " + str(e))
        return False
    else:
        return True


if __name__ == "__main__":
    watermark('self_photo.jpg', '34.bmp', 'self_w.jpg', 100, 100)
