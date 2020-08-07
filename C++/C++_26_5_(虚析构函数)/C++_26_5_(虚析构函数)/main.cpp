//
//  main.cpp
//  C++_26_5_(虚析构函数)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

using namespace std;
class Base{
public:
    Base(void){
        cout << "基类动态资源分配" << endl;
    }
    virtual ~Base(void){//虚析构函数
        cout << "基类动态资源释放" << endl;
    }
};

class Derived:public Base{
public:
    Derived(void){
        cout << "子类动态资源分配" << endl;
    }
    ~Derived(void){//虚析构函数
        cout << "子类动态资源释放" << endl;
    }
};

int main(int argc, const char * argv[]) {
    
    Base* pb = new Derived;
    //...
    //1)pb->析构函数
    //2)释放内存
    delete pb;
    pb = NULL;
    
    return 0;
}
