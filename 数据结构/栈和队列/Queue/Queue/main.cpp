//
//  main.cpp
//  Queue
//
//  Created by 亿存 on 2020/8/25.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

/* 队列的定义 */
//队列(queue)只允许在一段进行插入操作，而在另一端进行删除操作的线性表
//队列是一种先进先出(First In First Out)的线性表，简称FIFO。允许插入的一端称为队尾，允许删除的

/* 队列的抽象的数据类型
    ADT 队列(Queue)
    Data
        同线性表。元素具有相同的类型，相邻元素具有前驱和后继关系
    Operation
        InitQueue(*Q); 初始化操作，简历一个空队列
        DestroyQueue(*Q); 若队列Q存在，则销毁它
        ClearQueue(*Q); 队列Q清空
        QueueEmpty(*Q); 若队列为空，返回true，否则返回false
        GetHead(*Q,*e); 若队列Q存在且非空，用e返回Q的对队头元素
        EnQueue(*Q,*e); 若队列Q存在，插入新元素e到队列Q中并成为队尾元素
        DeQueue(*Q,*e); 删除队列Q中的对头元素，并用e返回其值
        QueueLength(Q); 返回队列Q的元素个数
 */
/*
    循环队列
 线性表有顺序存储结构和链式存储结构，栈是线性表，所以有这两种存储方式，同样，队列作为一种特殊的线性表，也同样同在这两种存储方式，
 
 循环队列的定义：解决假溢出的办法就是后面满了，就从头开始，也就是头尾相接的循环。把队列的这种头尾相接的顺序存储结构成为循环队列
 
 */


typedef struct Line{
    struct Line *rear;
    int *data;
    struct Line *top;
}Line;


int main(int argc, const char * argv[]) {
    
    return 0;
}
