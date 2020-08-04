//
//  main.cpp
//  C++_16_(class_初始化列表)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class A{
public:
    A(int data){
        cout << "A(int)" << endl;
        m_data = data;
    }
    int m_data;
};

class B{
public:
    //m_a(123):显式指明成员子对象初始化方式
    B(void):m_a(123){
        cout << "B(void)" << endl;
    }
    A m_a;//成员子对象
};

int g_num = 200;
class C{
public:
    C(void):ci(100),ri(g_num){}
    const int ci;
    int& ri;
};


class Dummy{
public:
    Dummy(const char* str)
        //:m_str(str),m_len(m_str.size()){}
        //:m_str(str),m_len(strlen(str)){}
        :m_str(str?str:""),
         m_len(strlen(str?str:"")){}
    size_t m_len;
    string m_str;
};

int main(int argc, const char * argv[]) {
    
    //简单的初始化
    A a(90);
    cout << a.m_data << endl;//123
    
    //子类自动初始化
    B b;
    cout << b.m_a.m_data << endl;//123
    
    //初始化中含有 const 或 引用变量的类
    C c;
    cout << c.ci << endl;//100
    cout << c.ri << endl;//200
    
    //成员变量的初始化顺序由声明顺序决定，而与初始化列表的顺序无关
    //Dummy d("hello");
    Dummy d(NULL);
    cout << d.m_str << "," << d.m_len << endl;
    return 0;
}

//MARK: - 初始化列表
/**
1）语法
    class 类名{
        类名(参数表):成员变量1(初值),成员变量2(初值){
            ...
        }
    };
eg：
    class Student{
    public:
        //先定义成员变量，再赋初值
        Student(const string& name,int age,int no){
            m_name = name;
            m_age = age;
            m_no = no;
        }
        //定义成员变量同时初始化
        Student(const string& name,int age,int no)
            :m_name(name),m_age(age),m_no(no){
        }
    private:
        string m_name;
        int m_age;
        int m_no;
    };
2）大多数情况使用初始化列表和在构造函数体赋初值没有太大区别，两种形式可以任选；但是有以下特殊场景必须要使用初始化列表:
--》如果有类 类型的成员变量(成员子对象)，并希望以有参方式对其进行初始化，则必须使用初始化列表显式指明成员子对象需要的构造实参。
--》如果类中包含"const"或"引用"成员变量，则必须在初始化列表显式的初始化。
注：成员变量的初始化顺序由声明顺序决定，而与初始化列表的顺序无关，所以不要使用一个成员变量去初始化另一个成员变量.
*/
