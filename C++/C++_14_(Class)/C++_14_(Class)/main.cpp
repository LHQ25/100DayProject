//
//  main.cpp
//  C++_14_(Class)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

//原来:定义结构体
//现在:定义类
//struct Student{
class Student {
    
public:
    //成员函数
    void eat(const string& food){
        cout << "我在吃" << food << endl;
    }
    void sleep(int hour){
        cout << "我睡了" << hour << "小时"
            << endl;
    }
    void learn(const string& course) {
        cout << "我在学" << course << endl;
    }
    void who(void){
        cout << "我叫" << m_name << ",今年" << m_age << "岁,学号是" <<m_no<<endl;
    }
public:
    /* 类中的私有成员不能在外部直接访问,但是可
     * 以提供类似如下的公有成员函数来间接访问,
     * 在函数中可以对非法数据加以限定控制业务
     * 逻辑的合理性,这种编程思想就是"封装".*/
    void setName(const string& newName){
        if(newName == "二")
            cout << "你才二" << endl;
        else
            m_name = newName;
    }
    void setAge(int newAge){
        if(newAge < 0)
            cout << "无效年龄" << endl;
        else
            m_age = newAge;
    }
    void setNo(int newNo){
        if(newNo < 0)
            cout << "无效学号" << endl;
        else
            m_no = newNo;
    }
private:
    //属性:成员变量
    string m_name;
    int m_age;
    int m_no;
    
};

int main(int argc, const char * argv[]) {
    //原理:定义结构体变量
    //现在:创建对象/实例化对象/构造对象
    Student s;
    /*s.m_name = "张飞";
    s.m_name = "二";
    s.m_age = 25;
    s.m_no = 10011;*/
    s.setName("张翼德");
    s.setName("二");
    s.setAge(26);
    s.setAge(-2);
    s.setNo(10086);
    s.setNo(-1);
    s.who();
    s.eat("牛肉拉面");
    s.sleep(8);
    s.learn("C++编程");
    
    return 0;
}

//MARK: - 类的定义和实例化
/**
1 类定义的一般语法形式
    struct/class 类名:继承方式 基类,...{
    访问控制限定符:
            类名(形参表):初始化列表{}//构造函数
            ~类名(void){}//析构函数
            返回类型 函数名(形参表){}//成员函数
            数据类型 变量名;//成员变量
    };
2 访问控制限定符
1）public：公有成员，任何位置都可以访问。
2）private：私有成员，只有类自己的成员函数才能访问
3）protected：保护成员(后面讲)
*/
