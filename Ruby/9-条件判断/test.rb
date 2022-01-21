#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

# ------------------------------------------------------------
# if...else 语句

x=1
if x > 2
   puts "x 大于 2"
elsif x <= 2 and x!=0
   puts "x 是 1"
else
   puts "无法得知 x 的值"
end

# ------------------------------------------------------------
# Ruby if 修饰符
# if修饰词组表示当 if 右边之条件成立时才执行 if 左边的式子。即如果 conditional 为真，则执行 code。
$debug=1
print "debug\n" if $debug

# ------------------------------------------------------------
# Ruby unless 语句
# unless式和 if式作用相反，即如果 conditional 为假，则执行 code。如果 conditional 为真，则执行 else 子句中指定的 code。

unless x>2
   puts "x 小于 2"
 else
  puts "x 大于 2"
end

# ------------------------------------------------------------
# Ruby unless 修饰符

$var =  1
print "1 -- 这一行输出\n" if $var
print "2 -- 这一行不输出\n" unless $var
 
$var = false
print "3 -- 这一行输出\n" unless $var

# ------------------------------------------------------------
# Ruby case 语句 (类似于switch)
$age =  5
case $age
when 0 .. 2
    puts "婴儿"
when 3 .. 6
    puts "小孩"
when 7 .. 12
    puts "child"
when 13 .. 18
    puts "少年"
else
    puts "其他年龄段的"
end

foo = false
bar = true
quu = false
 
case
when foo then puts 'foo is true'
when bar then puts 'bar is true'
when quu then puts 'quu is true'
end
# 显示 "bar is true"