//
//  main.cpp
//  C++_24_(operator_())
//
//  Created by 亿存 on 2020/8/5.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;
class Func{
public:
    int operator()(int a,int b){
        return a * b;
    }
    int operator()(int a){
        return a * a;
    }
};
int main(int argc, const char * argv[]) {
    
    Func func;//仿函数
    //func.operator()(100,200)
    cout << func(100,200) << endl;//20000
    //func.operator()(100)
    cout << func(100) << endl;//10000
    
    return 0;
}
