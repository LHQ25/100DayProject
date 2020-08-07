//
//  main.cpp
//  C++_28_1_(Error)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#include <cstdio>
using namespace std;
class A{
public:
    A(void){ cout << "A的构造函数" << endl; }
    ~A(void){ cout << "A的析构函数" << endl; }
};
int func3(void){
    A a;
    FILE* fp = fopen("xx.txt","r");
    if(fp == NULL){
        cout << "文件打开失败" << endl;
        return -1;
    }
    cout << "func3函数正常运行" << endl;
    fclose(fp);
    return 0;
}
int func2(void){
    A a;
    if(func3()==-1){
        return -1;
    }
    cout << "func2函数正常运行" << endl;
    return 0;
}
int func1(void){
    A a;
    if(func2() == -1){
        return -1;
    }
    cout << "func1函数正常运行" << endl;
    return 0;
}

int main(int argc, const char * argv[]) {
    
    
    if(func1()==-1){
        return -1;
    }
    cout << "main函数正常运行" << endl;
    return 0;
}
//MARK: - C++异常机制(exception)
//MARK: - 1 软件开发中的常见错误
//1）语法错误
//2）逻辑错误
//3）功能错误
//4）设计缺陷
//5）需求不符
//6）环境异常
//7）操作不当

//MARK: - 2 传统C语言中的错误处理
//1）通过返回值表示错误
//优点：函数调用路径中的所有栈对象可以得到正确析构，内存管理安全。
//缺点：错误处理流程比较麻烦，需要逐层进行返回判断，代码臃肿。

//2）通过远程跳转处理错误
//优点：错误处理流程比较简单，不需要逐层的返回值判断，一步到位的错误处理，代码精炼
//缺点：函数调用路径中的栈对象失去了被析构的机制，有内存泄漏的风险

//MARK: - 3 C++异常语法
//1）异常抛出
//   throw 异常对象;
//   注：异常对象可以是基本类型的数据，也可以是类类型对象.

//2）异常检测和捕获
//   try{
//           可能引发异常的语句;
//   }
//   catch(异常类型1){
//           针对异常类型1数据的处理.
//   }
//   catch(异常类型2){
//           针对异常类型2数据的处理.
//   }
//   ...
   
//   注：catch子句根据异常对象的类型自上而下顺序匹配，而不是最优匹配，因此对子类异常捕获语句要写在前面，否则会被基类异常捕获语句提前截获。

//MARK: - 4 函数异常说明
//1）语法
//    返回类型 函数名(参数表) throw(异常类型表) {}
//    注：“throw(异常类型表)”即为异常说明表，用于说明该函数可能抛出的异常类型
//2）函数异常说明只是一种承诺，不是强制语法要求，如果函数抛出了异常说明以外的其它类型，则无法被函数的调用者正常检测和捕获，而会被系统捕获，导致进程终止。

//3）函数异常说明的两种极端形式
//--》不写函数异常说明，表示可以抛出任何异常。
//--》空异常说明，“throw()”，表示不可以抛出任何异常。

//4）如果函数的声明和函数定义分开，要保证异常说明表中的类型一致，但是顺序无所谓。

//MARK: - 5 标准异常类exception
//    vi /usr/include/c++/编译器版本号/exception
//    class exception{
//      public:
//        exception() throw() { }
//        virtual ~exception() throw();

        /* Returns a C-style character string describing the general cause
           of the current error.  */
//       virtual const char* what() const throw();
//      };
//    注：“_GLIBCXX_USE_NOEXCEPT”即为空异常说明“throw()”
    
//eg：
//    try{
//        func();
//        ...
//    }
//    catch(exception& ex){//可以捕获exception所有子类类型异常对象
//        ex.what();
//    }

//MARK: - 6 构造函数和析构函数中的异常 //了解
//1）构造函数可以抛出异常，但是对象将被不完整构造，这样的对象其析构不能再被自动调用执行，因此在构造函数抛出异常之前，需要手动清理之前所分配的动态资源.
//2）析构函数最好不要抛出异常
