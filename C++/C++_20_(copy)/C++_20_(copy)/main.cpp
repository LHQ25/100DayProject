//
//  main.cpp
//  C++_20_(copy)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;


class Integer{
public:
    //类型转换构造函数
    Integer(int i=0){
        m_pi = new int(i);
    }
    void print(void)const{
        cout << *m_pi << endl;
    }
    ~Integer(void){
        cout << "析构函数:" << m_pi << endl;
        delete m_pi;
    }
    //缺省的拷贝构造(浅拷贝)
    /*Integer(const Integer& that){
        cout << "缺省的拷贝构造" << endl;
        m_pi = that.m_pi;
    }*/
    //自定义拷贝构造(深拷贝)
    Integer(const Integer& that){
        cout << "自定义拷贝构造" << endl;
        m_pi = new int;
        *m_pi = *that.m_pi;
    }
    //缺省的拷贝赋值(浅拷贝)
    //i3=i2 ==> i3.operator=(i2)
    /*Integer& operator=(const Integer& that){
        cout << "缺省的拷贝赋值" << endl;
        if(&that != this){//防止自赋值
            //i3.m_pi = i2.m_pi;
            m_pi = that.m_pi;
        }
        return *this;//返回自引用
    }*/
    //自定义拷贝赋值(深拷贝)
    //i3=i2 ==> i3.operator=(i2)
    Integer& operator=(const Integer& that){
        cout << "自定义拷贝赋值" << endl;
        if(&that != this){//防止自赋值
            delete m_pi;//释放旧内存
            m_pi = new int;//分配新内存
            *m_pi = *that.m_pi;//拷贝新数据
        }
        return *this;//返回自引用
    }
private:
    int* m_pi;
};
int main(int argc, const char * argv[]) {
    
    Integer i1(100);
    Integer i2(i1);//拷贝构造
    i1.print();
    i2.print();
    Integer i3;
    i3.print();//0
    //i3.operator=(i2);
    i3 = i2;//拷贝赋值
    i3.print();//100
    
    
    return 0;
}

//MARK: - 拷贝构造和拷贝赋值
//MARK: - 1 浅拷贝和深拷贝 //参考copy.png
//1）如果一个类中包含了指针形式的成员变量，缺省的拷贝构造函数只是赋值了指针变量自身，而没有复制指针所指向的内容，这种拷贝方式被称为浅拷贝.
//2）浅拷贝将会导致不同对象之间的数据共享，如果数据在堆区，析构时还可能会出现"double free"的异常，为此就必须自己定义一个支持复制指针所指向内容的拷贝构造函数，即深拷贝。

//MARK: - 2 拷贝赋值 //参考copy2.png
/**
1）当两个对象进行赋值运算时，比如"i3=i2",编译器会将其处理为“i3.operator=(i2)”成员函数调用形式，其中“operator=”被称为拷贝赋值函数，由该函数完成两个对象的赋值运算，该函数的返回结果就是赋值表达式结果.
2）如果自己没有定义拷贝赋值函数，那么编译器会提供一个缺省的拷贝赋值函数，但是缺省的拷贝赋值和缺省拷贝构造类似，也是浅拷贝，只是赋值指针变量本身，而没有复制指针所指向的内容，有数据共享、double free、内存泄漏的问题。
3）为了避免浅拷贝的问题，必须自己定义深拷贝赋值函数:
    类名& operator=(const 类名& that){
        if(&that != this){//防止自赋值
            释放旧内存;
            分配新内存;
            拷贝新数据;
        }
        return *this;//返回自引用
    }
*/
