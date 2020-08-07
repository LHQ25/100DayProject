//
//  main.cpp
//  C++_22_(Singleton_hungry)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Singleton{//单例模式--饿汉式
public:
    //3)通过静态成员函数获取单例对象
    static Singleton& getInstance(void){
        return s_instance;
    }
    void print(void){
        cout << m_data << endl;
    }
private:
    //1)私有化构造函数(包括拷贝构造)
    Singleton(int data=0):m_data(data){
        cout << "单例对象被创建了" << endl;
    }
    Singleton(const Singleton&);
    //2)使用静态成员变量表示唯一的对象
    static Singleton s_instance;
private:
    int m_data;
};

//单例初始化（程序启动时）
Singleton Singleton::s_instance(123);

int main(int argc, const char * argv[]) {
    
   cout << "main函数开始执行" << endl;
    //Singleton s(100);//error
    //Singleton* ps=new Singleton(100);//error
    
    Singleton& s1=Singleton::getInstance();
    Singleton& s2=Singleton::getInstance();
    Singleton& s3=Singleton::getInstance();
    
    s1.print();//123
    s2.print();//123
    s3.print();//123

    cout << "&s1:" << &s1 << endl;
    cout << "&s2:" << &s2 << endl;
    cout << "&s3:" << &s3 << endl;

    //Singleton s4 = s1;//应该error
    //cout << "&s4:" << &s4 << endl;
    return 0;
}
//MARK: - 单例模式
/**
1）概念
    一个类只允许存在唯一的对象，并提供它的方法.
2）实现思路
--》禁止在类的外部创建对象：私有化构造函数即可
--》类的内部维护唯一的对象：静态成员变量
--》提供单例对象的访问方法：静态成员函数
3）具体创建方式
--》饿汉式：单例对象无论用或不用，程序启动即创建
--》懒汉式：单例对象用时再创建，不用即销毁
*/
