//
//  main.cpp
//  C++_29_3_(Func_Exception)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;

class FileError{};
class MemoryError{};

void func(void) throw(MemoryError,FileError) ;//函数声明

//说明func可能会抛出FileError或MemoryError异常类型
void func(void) throw(FileError,MemoryError) {//函数定义
    throw FileError();
    //throw MemoryError();
}


int main(int argc, const char * argv[]) {
    
    try{
        func();
    }
    catch(FileError& ex){
        cout << "针对文件相关错误处理" << endl;
    }
    catch(MemoryError& ex){
        cout << "针对内存相关错误处理" << endl;
    }
    return 0;
}
//MARK: - 函数异常说明
//1）语法
//    返回类型 函数名(参数表) throw(异常类型表) {}
//    注：“throw(异常类型表)”即为异常说明表，用于说明该函数可能抛出的异常类型
//2）函数异常说明只是一种承诺，不是强制语法要求，如果函数抛出了异常说明以外的其它类型，则无法被函数的调用者正常检测和捕获，而会被系统捕获，导致进程终止。
//
//3）函数异常说明的两种极端形式
//--》不写函数异常说明，表示可以抛出任何异常。
//--》空异常说明，“throw()”，表示不可以抛出任何异常。
//
//4）如果函数的声明和函数定义分开，要保证异常说明表中的类型一致，但是顺序无所谓。
