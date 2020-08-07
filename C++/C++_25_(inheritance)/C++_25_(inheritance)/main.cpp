//
//  main.cpp
//  C++_25_(inheritance)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Human{
public:
    Human(const string& name,int age):m_name(name),m_age(age){}
    void eat(const string& food){
        cout << "我在吃" << food << endl;
    }
    void sleep(int hour){
        cout << "我睡了" << hour << "小时" << endl;
    }
protected:
    //保护成员在类的内部和子类中可以使用,类的外部不能使用
    string m_name;//姓名
    int m_age;//年龄
};

class Student: public Human{
public:
    //Human(name,age):说明基类部分的初始化方式
    Student(const string& name,int age,int no): Human(name,age),m_no(no){}
    void who(void){
        cout << "我叫" << m_name << ",今年" << m_age <<
        "岁,学号是" << m_no << endl;
    }
    void learn(const string& course){
        cout << "我在学" << course << endl;
    }
private:
    int m_no;//学号
};

class Teacher:public Human{//教师类(人类派生的另一个子类)
public:
    Teacher(const string& name, int age, int salary): Human(name,age), m_salary(salary) {}
    void who(void){
        cout << "我叫" << m_name << ",今年" << m_age <<
            "岁,工资是" << m_salary << endl;
    }
    void teach(const string& course){
        cout << "我在讲" << course << endl;
    }
private:
    int m_salary;//工资
};

int main(int argc, const char * argv[]) {
    
    Student s("关羽",30,10086);
    s.who();
    s.eat("牛肉面");
    s.sleep(6);
    s.learn("孙武兵法");
    Teacher t("孙悟空",35,50000);
    t.who();
    t.eat("桃子");
    t.sleep(2);
    t.teach("C++编程");

    //Student*-->Human*:向上造型
    Human* ph = &s;
    ph->eat("面条");
    ph->sleep(2);
    //ph->learn("xx");//error

    //Human*-->Student*:向下造型
    Student* ps = static_cast<Student*>(ph);//合理
    ps->who();

    Human h("张飞",28);
    //Human*-->Student*:向下造型
    Student* ps2 = static_cast<Student*>(&h);//不合理
    ps2->who();//结果异常,危险!
    
    return 0;
}

//MARK: - 继承(Inheritance)
//MARK: - 1 继承的概念 //了解
/**
    通过一种机制描述类型之间共性和特性的方式，利用已有的数据类型定义新的数据类型，这种机制就是继承.
    eg：
        人  类：姓名、年龄、吃饭、睡觉
        学生类：姓名、年龄、吃饭、睡觉、学号、学习
        教师类：姓名、年龄、吃饭、睡觉、工资、讲课
        ...
        ------------------------------------------
        人  类：姓名、年龄、吃饭、睡觉
        学生类 继承 人类：学号、学习
        教师类 继承 人类：工资、讲课
        ...
        
        人类(基类/父类)
       /    \
   学生类   教师类(派生类/子类)
   
   基类--派生-->子类
   子类--继承-->基类
*/
//MARK: - 2 继承的语法
/**
    class 子类:继承方式 基类1,继承方式 基类2,...{
        ......
    };
    继承方式:
    --> 公有继承(public)
    --> 保护继承(protected)
    --> 私有继承(private)
*/
//MARK: - 3 公有继承(public)的语法特性
/**
1）子类对象会继承基类的属性和行为，通过子类对象可以访问基类中的成员，如同是基类对象在访问它们一样。
  注：子类对象中包含的基类部分被称为“基类子对象”
2）向上造型(upcast)//重点掌握
   将子类类型的指针或引用转换为基类类型的指针或引用；这种操作性缩小的类型转换，在编译器看来是安全的，可以直接隐式转换.
    基 类
      ↑
    子 类
    eg: class A{};
        class B:public A{};
        class C:public A{};
        class D:public A{};
        ...
        void func1(A* pa){}
        void func2(A& ra){}
        int main(void){
            func1(&B/&C/&D...);//向上造型
            func2(B/C/D...);//向上造型
        }
3）向下造型(downcast)
    将基类类型的指针或引用转换为子类类型的指针或引用；这种操作性放大的类型转换，在编译器看来是危险的，不能隐式转换，但可以显式转换(推荐static_cast)。
    基 类
      ↓
    子 类
    
4）子类继承基类的成员
--》在子类中，可以直接访问基类中的公有和保护成员，就如同是子类自己的成员一样。
--》基类中的私有成员，子类也可以继承，但是受到访问控制属性的影响，无法直接访问；如果希望访问基类中的私有成员，可以让基类提供公有或保护的成员函数，来间接访问。

5）子类隐藏基类的成员
--》如果子类和基类定义了同名的成员函数，因为所属作用域不同，不能构成有效的重载关系，而是一种隐藏关系；通过子类对象将会优先访问子类自己的成员，基类的成员无法被使用。
--》如果希望访问基类中被隐藏的同名成员，可以通过"类名::"显式指明 //推荐
--》如果同名的成员函数参数不同，也可以通过using声明，将基类中的成员函数引入子类的作用域中，让它们形成重载，通过函数重载的参数匹配来解决。
*/
//MARK: - 4 访问控制属性和继承方式
/**
1）访问控制属性：影响类中成员的访问位置
   访问控制限定符    访问控制属性    内部访问     子类访问    外部访问    友元访问
   public            公有成员        ok            ok            ok            ok
   protected        保护成员        ok            ok            no            ok
   private            私有成员        ok            no            no            ok

2）继承方式：影响通过子类访问基类中成员的可访问性
    基类中的成员    公有继承的子类        保护继承的子类        私有继承的子类
    公有成员        公有成员            保护成员            私有成员
    保护成员        保护成员            保护成员            私有成员
    私有成员        私有成员            私有成员            私有成员

eg:
    class _Base{
    public:
        void func(void){...}
    };
    class Base:private _Base{//ok
    };
    class A:public Base{};//no
    class B:public A{};//no
    class C:public B{};//no
    ...
    --------------------------------
eg:
    class Base{
    public:
        void func(void){...}
    };
    //class Derived:public Base{};
    class Derived:private Base{};
    int main(void){
        Derived d;
        Base* pb = &d;//向上造型，error
        pb->func();
    }
    注：向上造型语法特性在保护继承和私有继承不再适用。
*/
//MARK: - 5 子类的构造函数//重点掌握
//1）如果子类构造函数没有显式指明基类子对象的初始化方式，那么编译器将会自动调用基类的无参构造函数来初始化基类子对象。
//2）如果希望基类子对象以有参的方式被初始化，则需要在子类构造函数的初始化列表中指明基类子对象的初始化方式。
