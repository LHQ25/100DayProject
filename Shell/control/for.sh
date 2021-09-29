#!/bin/bash

for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done

# declare : 内建命令，显示声明shell变量、设置变量属性。declare也可写作 typeset
# declare -i s : 代表强制把 s 变量当作int类型属性运算
declare -i sum=0
declare -i n=0
for ((n=0;n<=100;n++)) 
do
sum=$sum+$n;
done
echo "sum=$sum"

# for in
for str in this is for loop
do 
echo $str
done

for str in 1 23 44
do 
echo $str
done

# 当前目录下的所有文件
for file in `ls`
do
echo $file
done