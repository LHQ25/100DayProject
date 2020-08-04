//
//  main.cpp
//  C++_11_(Reference)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;
int main(int argc, const char * argv[]) {
    
    int a = 10;
    int& b = a; //b引用a,b就是a的别名
    cout << "a=" << a << ",b=" << b << endl;
    cout << "&a=" << &a << ",&b=" << &b<<endl;
    b++;
    cout << "a=" << a << ",b=" << b << endl;
    
    //int& r;//error,引用定义时必须初始化
    int c = 20;
    b = c;//ok,但不是修改引用目标,仅是赋值
    cout << "a=" << a << ",b=" << b << endl;
    cout << "&a=" << &a << ",&b=" << &b<<endl;

    //char& rc = c;//error,引用类型和目标要一致
    
    
    //int& r1 = 100; //Error: Non-const lvalue reference to type 'int' cannot bind to a temporary of type 'int'
    const int& r1 = 100;
    cout << r1 << endl;//100
    
    int a1 = 10, b1 = 20;
    //int& r2 = a1 + b1; //Error: Non-const lvalue reference to type 'int' cannot bind to a temporary of type 'int'
    //r2引用的是a+b表达式结果的临时变量(右值)
    const int& r2 = a1 + b1;
    cout << r2 << endl;//30
    
    
    return 0;
}


//MARK: - C++引用(Reference)
//MARK: - 1 定义
/**
1）引用即别名，引用就是某个变量别名，对引用操作和对变量本身完全相同.
2）语法
    类型 & 引用名 = 变量名;
    注：引用必须在定义同时初始化，而且在初始化以后所绑定的目标变量不能再做修改.
    注：引用类型和绑定目标变量类型要一致。
    eg：
    int a = 10;
    int & b = a;//b就是a的别名
    b++;
    cout << a << endl;//11
    a++;
    cout << b << endl;//12
    
    int c = 123;
    b = c;//仅是赋值
    cout << a << endl;//123
*/
//MARK: - 2 常引用
/**
1）定义引用时可以加const修饰，即为常引用，不能通过常引用修改目标变量.
    const 类型 & 引用名 = 变量名;
    类型 const & 引用名 = 变量名;//和上面等价
    
    int a = 10;
    const int& b = a;//b就是a常引用
    cout << b << endl;//10
    b++;//error
2）普通引用也可以称为左值引用，只能引用左值；而常引用也可以称为万能引用，既可以引用左值也可以引用右值。

3）关于左值和右值
左值(lvalue):可以放在赋值表达式左侧，可以被修改
右值(rvalue):只能放在赋值表达式右侧，不能被修改
*/
/**
练习：测试下面表达式结果，是左值还是右值？
        int a,b;
        a+b;//右值
        a+=b;
        ++a;
        a++;
*/
