import os
# pip install chardet
import chardet


def convert2utf8(filename, encoding="utf-8"):
        print("convert:", filename)
        with open(filename, "rb") as f:
            context = f.read()
            result = chardet.detect(context)  # 通过chardet.detect获取当前文件的编码格式串，返回类型为字典类型
            coding = result.get("encoding")
            if coding != "utf-8":
                print(filename, "*[is encoding as :", coding, "]* will be coding to utf-8 ....", encoding)
                new_context = context.decode(coding).encode(encoding)
                out_name = "_" + os.path.basename(filename)
                with open(os.path.join(os.path.dirname(filename), out_name), "w") as outfile:
                    outfile.write(str(new_context))
                    print("OK")


if __name__ == "__main__":
    convert2utf8(r"C:\Users\Administrator\Desktop\test\src\_BSS_OCS_OWE_TIME.sh")
