//
//  main.cpp
//  C++_(cin & cout)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[]) {
    
    //从键盘读取一个int数据
    int num = 0;
    printf("C风格-输入一个数字:");
    scanf("%d",&num);
    printf("C风格输出：%d\n",num);
    
    int num2 = 0;
    std::cout << "C++风格-输入一个数字:";
    std::cin >> num2;
    std::cout << "C++输出：" << num2 << std::endl;
    
    //同时读取两个数字  int  double
    
    int num3 = 0;
    double num4 = 0.0;
    std::cout << "C++风格-输入两个数字:";
    std::cin >> num3 >> num4;
    std::cout << "C++输出：" << num3 << " " << num4 << std::endl;
    return 0;
}
