//
//  main.cpp
//  C++_17_(this)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Teacher{
public:
    /*Teacher(const string& name,int age)
        :m_name(name),m_age(age){
        cout << "构造函数:" << this << endl;
    }*/
    //通过this区分哪个是成员变量.
    Teacher(const string& m_name,int m_age){
        this->m_name = m_name;
        this->m_age = m_age;
    }
    void print(void){
        cout << m_name << "," << m_age <<endl;
        cout << this->m_name << "," << this->m_age << endl;
    }
    /*print编译器处理以后:
    void print(Teacher* this){
        cout << this->m_name << "," << this->m_age << endl;
    }*/
private:
    string m_name;
    int m_age;
};

class Counter{
public:
    Counter(int count = 0):m_count(count){}
    //Counter& add(Counter* this)
    
    Counter& add(void){
        ++m_count;
        //this指向成员函数的调用对象
        //*this就是调用对象自身
        return *this;//返回自引用
    }
    void destroy(void){
        cout << "this:" << this << endl;
        delete this;//对象自销毁
    }
    int m_count;
};


class Student;//短视声明
class Teacher2{
public:
    void educate(Student* s);
    void reply(const string& answer);
private:
    string m_answer;
};
class Student{
public:
    void ask(const string& q,Teacher2* t);
};
void Teacher2::educate(Student* s){
    s->ask("什么是this指针",this);//(1)
    cout << "学生回答:" <<m_answer <<endl;//5
}
void Teacher2::reply(const string& answer){
    m_answer = answer;//(4)
}
void Student::ask(const string& q,Teacher2* t){
    cout << "问题:" << q << endl;//(2)
    t->reply("this就是指向调用对象的地址");//3
}

int main(int argc, const char * argv[]) {
    
    //成员函数中访问类中其它成员
    Teacher t1("游成伟",35);
    Teacher t2("闵卫",45);
    t1.print();//Teacher::print(&t1)
    t2.print();//Teacher::print(&t2)

    cout << "&t1:" << &t1 << endl;
    cout << "&t2:" << &t2 << endl;
    
    //成员函数返回调用对象自身(返回自引用)
    Counter c;
    //Counter::add(&c)
    c.add().add().add();
    cout << c.m_count << endl;//3
    
    Counter* pc = new Counter;
    pc->add();
    cout << pc->m_count << endl;//1
    //delete pc;
    cout << "pc:" << pc << endl;
    pc->destroy();
    
    //作为成员函数实参，实现对象之间交互
    Teacher2 t;
    Student s;
    t.educate(&s);
    
    return 0;
}

//MARK: - this指针
/**
1 this指针
1）类中的成员函数(包括构造函数、析构函数)都有一个隐藏的当前类类类型的指针参数，名为this。在成员函数中访问类中其它成员，其本质都是通过this来实现的。
2）对于普通的成员函数,this指针就是指向该成员函数的调用对象；对于构造函数,this指针就指向正在创建的对象。
3）大多数情况，可以忽略this直接访问类中的成员，但是在以下几个特殊场景必须要显式使用this指针:
--》区分作用域
--》从成员函数返回调用对象自身(返回自引用)//重点掌握
--》从类的内部销毁对象自身(对象自销毁) //了解
--》作为成员函数实参，实现对象之间交互 //了解
*/
//MARK: - 2 常成员函数(常函数)
/**
1）在一个成员函数参数表后面加上const，这个成员函数就是常成员函数。
    返回类型 函数名(参数表) const {函数体}
2）常成员函数中的this指针是一个常量指针，不能在常成员函数中修改成员变量的值。
3）被mutable关键字修饰的成员变量，可以在常成员函数中被修改。
4）非常对象既可以调用常函数也可以调用非常函数；而常对象只能调用常函数，不能调用非常函数.
    注：常对象也包括常指针和常引用
5）同一个类中，函数名形参表相同的成员函数，其常版本和非常版本可以构成有效的重载关系，常对象匹配常版本，非常对象匹配非常版本.
*/
