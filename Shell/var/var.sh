#!/bin/bash

# 定义变量
# 变量名=变量值
# 如：num=10
# 引用变量
# $变量名
# unset : 清除变量值

num=100
echo $num
# unset num
# echo $num

# 从键盘获取值 read, 赋值给 num变量
# echo "输入num数字:"
# read num

# 第二种写法
# 在一行上显示和添加提示 需要加上-p
read -p "输入num数字:" num
echo "num=$num"

# 读取多个值
read -p "输入两个数字数字:" data1 data2
echo "data1=$data1, data2=$data2"

# 只读变量
readonly num2=999
# 会报错
read -p "修改只读变量:" num2

# 环境变量：env
echo env