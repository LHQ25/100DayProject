//
//  main.cpp
//  Stack(表达式求解)
//
//  Created by 亿存 on 2020/8/21.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

/* 表达式求值 */
//程序设计语言编译中的一个最基本的问题，它的实现是栈应用的有一个典型例子   这里介绍一种简单直观、广为使用的算法。称为：算符优先法
//任何一个表达式都是由操作数(operand)、运算符(operator)和界限符(delimiter)组成，称之为单词
//操作数既可以是常数也可以是被说明为变量或者常量的标识符
//运算符可以分为算术运算符、关系运算符、逻辑运算符
//基本界限符有左右括号和表达式结束符等
//仅讨论简单算术表达式的求值问题。

//把运算符和界限符统称为算符，它们构成的集合命名为OP

//为了实现算符优先算符，可以使用两个工作栈，一个称为OPTR，用以寄存运算符；另一个称为OPND，用以寄存操作数或运算结果
/* 算符的基本思想 */
//1.  首先置操作数栈为空栈，表达式起始符”#“为运算符的栈底元素
//2.  依次读入表达式中的每个字符；若是操作数则进OPND栈，若是运算符则和OPTR栈的栈顶运算符比较优先权后作相应操作，直至整个表达式求值完毕(即OPTR栈的栈顶元素和当前读入的字符均为”#“)

int main(int argc, const char * argv[]) {
    
    
    return 0;
}


