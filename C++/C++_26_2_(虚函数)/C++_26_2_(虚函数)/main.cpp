//
//  main.cpp
//  C++_26_2_(虚函数)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;
class A{};
class B:public A{};
class Base{
public:
    virtual void func(int i = 100)const{
        cout << "Base的func" << endl;
    }
    virtual /*A**/void foo(void){
        cout << "Base的foo" << endl;
    }
};

class Derived:public Base{
public:
    /*virtual*/ void func(int j = 200)const{
        cout << "Derived的func" << endl;
    }
    /*B**/void foo(void){
        cout << "Derived的foo" << endl;
    }
};

int main(int argc, const char * argv[]) {
    
    //虚函数  类似于Java中的抽象方法
    Derived d;
    Base* pb = &d;//pb:指向子类对象的基类指针
    pb->func();
    pb->foo();
    return 0;
}
