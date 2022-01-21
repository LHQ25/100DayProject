#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

# ------------------------------------------------------------
# Ruby 有一个块的概念。
# 块由大量的代码组成。
# 您需要给块取个名称。
# 块中的代码总是包含在大括号 {} 内。
# 块总是从与其具有相同名称的函数调用。这意味着如果您的块名称为 test，那么您要使用函数 test 来调用这个块。
# 您可以使用 yield 语句来调用块

# block_name{
#    statement1
#    statement2
#    ..........
# }


# ------------------------------------------------------------
# yield 语句
def test
    puts "在 test 方法内"
    yield
    puts "你又回到了 test 方法内"
    yield
 end
 test {puts "你在块内"}

 # ------------------------------------------------------------
 # 传递带有参数的 yield 语句

 def test2
    yield 5
    puts "在 test2 方法内"
    yield 100
 end

 test2 {|i| puts "你在块 #{i} 内"}
 # yield 语句后跟着参数。甚至可以传递多个参数。在块中，可以在两个竖线之间放置一个变量来接受参数。因此，在上面的代码中，yield 5 语句向 test 块传递值 5 作为参数
 # 要传递多个参数，那么 yield 语句如下所示
 # test2 {|a, b| statement }

 # ------------------------------------------------------------
 # 块和方法
 # 块和方法之间是如何相互关联的。通常使用 yield 语句从与其具有相同名称的方法调用块
 def test3
    yield
  end
  test3{ puts "Hello world"}

# 本实例是实现块的最简单的方式。您使用 yield 语句调用 test 块。
# 但是如果方法的最后一个参数前带有 &，那么您可以向该方法传递一个块，且这个块可被赋给最后一个参数。如果 * 和 & 同时出现在参数列表中，& 应放在后面。
def test4(&block)
    block.call
 end
 test4 { puts "Hello World!"}

# ------------------------------------------------------------
# BEGIN 和 END 块
# 每个 Ruby 源文件可以声明当文件被加载时要运行的代码块（BEGIN 块），以及程序完成执行后要运行的代码块（END 块）
BEGIN { 
    # BEGIN 代码块
    puts "BEGIN 代码块"
  } 
   
  END { 
    # END 代码块
    puts "END 代码块"
  }
    # MAIN 代码块
  puts "MAIN 代码块"