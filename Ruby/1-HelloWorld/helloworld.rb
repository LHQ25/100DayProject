#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

# 这是一个单行注释。

=begin
这是一个多行注释。
可扩展至任意数量的行。
但 =begin 和 =end 只能出现在第一行和最后一行。 
=end

=begin
中文编码
1. 必须在首行添加 # -*- coding: UTF-8 -*-,告诉解释器使用utf-8来解析源码。(EMAC写法） 或者 #coding=utf-8 就行了
2. 必须设置编辑器保存文件的编码为utf-8。
=end

puts "hello world, 你好 世界";