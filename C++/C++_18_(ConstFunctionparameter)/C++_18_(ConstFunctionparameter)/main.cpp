//
//  main.cpp
//  C++_18_(ConstFunctionparameter)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class A{
public:
    //构造函数和初始化列表
    A(int data=0):m_data(data){}
    
    //void print(const A* this) //编译后是这样，this指针是一个常量指针，不能在常成员函数中修改成员变量的值
    void print(void) const {//常成员函数
        //cout << this->m_data << endl;
        cout << m_data/*++*/ << endl;
        //去常类型转换  可以实现修改值(但是没必要这么做)  mutable修饰变量就可以了
        //const_cast<A*>(this)->m_spec = 200;
        m_spec = 200;
        cout << m_spec << endl;
    }
    
    
    //void func1(const A* this)
    void func1(void)const{
        cout << "常函数" << endl;
        //func2();//error
    }
    //void func2(A* this)
    void func2(void){
        cout << "非常函数" << endl;
    }
    
    //重载关系
    void func(void) const {
        cout << "func常版本" << endl;
    }
    void func(void) {
        cout << "func非常版本" << endl;
    }
private:
    int m_data;
    mutable int m_spec;
};


int main(int argc, const char * argv[]) {
    //基本长成员函数
    A a(100);
    a.print();
    
    //调用关系
    A a1;
    a1.func1();//A::func1(&a1),A*
    a1.func2();//A::func2(&a1),A*
    
    
    const A a2 = a1;
    a2.func1();//A::func1(&a2),const A*
    //a2.func2();//A::func2(&a2),const A*  //相当于是限制条件从a2 的 const去掉了  是不允许的（常对象(指针、引用)只能调用常函数，不能调用非常函数）

    const A* pa = &a1;//pa常指针
    pa->func1();
    //pa->func2();  //和上面的原因类型

    const A& ra = a1;//ra常引用
    ra.func1();
    //ra.func2(); //和上面的原因类型
    
    
    return 0;
}
//MARK: - 常成员函数(常函数)
/**
1）在一个成员函数参数表后面加上const，这个成员函数就是常成员函数。
    返回类型 函数名(参数表) const {函数体}
2）常成员函数中的this指针是一个常量指针，不能在常成员函数中修改成员变量的值。
3）被mutable关键字修饰的成员变量，可以在常成员函数中被修改。
4）非常对象既可以调用常函数也可以调用非常函数；而常对象只能调用常函数，不能调用非常函数.
    注：常对象也包括常指针和常引用
5）同一个类中，函数名形参表相同的成员函数，其常版本和非常版本可以构成有效的重载关系，常对象匹配常版本，非常对象匹配非常版本.
*/
