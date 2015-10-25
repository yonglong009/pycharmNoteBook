import sys
import getopt
# -*- coding: utf-8 -*-
print("脚本名：", sys.argv[0])
for arg in range(1, len(sys.argv)):
    print("参数：", arg, sys.argv[arg])


def usage():
    print("Usage:  -i refer to inputFile, -o refer to outputFile, type -h fro HELP.")


opts, args = getopt.getopt(sys.argv[1:], "hi:o:", ["version", "prefix="])
input_file = ""
output_file = ""
prefix = ""

for opt, value in opts:
    if opt == "-i":
        input_file = value
        print("input_file =", input_file)
    elif opt == "-o":
        output_file = value
        print("output_file =", output_file)
    elif opt == "--version":
        print("version:", "20151020: good dev")
    elif opt == "--prefix":
        prefix = value
        print("prefix=", prefix)
    elif opt == "-h":
        usage()
        sys.exit(0)
