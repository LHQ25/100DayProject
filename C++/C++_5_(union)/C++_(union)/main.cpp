//
//  main.cpp
//  C++_(union)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[]) {
    
    union{//匿名联合体
        unsigned int ui;
        unsigned char uc[4];
    };
    
    ui = 0x12345678;
    //如果当前是小端字节序,下面输入结果?
    for(int i=0;i<4;i++){
        //hex:表示以16进制方式打印整数
        //showbase:显示"0x"
        std::cout << std::hex << std::showbase << (int)uc[i]
            << std::endl;
    }
    
    return 0;
}
