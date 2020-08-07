//
//  main.cpp
//  C++_23_(memptr)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class A{
public:
    A(int data):m_data(data){}
    
    void print(void){
        cout << m_data << endl;
    }
    
    //int m_i;
    //double m_d;
    int m_data;
};

int main(int argc, const char * argv[]) {
    
    //成员变量指针
    int A::*pdata = &A::m_data;
    printf("%p\n",pdata);
    A a(100);
    cout << a.*pdata << endl;//100
    A* pa = new A(200);
    cout << pa->*pdata << endl;//200
    
    
    //成员函数指针
    void (A::*pfunc)(void) = &A::print;
    A a2(100);
    (a2.*pfunc)();
    A* pa2 = new A(200);
    (pa2->*pfunc)();
    
    
    return 0;
}
//MARK: - 成员指针//了解
//MARK: -1 成员变量指针
/**
1）定义
    类型 类名::*成员指针变量名 = &类名::成员变量;
2）使用
    对象.*成员指针变量名;
    对象指针->*成员指针变量名;
    注：“.*”和“->*”是一个符号，不能写分家了
*/
//MARK: -2 成员函数指针
/**
1）定义
    返回类型 (类名::*成员函数指针)(参数表)
        = &类名::成员函数名;
2）使用
    (对象.*成员函数指针)(实参表);
    (对象指针->*成员指针变量名)(实参表);
*/
