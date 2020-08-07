//
//  main.cpp
//  C++_25_3_(inheritance)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;
class A{//基类
public:
    int m_public;
protected:
    int m_protected;
private:
    int m_private;
};
//公有继承的子类
class B:public A{
};

//保护继承的子类
class C:protected A{
};

//私有基类的子类
class D:private A{
};

//内部访问变量测试
class X:public B{
    void func(void){
        m_public = 123;
        m_protected = 123;
//        m_private = 123;
    }
};
class Y:public C{
    void func(void){
        m_public = 123;
        m_protected = 123;
//      m_private = 123;
    }
};
class Z:public D{
    void func(void){
//        m_public = 123;
//        m_protected = 123;
//        m_private = 123;
    }
};

int main(int argc, const char * argv[]) {
    //外部访问基类变量测试
    B b;
    b.m_public = 12; //外部只能访问public修饰的变量
    //b.m_protected;  error
    //b.m_private;  error
    
    C c;
    //c.m_public;  error
    //c.m_protected;  error
    //c.m_private;  error
    
    D d;
    //d.m_public = 123;  error
    //d.m_protected = 123;  error
    //d.m_private = 123;  error
    
    return 0;
}
