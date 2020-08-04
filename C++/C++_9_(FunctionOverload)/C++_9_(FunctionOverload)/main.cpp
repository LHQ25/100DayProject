//
//  main.cpp
//  C++_9_(FunctionOverload)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

//MARK: - 基础
int func(int i){
    std::cout << "func(int i)" << std::endl;
    return 0;
};

int func(int i, int y){
    std::cout << "func(int i, int y)" << std::endl;
    return 0;
};

void func(float i, int y){
    std::cout << "func(float i, int y)" << std::endl;
};

//MARK: 升级
//char->int:升级转换
void bar(int i){
    std::cout << "bar(1)" << std::endl;
}
//char->const char:常量转换
void bar(const char c){
    std::cout << "bar(2)" << std::endl;
}
//short->char:降级转换
void hum(char c){
    std::cout << "hum(1)" << std::endl;
}
//short->int:升级转换
void hum(int i){
    std::cout << "hum(2)" << std::endl;
}
//省略号匹配
void fun(int i,...){
    std::cout << "fun(1)" << std::endl;
}
//double->int:降级转换
void fun(int i,int j){
    std::cout << "fun(2)" << std::endl;
}

//MARK: - 默认参数
//函数声明
void func_def(int a,int b = 20,int c = 30);
//void func_def(int i){}//注意歧义错误

//没有函数声明可以直接这样写
void func_def_2(int a,int b = 20,int c = 30){
    std::cout << "a=" << a << ",b=" << b << ",c="
    << c << std::endl;
}

//MARK: - 函数的哑元参数
void func_def_3(...){
    std::cout << "哑元参数,参数随便传  但是不会被用到" << std::endl;
}

//内联函数
inline void func_def_4(int i){
    std::cout << "内联函数" << i << std::endl;
}
int main(int argc, const char * argv[]) {
    
    func(10);
    func(11, 14);
    //func(190.8, 23);//歧义错误
    func(190.8f, 23);
    
    //由函数指针类型决定匹配的重载版本
    void (*pFunc)(float,int) = func;
    pFunc(90.0,11);
    
    
    char c = 'a';
    bar(c);
    short s = 100;
    hum(s);
    fun(100,3.14);
    
    
    func_def(11,22,33);
    func_def(11,22);//11 22 30
    func_def(11);//11 20 30
    
    func_def_2(11,22,33);
    func_def_2(11,22);//11 22 30
    func_def_2(11);//11 20 30
    
    func_def_3(0000);
    
    func_def_4(9);
    return 0;
}
//函数定义
void func_def(int a,int b/*=20*/,int c/*=30*/){
    std::cout << "a=" << a << ",b=" << b << ",c="
        << c << std::endl;
}

//MARK: - 函数重载(overload)
//MARK: - 1 定义
/**
    在相同作用域，可以定义同名的函数，但是参数必须有所区分，这样函数构成重载关系.
    注：函数重载和返回类型无关。
    
eg:实现图形库中一些绘图函数
    //C语言
    void drawRect(int x,int y,int w,int h){}
    void drawCircle(int x,int y,int r){}
    ...
    -----------------
    //C++语言
    void draw(int x,int y,int w,int h){}
    void draw(int x,int y,int r){}
    ...
*/
//MARK: - 1）函数重载匹配
    //调用重载关系的函数时，编译器将根据实参和形参的匹配程度，自动选择最优的重载版本，当前g++编译器匹配一般规则：
    //完全匹配>=常量转换>升级转换>降级转换>省略号

//MARK: - 2）函数重载原理
/**
    C++的编译器在编译函数时，会进行换名，将参数表的类型信息整合到新的函数名中，因为重载关系的函数参数表有所区分，换出的新的函数名也一定有所区分，解决了函数重载和名字冲突的矛盾。
    
    笔试题：C++中extern "C"作用？
    在C++函数声明时加extern "C"，要求C++编译器不对该函数进行换名，便于C程序直接调用该函数.
    
    注：extern "C"的函数无法重载。
*/
//MARK: - 2 函数的缺省参数(默认实参)
//1）可以为函数参数指定缺省值，调用该函数时，如果不给实参，就取缺省值作为默认实参。
    //void func(int i,int j=0/*缺省参数*/){}
//2）靠右原则：如果函数的某个参数带有缺省值，那么该参数右侧的所有参数都必须带有缺省值。
//3）如果函数的声明和定义分开写，缺省参数应该写在函数的声明部分，而定义部分不写。

//MARK: - 3 函数的哑元参数
//1）定义函数时，只有类型而没有变量名的形参被称为哑元
    //void func(int){...}
//2）需要使用哑元场景
/**
--》在操作符重载函数中，区分前后++、-- //后面讲
--》兼容旧的代码

    算法库：void math_func(int a,int b){...}
    使用者：
        int main(void){
            ...
            math_func(10,20);
            ...
            math_func(10,20);
            ...
        }
    -----------------------------------------
    升级算法库:void math_func(int a,int // 哑元
    )
    {...}
    使用者：
        int main(void){
            ...
            math_func(10,20);
            ...
            math_func(10,20);
            ...
        }
*/
//MARK: - 4 内联函数(inline)
/**
1）使用inilne关键字修饰的函数，即为内联函数，编译器将会尝试进行内联优化，可以避免函数调用开销，提高代码执行效率.
    inline void func(void){...}
2）使用说明
--》多次调用小而简单的函数适合内联优化
--》调用次数极少或大而复杂的函数不适合内联
--》递归函数不能内联优化
--》虚函数不能内联优化//后面讲

注：内联只是一种建议而不是强制的语法要求，一个函数能否内联优化主要取决于编译器，有些函数不加inline修饰也会默认处理为内联优化，有些函数即便加了inline修饰也会被编译器忽略。
*/
