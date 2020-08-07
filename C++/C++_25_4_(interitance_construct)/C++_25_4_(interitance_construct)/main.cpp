//
//  main.cpp
//  C++_25_4_(interitance_construct)
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;
class Base{
public:
    Base(void):m_i(0){
        cout << "Base(void)" << endl;
    }
    Base(int i):m_i(i){
        cout << "Base(int)" << endl;
    }
    int m_i;
};

class Drived: public Base{
    
public:
    Drived(void){cout << "Derived(void)" << endl;}
    
    //Base(i):指明基类子对象的初始化方式
    Drived(int i): Base(i) {
        
        cout << "Derived(int)" << endl;
    }
};

int main(int argc, const char * argv[]) {
    
    Drived d1;
    cout << d1.m_i << endl;//0
    Drived d2(123);
    cout << d2.m_i << endl;//123
    return 0;
}
