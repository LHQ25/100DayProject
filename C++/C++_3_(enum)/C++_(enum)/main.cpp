//
//  main.cpp
//  C++_(enum)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[]) {
    
    enum Color {RED=10,BLUE,GREEN};
    std::cout << RED << "," << BLUE << "," <<
        GREEN << std::endl;
    /*enum*/ Color c;
    //c = 10;//C:ok,C++:error
    c = RED;//C:ok,C++:ok
    std::cout << c << std::endl;//10
    return 0;
}
