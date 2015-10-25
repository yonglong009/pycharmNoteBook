import re
str = "#good xyz"
print(re.search('^#go*d', str))

if re.search('^#go*d', str):
	re.sub('^#go*d', 'Tao', str)
print(re.sub('^#go*d', 'Tao', str))
print(re.sub('$', 'Tao', str))


def my_abs(x):
	if not isinstance(x, (int, float)):
		raise TypeError('error x type')
	if x >= 0:
		return x
	else:
		return -x
print(my_abs(9))


the_dict = {'name': 'mayl', 'age': 26, 'sex': 'm', 'like': 'coding'}
print(the_dict)
# 迭代字典value
for value in the_dict.values():
	print(value)
# 迭代字典 key value
for key, value in the_dict.items():
	print(key, "------->", value)


LL = [2 ** x for x in range(10)]
print(LL)
