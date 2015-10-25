#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import glob
import time

__author__ = 'mayl'
print("pwd:", os.getcwd())
# os.chdir('/home/mayl/bash_box')
os.chdir(os.path.join(os.path.expanduser('~'), 'bash_box'))
print('chdir:', os.getcwd())

pathname = os.path.join(os.getcwd(), glob.glob('T*.py')[0])
print('join+glob', pathname)

# print(os.path.split(pathname))
(path, filename) = os.path.split(pathname)
print('split', path, filename)
(shortname, suffix) = os.path.splitext(filename)
print('splitext:\n', shortname, '\t', suffix)

# 文件元信息
metadate = os.stat(filename)
print('last modify time is:', time.localtime(metadate.st_mtime))
print(metadate.st_size)

# 由文件名构造绝对路径
print(os.path.realpath(filename))

# 显示多个文件的绝对路径  ，列表解析
files_sh = [os.path.realpath(f) for f in glob.glob('*.sh')]
print(files_sh)
files_sh = [os.path.realpath(f) for f in glob.glob('*.sh') if os.stat(f).st_size < 1000]
print(files_sh)

# 字典解析
tuple_list = [(f, os.stat(f)) for f in glob.glob('*.sh')]    # 列表解析,生成包含tuple的list
print(tuple_list[0])
meta_stat_dict = {f: os.stat(f) for f in glob.glob('*.sh')}  # 字典解析
print(meta_stat_dict[tuple_list[0][0]])
print('========================================')
print(meta_stat_dict.items())

# 集合解析
a_set = {1, 2, 3, 4, 5, 6, 8, 7}
print({x * 2 for x in a_set})
print({x for x in a_set if x % 2 == 0})

print([2 ** x for x in range(10)])    # list 解析
print({2 ** x for x in range(10)})    # set
print({x: 2 ** x for x in range(10)})
# {0: 1, 1: 2, 2: 4, 3: 8, 4: 16, 5: 32, 6: 64, 7: 128, 8: 256, 9: 512}


# read a file
print(pathname)


def read_sh(file_name):
	with open(pathname, encoding='utf-8') as sh_file:
		for line in sh_file:
			print(line)
read_sh(pathname)
