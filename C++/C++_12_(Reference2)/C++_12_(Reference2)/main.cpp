//
//  main.cpp
//  C++_12_(Reference2)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

int func(){
    
    int num = 123;
    cout << "&num:" << &num << endl;
    return num;//临时变量=num
}

void swap1(int* x,int* y){
    *x = *x ^ *y;
    *y = *x ^ *y;
    *x = *x ^ *y;
}
void swap2(int& x,int& y){
    x = x ^ y;
    y = x ^ y;
    x = x ^ y;
}

struct Teacher{
    char name[100];
    int age;
    double salary;
};
void printInfo(const Teacher& t){
    cout << t.name << "," << t.age/*++*/<< ","
        << t.salary << endl;
}

struct A{
    int data;
    int& func(void){
        return data;
    }
    int& func2(void){
        int num = 100;
        return num;//危险!!
    }
};
int main(int argc, const char * argv[]) {
    
    //临时变量引用
    int c = 100;
    //1)将c转换为char,转换结果保存到临时变量
    //2)rc实际要引用不是c而是临时变量
    //char& rc = c;//error
    const char& rc = c;//ok
    cout << "&c:" << &c << endl;
    cout << "&rc:" << (void*)&rc << endl;
    
    //函数返回值引用
    //rf = 临时变量
    //int& rf = func();//error
    const int& rf = func();
    cout << "&rf:" << &rf << endl;
    cout << rf << endl;//123
    
    //函数的参数引用
    int a = 10,b = 20;
    swap1(&a,&b); //交换过去
    cout << "a=" << a << ",b=" << b << endl;
    swap2(a,b); //交换回来
    //a=20,b=10;
    cout << "a=" << a << ",b=" << b << endl;
    
    
    //结构体引用
    const Teacher t={"teacher",45,80000.5};
    printInfo(t);
    printInfo(t);
    
    //
    A aa = {100};
    cout << aa.data << endl;//100
    //a.data = 200
    aa.func() = 200; //ok  (返回值是结构体中data的引用)aa.func() -> data
    cout << aa.data << endl;//200
    
    return 0;
}

//MARK: - 3 引用型函数参数
//1）可以将引用用于函数的参数，这时形参就是实参别名，可以通过形参直接修改实参的值；同时还能避免函数调用时传参的开销，提高代码执行效率。
//2）引用型参数有可能意外修改实参的值，如果不希望修改实参，可以将形参声明为常引用，提高效率的同时还可以接收常量型的实参。

//MARK: - 4 引用型函数返回值
/**
1）可以将函数的返回类型声明为引用，这时函数的返回结果就是return后面数据的别名，可以避免返回值带来的开销，提高代码执行效率.
2）如果函数返回类型是左值引用，那么函数调用表达式结果就也将是一个左值。
    注：不要从函数中返回局部变量的引用，因为所引用的内存会在函数返回以后被释放，使用非常危险！可以在函数中返回成员变量、静态变量、全局变量的引用。

    int& func(void){
        ...
        return num;
    }
    func() = 100;//ok
    */
//MARK: - 5 引用和指针
/**
1）如果从C语言角度看待引用的本质，可以认为引用就是通过指针实现的，但是在C++开发中，推荐使用引用，而不推荐使用指针.
    int i = 100;
    int* const pi = &i;
    int& ri = i;
    *pi <=等价=> ri
2）指针可以不做初始化，其目标可以在初始化以后随意改变(指针常量除外)，而引用必须做初始化，而且一旦初始化所引用的目标不能再改变.
    int a=10,b=20;
    int* p;//ok
    p = &a;
    p = &b;
    --------------------
    int& r;//error
    int& r = a;
    r = b;//ok,但不是修改引用目标，仅是赋值运算
    */
//下面内容了解
/**
3）可以定义指针的指针(二级指针)，但是不能定义引用的指针.
    int a = 10;
    int* p = &a;
    int** pp = &p;//二级指针
    ------------------------
    int& r = a;
    int&* pr = &r;//error,引用的指针
    int* pr = &r;//ok,仅是普通指针
    
4）可以指针的引用(指针变量别名)，但是不能定义引用的引用。
    int a = 100;
    int* p = &a;
    int* & rp = p;//ok,指针的引用
    -----------------------------
    int& r = a;
    int& & rr = r;//error,引用用的引用
    int& rr = r;//ok,但是仅是一个普通引用
    
5）可以指针数组，但是不能定义引用数组
    int i=10,j=20,k=30;
    int* parr[3] = {&i,&j,&k};//ok,指针数组
    int& rarr[3] = {i,j,k};//error
    
6）可以定义数组引用（数组别名）
    int i=10,j=20,k=30;
    int arr[3] = {i,j,k};
    int (&rarr)[3] = arr;//ok,    数组引用

7）和函数指针类似，也可以定义函数引用(函数别名)
    void func(int i){}
    int main(void){
        void (*pf)(int) = func;//函数指针
        void (&rf)(int) = func;//函数引用
        pf(100);
        rf(100);
    }
*/
