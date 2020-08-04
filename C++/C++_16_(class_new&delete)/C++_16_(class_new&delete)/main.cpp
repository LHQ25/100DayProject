//
//  main.cpp
//  C++_16_(class_new&delete)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Student{
public:
    //构造函数
    Student(const string&name,int age,int no){
        cout << "构造函数" << endl;
        m_name = name;
        m_age = age;
        m_no = no;
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


int main(int argc, const char * argv[]) {
    //在栈区创建单个对象
    //Student s("张飞",25,10011);
    Student s = Student("张飞",25,10011);
    s.who();
    
    //在栈区创建多个对象
    Student sarr[3] = {
        Student("赵云",22,10012),
        Student("马超",26,10013),
        Student("刘备",27,10014)};
    sarr[0].who();
    sarr[1].who();
    sarr[2].who();
    
    //在堆区创建单个对象
    Student* ps=new Student("貂蝉",20,10015);
    ps->who();//(*ps).who();
    delete ps;
    ps=NULL;
    
    //在堆区创建多个对象,C++11支持
    Student* parr = new Student[3] {
        Student("小乔",22,10016),
        Student("大乔",25,10017),
        Student("孙尚香",26,10018) };
    parr[0].who();//(parr+0)->who()
    parr[1].who();//(parr+1)->who()
    parr[2].who();//(parr+2)->who()

    delete[] parr;
    parr = NULL;
    
    return 0;
}

//MARK: - 对象的创建和销毁
/**
1）在栈区创建单个对象 //重点掌握
    类名 对象(构造实参表);//直接初始化
    类名 对象=类名(构造实参表);//拷贝初始化(实际等价)
eg:
    string s;
    string s("hello");
    string s = string("hello");//string s = "hello";
    
2）在栈区创建多个对象(对象数组)
    类名 对象数组[元素个数] = {
        类名(构造实参表),类名(构造实参表),...};

3）在堆区创建/销毁单个对象 //重点掌握
创建：
    类名* 对象指针 = new 类名(构造实参表);
    注：new操作符会先分配内存再自动调用构造函数，完成对象的创建和初始化；而如果是malloc函数只能分配内存，不会调用构造函数，不具备创建对象能力.
    
销毁：
    delete 对象指针;

4）在堆区创建/销毁多个对象
创建：
    类名* 对象指针 = new 类名[元素个数] {
        类名(构造实参表),类名(构造实参表),...};
销毁：
    delete[] 对象指针;
*/
