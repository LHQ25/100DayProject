//
//  main.cpp
//  C++_29_1_(Exception)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#include <cstdio>
using namespace std;
class FileError{
public:
    FileError(const string& file, int line): m_file(file), m_line(line){
        cout << "出错位置:" << m_file << "," << m_line << endl;
    }
private:
    string m_file;
    int m_line;
};

class A{
public:
    A(void){ cout << "A的构造函数" << endl; }
    ~A(void){ cout << "A的析构函数" << endl; }
};
int func3(void){
    A a;
    FILE* fp = fopen("xx.txt","r");
    if(fp == NULL){
        throw FileError(__FILE__,__LINE__);//抛出类类型异常对象
        //throw -1;//抛出基本类型异常数据
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


int main(int argc, const char * argv[]) {
    
    try{//异常检测
        func1();
        cout << "main函数正常运行" << endl;
    }catch(int ex){//捕获异常
        if(ex == -1){
            cout << "文件打开失败!" << endl;
            return -1;
        }
    }catch(FileError& ex){
        cout << "File Open Error!" << endl;
        return -1;
    }
    return 0;
}
