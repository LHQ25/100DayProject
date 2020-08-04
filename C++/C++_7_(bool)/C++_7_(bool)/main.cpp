//
//  main.cpp
//  C++_7_(bool)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[]) {
    
    bool b = false;
    std::cout << "b=" << b << std::endl;//0
    std::cout << "size=" << sizeof(b) << std::endl;//1
    
    b = 3 + 5;
    std::cout << "b=" << b << std::endl;//1
    b = 1.2 * 3.4;
    std::cout << "b=" << b << std::endl;//1
    int* p = NULL;//NULL->(void*)0
    b = p;
    std::cout << "b=" << b << std::endl;//0
    
    
    return 0;
}

//C++的布尔类型(bool)
//1 bool类型是C++中的基本数据类型，专门表示逻辑值，逻辑真用true表示，逻辑假false表示
//2 bool类型在内存占一个字节：1表示true，0表示false
//3 bool类型变量可以接收任意类型表达式结果，其值非0则为true，为0则为假。
