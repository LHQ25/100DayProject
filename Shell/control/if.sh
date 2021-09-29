#!/bin/bash

# if 
if [ -e if.sh ]
then 
echo "文件存在"
fi

# if  else 
if [ -e if2.sh ]
then 
echo "文件存在"
else
echo "文件不存在"
fi

# if  else if 
if [ -e if2.sh ]
then 
echo "文件存在"
elif [ -e if.sh ]
then
echo "文件if存在"
fi