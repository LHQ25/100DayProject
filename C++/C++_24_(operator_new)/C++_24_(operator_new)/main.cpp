//
//  main.cpp
//  C++_24_(operator_new)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#include <cstdlib>
using namespace std;
class A{
public:
    A(void){ cout << "A的构造函数" << endl; }
    ~A(void){ cout << "A的析构函数" << endl; }
    static void* operator new(size_t size){
        cout << "分配内存" << endl;
        void* pv = malloc(size);
        return pv;
    }
    static void operator delete(void* pv){
        cout << "释放内存" << endl;
        free(pv);
    }
};

int main(int argc, const char * argv[]) {
    
    //1)A* pa = (A*)A::operator new(sizeof(A))
    //2)pa->构造函数
    A* pa = new A;

    //1)pa->析构函数
    //2)A::operator delete(pa)
    delete pa;
    
    return 0;
}
