//
//  main.cpp
//  C++_10_(new&new[]&delete&delete[])
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[]) {
    //动态分配内存保存1个int数据
    //int *pi = (int *)malloc(4);//C
    int *pi = new int;//c++
    
    *pi = 123;
    std::cout << *pi << std::endl;
    //free(pi);  //对应malloc
    delete pi;//防止内存泄露
    pi = NULL;//避免野指针
    
    //动态分配内存同时初始化
    int *pi2 = new int(200);
    std::cout << *pi2 << std::endl;  // 200
    (*pi2)++;
    std::cout << *pi2 << std::endl;  // 201
    delete pi2;
    *pi2 = NULL;
    
    //动态分配内存保存10个int
    //int* parr = new int[10];
    
    //new数组同时初始化,需要C++11支持
    int *parr = new int[]{1,2,3,4,5,6,7,8,9,10};
    for(int i=0;i<10;i++){
        //*(parr+i) = i+1
        //parr[i] = i+1;
        std::cout << parr[i] << ' ';
    }
    std::cout << std::endl;
    delete[] parr;
    parr = NULL;
    
    
    int *p1;
    //delete p1;//delete野指针,危险!
    int* p2 = NULL;
    delete p2;//delete空指针,安全,但是无意义
    
    int* p3 = new int;
    delete p3;
    //delete p3;//不能多次delete同一个地址
    
    return 0;
}
//MARK: - C++动态内存管理
/**
1 回顾C语言动态内存管理
1）分配：malloc()
2）释放：free()

2 C++动态内存管理
1）分配：new/new[]
2）释放：delete/delete[]
*/
