//
//  main.cpp
//  C++_27__(typeid&dynamic_cast)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#include <typeinfo>
using namespace std;

class A{ virtual void func(){} };
class B:public A{ void func(){} };
class C:public A{ void func(){} };

void foo(A& ra){
    /* typeinfo支持"==,!="操作符重载,可以直接进行类型之间比较,如果
     * 类型直接具有多态的继承关系,typeid还可以利用多态的语法确定实
     * 际的目标对象类型.*/
    if(typeid(ra) == typeid(B)){
        cout << "针对B子类的处理" << endl;
    }
    else if(typeid(ra) == typeid(C)){
        cout << "针对C子类的处理" << endl;
    }
}
int main(int argc, const char * argv[]) {
    
    int i = 0;
    //name():获取字符串形式类型信息
    cout << typeid(int).name() << endl;
    cout << typeid(i).name() << endl;
    
    int *a1[10];
    int (*a2)[10];
    cout << typeid(a1).name() << endl;
    cout << typeid(a2).name() << endl;
    B b1;
    foo(b1);
    C c;
    foo(c);
    
    //dynamic_cast
    B b;
    A* pa = &b;
    //B* pb = static_cast<B*>(pa);//合理
    //C* pc = static_cast<C*>(pa);//不合理
    
    /* 动态类型转换过程中,会检查pa指向的目标对象和期望转换的类型
     * 是否一致,如果一致转换成功,否则失败*/
    B* pb = dynamic_cast<B*>(pa);//ok
    C* pc = dynamic_cast<C*>(pa);//失败(返回NULL)
    
    cout << "pa=" << pa << endl;
    cout << "pb=" << pb << endl;
    cout << "pc=" << pc << endl;
    
    A& ra = b;
    //C& rc = dynamic_cast<C&>(ra);//失败(抛出异常)
    
    
    return 0;
}

//MARK: - 1 typeid操作符

//  #include <typeinfo>
//  typeid(类型/对象);//返回typeinfo对象，用于描述类型信息

//MARK: - 2 dynamic_cast操作符
//语法：
//    目标变量 = dynamic_cast<目标类型>(源类型变量);
//适用场景：
//    主要用于具有多态特性父子类指针或引用之间的显式类型转换.
