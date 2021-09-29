#!/bin/bash

# test命令：用于测试字符串、文件状态和数字
# test命令有两种格式:
# test condition 或[ condition ]
# 使用方括号时，要注意在条件两边加上空格。

# 文件测试

# 测试文件状态的条件表达式
# -e : 如果文件存在则为真
# -d : 如果文件存在且为目录则为真
# -f : 如果文件存在且为普通文件则为真
# -r : 如果文件存在且可读则为真
# -w : 如果文件存在且可写则为真
# -x : 如果文件存在且可执行则为真
# -L : 符号连接
# -c : 如果文件存在且为字符型特殊文件则为真
# -b : 如果文件存在且为块特殊文件则为真
# -s : 如果文件存在且至少有一个字符则为真

# test -e $fileName
read -p "文件名: " fileName 
if [ -e $fileName ]
then
echo "文件存在"
fi

# 字符串测试

# =        :  等于则为真
# !=       :  不相等则为真
# -z 字符串 :  字符串的长度为零则为真
# -n 字符串 :  字符串的长度不为零则为真
test -z $yn
echo $?  # 0
read -p "字符串:" yn
[ -z $yn ]
echo "1:$?"
[ $yn='y' ]
echo "2:$?"

# 数值测试
# -eq	等于则为真
# -ne	不等于则为真
# -gt	大于则为真
# -ge	大于等于则为真
# -lt	小于则为真
# -le	小于等于则为真
read -p "输入两个数字:" n1 n2
test $n1 -eq $n2
echo "相等:$?"

test $n1 -ge $n2
echo "大于或等于:$?"

test $n1 -lt $n2
echo "小于:$?"

# 符合语句测试
# && ：命令行控制 : command1 && command2。左边命令执行成功(返回0)才会执行右边命令(短路原则)
# || ： command1 || command2。 左边命令执行未成功(返回非0)才会执行右边命令

# test -e /home && test -d /home && echo "true"
# test 2 -lt 3 || test 7 -gt 9 || echo "equal"

# 多重条件判定
# -a : and。两边同时成立。 test -r file -a test -x file。file文件同时具有 r x 权限是才为 true
# -o : and。两边同时成立。 test -r file -o test -x file。file文件同时具有 r x 中的一个权限。 就为 true
# ! : and。两边同时成立。  test ! -x file。file文件不具有 x 权限。 就为 true