#!/bin/bash

a=0

# a 小于等于 10
until [ ! $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done

# break continue : 类似于其它语言的用法一致