//
//  main.cpp
//  C++_21_(static)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

using namespace std;
class A{
public:
    //普通成员变量在对象构造时定义和初始化
    A(int data=0):m_data(data){}
    
    static void func1(void){
        cout << "静态成员函数" << endl;
        //cout << m_data << endl;//error
        cout << s_data << endl;
    }
    void func2(void){
        cout << "非静态成员函数" << endl;
        cout << m_data << endl;
        cout << s_data << endl;
    }
    
    
    int m_data;//普通成员变量
    static int s_data;//静态成员变量
    //静态的const成员变量,需要在声明时直接初始
    //化,特殊(了解)
    static const int sc_data = 123;
};
//静态成员变量需要在类的外部单独定义和初始化
int A::s_data = 20;


int main(int argc, const char * argv[]) {
    
    A a(10);
    //对象大小(类的类型大小)不包括静态成员变量
    cout << "size=" << sizeof(a) << endl;//4
    //普通成员变量需要通过对象才能访问
    cout << a.m_data << endl;
    //cout << A::m_data << endl;//error

    //静态成员变量可以通过"类名::"直接访问
    cout << A::s_data << endl;
    cout << a.s_data << endl;//ok

    A a2(10);
    a2.m_data = 11;
    a2.s_data = 22;

    cout << a.m_data << endl;//10
    cout << a.s_data << endl;//22
    
    
    //静态函数
    A::func1();
    a.func2();
    a.func1();
    
    return 0;
}
//MARK: - 静态成员(static)
//MARK: - 1 静态成员变量
/**
1）语法
    class 类名{
        static 数据类型 变量名;//声明
    };
    数据类型 类名::变量名 = 初值;//定义和初始化
2）普通成员变量属于对象，而静态成员变量不属于对象，静态变量内存在全局区，可以把静态变量理解为被限制在类中使用的全局变量.
3）普通成员变量在对象构造时定义和初始化，而静态成员变量在类的外部单独定义和初始化。
4）使用方法
    类名::静态成员变量;//推荐
    对象.静态成员变量;//和上面等价
*/
//MARK: - 2 静态成员函数
 /**
1）语法
    class 类名{
        static 返回类型 函数名(参数表){...}
    };
2）静态成员中没有this指针，也没有const属性，可以把静态成员函数理解为被限制在类作用域使用的全局函数.
3）使用方法
    类名::静态成员函数(实参表);//推荐
    对象.静态成员函数(实参表);//和上面等价
注：在静态成员函数中只能访问静态成员，不能访问非静态成员；在非静态成员函数既可以访问静态成员，也可以访问非静态成员.
*/
