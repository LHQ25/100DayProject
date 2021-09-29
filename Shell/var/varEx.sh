#!/bin/bash

# 判断变量是否存在
# ${var:-val} 如果var存在，整个表达式的值为var，否则为val
echo ${var:-100}  #100
var=200
echo ${var:-200}  #200

# ${var:val} 如果var存在，整个表达式的值为var，否则为val,同时将var的值赋为val
echo ${var2=300}
echo "var2=$var2"

# 字符串的操作
str="hehe:haha:xixi:lala"
# 测量字符串长度${#str}
echo "字符串str的长度为：${#str}" #19
# 从下标3的位置提取 ${str:3}
echo ${str:3}
# 从下标3的位置提取长度为6自己 ${str:3:6}
echo ${str:3:6}
# 替换， 用new替换str中第一个出现old ${str/old/new}
echo ${str/:/#}
# 替换， 用new替换str中所有old ${str//old/new}
echo ${str//:/#}