//
//  main.cpp
//  C++_25_2_(inheritance)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Base{
public:
    Base(void): m_public(10), m_protected(20), m_private(30){}
    
    void func1(void){
        cout << "基类的func" << endl;
    }
public:
    int m_public;
protected:
    int m_protected;
private:
    int m_private;
public:
    const int& getPrivate(void){
        return m_private;
    }
};

class Derived:public Base{
public:
    void func(void){
        cout << m_public << endl;//10
        cout << m_protected << endl;//20
        //cout << m_private << endl;//error不允许访问私有变量
        cout << getPrivate() << endl;//30
    }
    
    void func1(int i){
        cout << "子类的func" << endl;
    }
    //将基类中func1引入到子类作用域,让其和子类中func1形成重载
    //using Base::func1;
};


int main(int argc, const char * argv[]) {
    
    Derived d;
    d.func();
    cout << "sizeof(d)=" << sizeof(d) << endl;//12
    
    Derived d1;
    d1.Base::func1();
    d1.func1(123);
    return 0;
}
