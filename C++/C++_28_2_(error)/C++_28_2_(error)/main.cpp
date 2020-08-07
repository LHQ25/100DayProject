//
//  main.cpp
//  C++_28_2_(error)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

#include <cstdio>
#include <csetjmp>
using namespace std;
jmp_buf g_env;
class A{
public:
    A(void){ cout << "A的构造函数" << endl; }
    ~A(void){ cout << "A的析构函数" << endl; }
};
int func3(void){
    A a;
    FILE* fp = fopen("xx.txt","r");
    if(fp == NULL){
        longjmp(g_env,-1);
    }
    cout << "func3函数正常运行" << endl;
    fclose(fp);
    return 0;
}
int func2(void){
    A a;
    func3();
    cout << "func2函数正常运行" << endl;
    return 0;
}
int func1(void){
    A a;
    func2();
    cout << "func1函数正常运行" << endl;
    return 0;
}

//MARK: -  通过远程跳转处理错误
//优点：错误处理流程比较简单，不需要逐层的返回值判断，一步到位的错误处理，代码精炼
//缺点：函数调用路径中的栈对象失去了被析构的机制，有内存泄漏的风险
int main(int argc, const char * argv[]) {
    
    if(setjmp(g_env) == -1){
        cout << "文件打开失败" << endl;
        return -1;
    }
    func1();
    cout << "main函数正常运行" << endl;
    return 0;
}
