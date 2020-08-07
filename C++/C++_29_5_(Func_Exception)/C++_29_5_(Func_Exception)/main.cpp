//
//  main.cpp
//  C++_29_5_(Func_Exception)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

using namespace std;
class A{
public:
    A(void){
        cout << "动态资源分配(new)" << endl;
        if("error"){
            cout << "动态资源释放(delete)" << endl;
            throw -1;
        }
        cout << "构造函数正常结束" << endl;
    }
    ~A(void){
        cout << "动态资源释放(delete)" << endl;
        throw -2;
        cout << "析构函数正常结束" << endl;
    }
};
int main(int argc, const char * argv[]) {
    
    try{
        A a;
    }
    catch(int ex){
        cout << "捕获到异常:" << ex << endl;
    }
    return 0;
}
//MARK: - 构造函数和析构函数中的异常 //了解
//1）构造函数可以抛出异常，但是对象将被不完整构造，这样的对象其析构不能再被自动调用执行，因此在构造函数抛出异常之前，需要手动清理之前所分配的动态资源.
//2）析构函数最好不要抛出异常
