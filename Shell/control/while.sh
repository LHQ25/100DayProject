#!/bin/bash

int=1
while(( $int<=5 ))
do
    echo $int
    # Bash let 命令，它用于执行一个或多个表达式，变量计算中不需要加上 $ 来表示变量
    let "int++"
done