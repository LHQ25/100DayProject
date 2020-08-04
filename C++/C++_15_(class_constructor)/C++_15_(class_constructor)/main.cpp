//
//  main.cpp
//  C++_15_(class_constructor)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Student{
public:
    //无参构造函数  没有其它构造函数时默认生成，当有其它构造函数时需要自己写
    Student(){
        cout << "无参构造函数" << endl;
    }
    
    //类型转换构造函数
    Student(int a){
        cout << "类型转换构造函数" << endl;
        m_age = a;
    }
    
    //构造函数
    Student(const string&name, int age, int no){
        cout << "构造函数" << endl;
        m_name = name;
        m_age = age;
        m_no = no;
    }
    //拷贝构造函数
    Student(const Student& m){
        cout << "拷贝构造函数" << endl;
        m_name = m.m_name;
        m_age = m.m_age;
        m_no = m.m_no;
    }
    
    //行为:成员函数
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
        cout << "我叫" << m_name << ",今年" <<
            m_age << "岁,学号是" <<m_no<<endl;
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

class Teacher {
    
public:
    Student s;
};

int main(int argc, const char * argv[]) {
    //栈区  无参
    Student s1;
    s1.who();
    //堆区 无参
    Student *s2 = new Student;
    s2->who();
    delete s2;
    
    
    //类型转换构造函数
    Student i;
    i.who();//0
    //1)通过类型转换构造函数将100转为Student对
    //象,转换结果会保存到一个临时对象中
    //2)再使用临时对象对i进行赋值操作
    i = 100;
    i.who();//100
    
    //上面代码可读性差,推荐使用下面显式转换
    //i = (Student)200;//C风格
    i = Student(200);//C++风格
    i.who();//200
    
    
    //带参数的构造函数
    //创建对象(自动调用构造函数)
    //(...):指定构造函数需要的实参
    Student s("张飞",25,10011);
    s.who();
    
    //构造函数不能显式调用
    //s.Student("张三",26,10086);
    
    
    //拷贝构造函数
    Student s4 = s;
    s.who();
    //对于子对象
    Teacher t; // Student的无参构造函数
    Teacher t2(t); // Student的拷贝构造函数
    
    return 0;
}
//MARK: - 构造函数(constructor)
/**
1）语法
    class 类名{
        类名(参数表){
            主要负责初始化对象，即初始化成员变量。
        }
    };
2）函数名和类名一致，没有返回类型。
3）构造函数在创建对象时自动被调用，不能像普通的成员函数一样显式的调用.
4）在每个对象的生命周期，构造函数一定会被调用，且仅会被调用一次。
*/
//MARK: -1 构造函数可以重载，也可以带有缺省参数
/**
    //匹配string的无参构造函数
    string s;
    //匹配string的有参(const char*)构造函数
    string s("hello");
    ---------------------------------
    http://www.cplusplus.com/
    */
//MARK: - 2 缺省构造函数(无参构造函数)
/**
1）如果类中没有定义任何构造函数,编译器会为该类提供一个缺省(无参)构造函数：
--》对于基本类型成员变量不做初始化
--》对于类 类型的成员变量(成员子对象)，将会自动调用相应类的无参构造函数来初始化

2）如果自己定义了构造函数，无论是否有参数，那么编译器都不会再提供缺省的无参构造函数了.
*/
//MARK: - 3 类型转换构造函数(单参构造函数)
/**
    class 类名{
        //可以将源类型变量转换为当前类类型对象.
        类名(源类型){...}
    };
    -----------------------------------
    class 类名{
        //加“explicit”关键字修饰，可以强制要求这种类型
        //转换必须显式的完成.
        explicit 类名(源类型){...}
    };
*/
//MARK: - 4 拷贝构造函数(复制构造函数)
/**
1）用一个已存在的对象作为同类对象的构造实参，创建新的副本对象时，会调用该类拷贝构造函数。
    class 类名{
        类名(const 类名&){//拷贝构造
            ...
        }
    };
    ------------
    eg：
    class A{...}；
    A a1(...);
    A a2(a1);//匹配A的拷贝构造函数
    
2）如果一个类没有自己定义拷贝构造函数，那么编译器会为该类提供一个缺省的拷贝构造函数：
--》对于基本类型的成员变量，按字节复制
--》对于类类型的成员变量(成员子对象)，将自动调用相应类的拷贝构造函数来初始化

注：一般不需要自己定义拷贝构造函数函数，因为编译器缺省提供的已经很好用了.

    class A1{};//缺省无参，缺省拷贝
    class A2{//缺省拷贝
        A(void){}
    };
    class A3{//缺省拷贝
        A(int){}
    }；
    class A4{//没有缺省构造
        A(const A&){}
    };

3）拷贝构造函数调用时机
--》用一个已存在对象作为同类对象的构造实参
--》以对象形式向函数传递参数
--》从函数中返回对象(有可能被编译器优化掉)
*/
