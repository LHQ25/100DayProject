//
//  main.cpp
//  C++_34_(operator)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class Complex {
    
public:
    ///构造函数
    Complex(int r, int i): m_r(r), m_i(i){
        
    }
    
    ///打印
    void print(void) const {
        cout << m_r << '+' << m_i << 'i' << endl;
    }
    //重载+:成员函数形式
    //c1+c2 ==> c1.operator+(c2)
    //1)修饰返回值:禁止对表达式结果再赋值
    //2)常引用参数:支持常量型右操作数
    //3)常成员函数:支持常量型左操作数
    const Complex operator+(const Complex& c) const{
        
        Complex res(m_r + c.m_r, m_i + c.m_i);
        return res;
    }
    
    //+=:成员函数形式
    //c1+=c2 ==> c1.operator+=(c2)
    Complex& operator+=(const Complex& c){
        m_r += c.m_r;
        m_i += c.m_i;
        return *this;
    }
    
    
    
    int m_r;//实部
    int m_i;//虚部
    
    //友元函数
    friend const Complex operator-(const Complex& l, const Complex& r);
    //-=:全局函数形式
    //友元函数可以定义在类的内部,但本质还是全局函数
    //c1-=c2 ==> operator-=(c1,c2)
    friend Complex& operator-=(Complex& l, const Complex& r){
        l.m_r -= r.m_r;
        l.m_i -= r.m_i;
        return l;
    }
};
//重载-:全局函数形式
//c2-c1 ==> operator-(c2,c1)
const Complex operator-(const Complex& l, const Complex& r){
    Complex res(l.m_r-r.m_r,l.m_i-r.m_i);
    return res;
}


int main(int argc, const char * argv[]) {
    
    const Complex c1(1,2);
    const Complex c2(3,4);
    c1.print();
    c2.print();
//    Complex c3 = c1.operator+(c2);//太麻烦
//    c3.print();
    Complex c4 = c1 + c2;
    c4.print();
    
//    Complex c5 = operator-(c2,c1);//太麻烦
//    c5.print();
    Complex c6 = c2 - c1;
    c6.print();
    
    
    Complex c7(1,2);
    Complex c8(3,4);
    c7+=c8;//c1.operator+=(c2)
    c7.print();//4+6i

    Complex c9(5,6);
    (c7+=c8) = c9;
    c7.print();//5+6i

    c7-=c8;//operator-=(c1,c2)
    c7.print();//2+2i

    (c7-=c8) = c9;
    c7.print();//5+6i
    
    return 0;
}

//MARK: - 操作符重载(operator)
//MARK: -1 双目操作符重载 L#R
//MARK: -1.1 计算类双目操作符： + - ...
/**
1）表达式结果是右值，不能对表达式结果再赋值
2）左右操作数既可以是左值也可以是右值
3）两种具体实现方式
--》成员函数形式(左调右参)
    L#R的表达式可以被编译器处理为"L.operator#(R)"成员函数调用形式，该函数的返回就是表达式结果。
--》全局函数形式(左右都参)
    L#R的表达式可以被编译器处理为"operator#(L,R)"全局函数调用形式，该函数的返回就是表达式结果。
    注：通过friend关键字可以把一个全局函数声明为某个类的友元，对于友元函数可以访问类中的任何成员。

//MARK: -1.2 赋值类双目操作符： += -= ...
1）表达式结果是左值，就是左操作数的自身
2）左操作数一定是左值，右操作数可以是左值也可以是右值
3）两种具体实现方式
--》成员函数形式(左调右参),L#R ==> L.operator#(R)
--》全局函数形式(左右都参),L#R ==> operator#(L,R)

//MARK: -2 单目操作符重载 #O
//MARK: -1.1 计算类单目操作符：-(负) ~(位反) ...
1）表达式结果是右值，不能对表达式结果再赋值
2）操作数既可以是左值也可以是右值
3）两种具体实现方式
--》成员函数形式：#O ==> O.operator#()
--》全局函数形式：#O ==> operator#(O)
*/
//MARK: -1.2 自增减单目操作符：++ -- ...
/**
1）前++、--
--》表达式结果是左值，就是操作数自身
--》操作数一定是左值
--》两种具体实现方式
    成员函数形式：#O ==> O.operator#()
    全局函数形式：#O ==> operator#(O)

2）后++、--
--》表达式结果是右值，是操作数自增减前副本，不能对表达结果再赋值
--》操作数一定是左值
--》两种具体实现方式
    成员函数形式：O# ==> O.operator#(int   //哑元)
    全局函数形式：O# ==> operator#(O,int   //哑元)
    */
//MARK: -3 输出(插入)和输入(提取)操作符重载: <<  >>
/**
功能：实现自定义类型对象的直接输出或输入
注：只能使用全局函数形式，不能使用成员函数形式
    
    #include <iostream>
    ostream //标准输出流类，cout就是该类实例化的对象
    istream //标准输入流类，cin就是该类实例化的对象
    
    //全局函数形式：operator<<(cout,a)
    cout << a;
    //全局函数形式：operator>>(cin,a)
    cin << b;
    ------------------------------------------------
    friend ostream& operator<<(ostream& os,const Right& right){
        ...
        return os;
    }
    friend istream& operator>>(istream& is,Right& right){
        ...
        return is;
    }
*/

//MARK: - 4 下标操作符重载 []
/**
功能：实现自定义类型对象能够像数组一样去使用
注：非常对象返回左值，常对象返回右值
    string s = "minwei";
    s[0] = 'M';//s.operator[](0) = 'M'
    s[3] = 'W';//s.operator[](3) = 'W'
    cout << s << endl;//"MinWei"
    ---------------------------------
    const string s2 = "youchengwei";
    cout << s2[0] << endl;//y
    s2[0] = 'Y';//error
    */
//MARK: - 5 函数操作符重载 ()
 /**
功能：实现让自定义类型对象像函数一样使用//仿函数
注：对于参数个数、参数类型和返回类型没有任何限制
    A a(..);
    a(100,1.23);//a.operator()(100,1.23)

//MARK: - 6 new/delete操作符重载 //了解
static void* operator new(size_t size){...}
static void operator delete(void* p){...}
*/
//MARK: - 7 操作符重载限制
/**
1）不是所有操作符都能重载，下面几个操作符不能重载
--》作用域限定操作符 "::"
--》直接成员访问操作符 "."
--》直接成员指针解引用操作符 ".*"
--》条件操作符 "?:"
--》字节长度操作符 "sizeof"
--》类型信息操作符 "typeid"//后面讲
2）如果一个操作符所有的操作数都是基本类型，则无法重载
3）操作符重载不会改变预定的优先级
4）操作符重载不会改变操作数个数
5）不能通过操作符重载发明新的操作符
6）只能使用成员函数形式重载的操作符
    = [] () ->
*/
