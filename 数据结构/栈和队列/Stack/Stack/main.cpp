//
//  main.cpp
//  Stack
//
//  Created by 亿存 on 2020/8/18.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
//函数结果的状态码
#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
#define INFEASOBLE -1
#define OVERFLOW -2
//Status 是函数的类型，其值是函数结果的状态码
typedef int Status;

//栈和队列，严格意义上来讲，也属于线性表。因为它们也都用于存储逻辑关系为 一对一 的数据。

// 使用栈结构存储数据，讲究 先进后出(FIFO),即最先进栈的数据最后出栈。
// 使用队列存储数据，讲究 先进先出(FOFI)，即最先进队列的也最先出队列

//既然栈和队列都属于线性表，根据线性表分为顺序表和链表的特点，栈也分为顺序栈和链表；队列也分为顺序队列和链队列

//栈(Stack)是限定仅在表尾进行插入和删除操作的线性表
//把运行插入和删除的一段称为栈顶(Top)，另一端称为栈底(Bottom),不含任何元素的栈称为空栈，栈又称为后进先出(Last In First Out)的线性表，简称FIFO结构

//栈的插入操作叫做进栈也称压栈、入栈
//栈的删除操作，叫作出栈，也有的叫作弹栈。


/* 栈的顺序存储结构 */
#define MAXSIZE 10  //栈的初始化
#define STACKINCREMENT 5 //栈的增量
typedef int SElemType;  //假设这里的元素类型为 int
typedef struct {
    ///栈底指针，永远指向栈底的位置，若为NULL，则说明栈不存在
    SElemType *data;
    ///栈顶指针，初始化时指向栈底
    SElemType *top;
    ///栈当前可使用的最大容量
    int stackSize;
}SqStack;
//初始化一个空栈
Status InitStack(SqStack& l);
//栈的实际长度
long StackLength(SqStack &l);
///压栈
Status Push(SqStack& l, SElemType e);
//出栈
Status Pop(SqStack &l, int *e);
void display(SqStack &l);

int main(int argc, const char * argv[]) {
    
    SqStack stack;
    InitStack(stack);
    
    Push(stack, 14);
    Push(stack, 1);
    Push(stack, 34);
    Push(stack, 14);
    Push(stack, 1);
    Push(stack, 34);
    Push(stack, 14);
    Push(stack, 1);
    display(stack);
    
    int v = 0;
    Pop(stack, &v);
    display(stack);
    printf("%d\n",v);
    Pop(stack, &v);
    display(stack);
    printf("%d\n",v);
    Pop(stack, &v);
    display(stack);
    printf("%d\n",v);
    
    return 0;
}

Status InitStack(SqStack& l){
    //初始化一个空栈，
    l.data = (SElemType *)malloc(sizeof(SElemType) * MAXSIZE);
    if (l.data == NULL) return ERROR;;
    l.top = l.data; //指向栈底
    l.stackSize = MAXSIZE;  //最大存储大小
    return OK;
}

Status Push(SqStack& l, SElemType e){
    
    if (l.data == NULL) return ERROR;
    if (StackLength(l) == l.stackSize - 1) {
        l.data = (SElemType *)realloc(&l, sizeof(SElemType) * STACKINCREMENT);
        if (l.data == NULL) return ERROR;
        l.stackSize += STACKINCREMENT;
    }
    *l.top = e;
    l.top += 1;
    return OK;
}

Status Pop(SqStack &l, int *e){
    
    if (l.top == l.data) return ERROR;
    l.top--;
    *e = *l.top;
    return OK;
}

long StackLength(SqStack &l){
    
    
    long length = 0;
    if (l.data != NULL){
        length = l.top - l.data;
    }
    return length;
}

void display(SqStack &l){
    for (int i = 0; i < StackLength(l); i++) {
        
        printf("%d\t",l.data[i]);
    }
    
    printf("\n");
}

/*
 栈的抽象数据类型
 ADT 栈(Stack)
 
 Data
    同线性表。元素具有相同的类型，相邻元素具有前驱和后继的关系
 
 Operation
    InitStack(*S); 初始化操作
    DestoryStack(*S); 若栈存在则销毁它
    ClearStack(*s); 栈清空
    StackEmpty()S; 若栈为空则返回true，反正返回false
    GetTop(*S, *e); 若栈存在且非空，返回栈顶元素
    Push(*S,*e); 若栈存在，插入新元素e到栈中并称为栈顶元素
    Pop(*S,*e); 删除栈中栈顶的元素，并用e返回其值
    StackLength(S); 返回栈的元素个数
 */
