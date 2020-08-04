//
//  main.cpp
//  C++_(Struct)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

struct Teacher {
    //成员变量
    char name[20];
    int age;
    double salary;
    //成员函数
    void who(){
        cout << "我叫" << name << ",今年" << age <<"岁,工资是" << salary<<endl;
    }
};

int main(int argc, const char * argv[]) {
    
    Teacher t = {"老师",35,9000.8};
    t.who();
    
    Teacher *pt = &t;
    pt->who(); //(*pt).who();
    
    
    return 0;
}

//MARK: - 1 C++的结构体
//1）当定义结构体变量时可以省略struct关键字
//2）在C++的结构体内部可以直接定义函数，称为成员函数(方法)，在成员函数内部可以直接访问结构体的其它成员.
