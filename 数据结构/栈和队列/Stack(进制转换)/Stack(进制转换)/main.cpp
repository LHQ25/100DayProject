//
//  main.cpp
//  Stack(进制转换)
//
//  Created by 亿存 on 2020/8/19.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

/* 十进制数 N 和其它 d 进制数的转换是计算机实现计算的基本问题*/
// 一个简单的算法基于下列原理： N = (N div d) * d + N mode d;(div: 整除运算，mod：求余运算)

//题目：对于输入一个任意一个非负十进制整数，打印输出与其等值的八进制数。由于计算过程是从低位到高位顺序才睡八进制数的各位，而打印输出，一般来说应从高位到低位进行，恰好和计算过程相反，若将计算过程中得到的八进制数的各位顺序入栈，则按出栈序列打印输出的即为与输入对应的把进制数


/*
 这是利用栈的后进先出的特性的最简单的例子。栈操作的序列是直线式的，即一味地入栈，然后一味的出栈，
 用数组实现不也很简单吗？仔细分析算法不难看出，栈的引入简化了程序设计的问题，划分了不同的关注层次，使思考的范围缩小了。而用数组不仅掩盖了问题的本质，还要分散精力去考虑数组下标增减等细节问题
 */
#define STACKMAXSIZE 10
#define INCRENTMENT 10
typedef struct {
    int *data;
    int *top;
    int stackSize;
}Stack;


void init_stack(Stack &s);
int push(Stack &s, int e);
int pop(Stack &s, int *e);
bool stack_empty(Stack &s);
void conversion();


int main(int argc, const char * argv[]) {
    
    conversion();
    return 0;
}

void conversion(){
    
    Stack stack;
    init_stack(stack);
    
    uint num;
    std::cout << "输入一个待转换的十进制数字：";
    std::cin >> num;
    
    while (num) {
        push(stack, num % 8);
        num /= 8;
    }
    
    printf("结果：");
    while (stack_empty(stack)) {
        int v = 0;
        pop(stack, &v);
        printf("%d",v);
    }
    printf("\n");
}

void init_stack(Stack &s){
    
    s.data = (int *)malloc(sizeof(int) * STACKMAXSIZE);
    if (s.data == NULL) exit(0);
    
    s.top = s.data;
    s.stackSize = STACKMAXSIZE;
    
}

int push(Stack &s, int e){
 
    if (s.top >= s.data + s.stackSize) {
        s.data = (int *)realloc(s.data, INCRENTMENT * sizeof(int));
        s.stackSize = s.stackSize + INCRENTMENT;
    }
    *s.top = e;
    s.top++;
    return 1;
}

int pop(Stack &s, int *e){
    
    if (s.top == s.data) return 0;
    
    *e = *(s.top - 1);
    s.top--;
    
    return 1;
}

bool stack_empty(Stack &s){
    return s.top != s.data;
}
