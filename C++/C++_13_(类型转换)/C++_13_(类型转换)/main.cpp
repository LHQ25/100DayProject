//
//  main.cpp
//  C++_13_(类型转换)
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;
int main(int argc, const char * argv[]) {
    
    int* pi = NULL;
    //char c = (long)pi;//C风格强转
    char c = long(pi);//C++风格强转

    //静态类型转换
    //char c2 = static_cast<long>(pi);//不合理
    void* pv = pi;
    pi = static_cast<int*>(pv);//合理
    
    //去常类型转换
    //volatile是标准C语言的关键字
    //被volatile修饰的变量表示易变的,告诉编译
    //器每次使用该变量时,都要小心从内存中读取,
    //而不是取寄存器的副本,防止编译器优化引发
    //的错误结果.
    volatile const int i = 100;
    int* pi2 = const_cast<int*>(&i);
    *pi2 = 200;
    cout << "i=" << i << ",*pi=" << *pi2 << endl;//200,200
    cout << "&i=" << (void*)&i << ",pi=" << pi2 << endl;
    
    
    //重解释类型转换
    //"\000"-->'\0'
    char buf[] = "0001\00012345678\000123456";
    struct HTTP{
        char type[5];
        char id[9];
        char passwd[7];
    };
    HTTP* pt = reinterpret_cast<HTTP*>(buf);
    cout << pt->type << endl;//0001
    cout << pt->id << endl;//12345678
    cout << pt->passwd << endl;//123456
    
    return 0;
}

//MARK: - 类型转换
//MARK: - 1 隐式类型转换
/**
  char c = 'A';
  int i = c;//隐式
  -----------------
  void func(int i){}
  func(c);//隐式
  -----------------
  int func(void){
          char c='A';
          return c;//隐式
  }
*/
//MARK: - 2 显示类型转换
//MARK: -2.1 C++兼容C中强制类型转换
/**
    char c = 'A';
      int i = (int)c;//C风格
      int i = int(c);//C++风格
      */
//MARK: - 2.2 C++扩展了四种操作符形式显式转换
/**
1）静态类型转换:static_cast
语法：
    目标变量 = static_cast<目标类型>(源类型变量);
适用场景：
    主要用于将void*转化为其它类型的指针
    
2）动态类型转换:dynamic_cast//后面讲
语法：
    目标变量 = dynamic_cast<目标类型>(源类型变量);
    
3）去常类型转换:const_cast
语法：
    目标变量 = const_cast<目标类型>(源类型变量);
适用场景：
    主要用于去掉指针或引用const属性.

4）重解释类型转换:reinterpret_cast
语法：
    目标变量=reinterpret_cast<目标类型>(源类型变量);
适用场景：
    在指针和整型数进行显式转换.
    任意类型指针或引用之间显式转换.
    
    eg:已知物理内存地址0x12345678，向该地址存放一个整型数100？
    int* paddr = reinterpret_cast<int*>(0x12345678);
    *paddr = 100;
    */
//MARK: - 小结：
/**
1 慎用宏，可以使用const、enum、inline替换
  #define PAI 3.14
  --》const double PAI = 3.14;
  
  #define SLEEP 0
  #define RUN     1
  #define STOP  2
  --》enum STATE{SLEEP,RUN,STOP};
  
  #define Max(a,b) ((a)>(b)?(a):(b))
  --》inline int Max(int a,int b){
              return a > b ? a : b;
          }
          
2 变量随用随声明同时初始化
3 尽量使用new/delete替换malloc/free
4 少用void*,指针计算,联合体和强制转换
5 尽量使用string表示字符串，少用C风格的char* char[]
*/
