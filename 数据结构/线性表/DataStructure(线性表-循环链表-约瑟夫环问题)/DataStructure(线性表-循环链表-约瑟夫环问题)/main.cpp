//
//  main.cpp
//  DataStructure(线性表-循环链表-约瑟夫环问题)
//
//  Created by 亿存 on 2020/8/17.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
using namespace std;
#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
#define INFEASOBLE -1
#define OVERFLOW -2
//Status 是函数的类型，其值是函数结果的状态码
typedef int Status;


/*
 无论是静态链表还是动态链表，有时在解决具体问题时，需要我们对其结构进行稍微地调整。比如，可以把链表的两头连接，使其成为了一个环状链表，通常称为循环链表
 和它名字的表意一样，只需要将表中最后一个结点的指针指向头结点，链表就能成环儿
 
 需要注意的是，虽然循环链表成环状，但本质上还是链表，因此在循环链表中，依然能够找到头指针和首元节点等。循环链表和普通链表相比，唯一的不同就是循环链表首尾相连，其他都完全一样
 */

/* 约瑟夫环 */
/* 经典的循环链表问题，题意是：
 已知 n 个人（分别用编号 1，2，3，…，n 表示）围坐在一张圆桌周围，
 从编号为 k 的人开始顺时针报数，数到 m 的那个人出列；
 他的下一个人又从 1 开始，还是顺时针开始报数，数到 m 的那个人又出列；
 依次重复下去，直到圆桌上剩余一个人
 */

//此时圆周周围有 5 个人，要求从编号为 3 的人开始顺时针数数，数到 2 的那个人出列


typedef struct Node{
    int data;
    Node *proir;
    Node *next;
    
    Node(Node& n): data(n.data), proir(n.proir), next(n.next){
        printf("拷贝\n");
    }
    
} Line;

void display(Line& l);

Line& init_node(int n){
    Line *first = (Line *)malloc(sizeof(Line));
    first->data = 1;
    first->proir = first;
    first->next = first;   //一开始都指向自身,也就是所谓的空(双向)循环链表
    
    Line *head = first;
    for (int i = 0; i < n - 1; i++) {
        Line *node = (Line *)malloc(sizeof(Line));
        
        node->data = i + 2;
        node->next = first;
        node->proir = head;
        
        head->next = node;
        first->proir = node;
        
        head = node;
    }
    return *first;
}

/// 实现
/// @param l 双向循环链表头结点
/// @param space 间隔
/// @param start 起始点
void action(Line &l, int space, int start){
    
    Line *head = &l;
    //找到起始的结点
    Node *start_node = head;
    int i = 1;
    while (i < start) {
        start_node = start_node->next;
        i++;
    }
    printf("起始点%d: %d\n",start, start_node->data);
    
    int array[19] = {};
    
    int j = 1;
    int k = 0;
    while (start_node->next != start_node) {
        j++;
        start_node = start_node->next;
        
        if (j == space) {
            
            printf("操作结点: %d,从链表中删除",start_node->data);
            printf("\n前驱--------  %d->%d\n",start_node->proir->data,start_node->next->data);
            printf("后继--------  %d<-%d\n",start_node->next->data,start_node->proir->data);
            
            start_node->proir->next = start_node->next;
            
            start_node->next->proir = start_node->proir;
            
            array[k] = start_node->data;
            k++;
            free(start_node);
            
            
            start_node = start_node->next;
            
            j = 1;
        }
        
        if (start_node->next == start_node) {
            printf("找到最后一个%d <- %d -> %d\n",start_node->proir->data, start_node->data, start_node->next->data);
            l = *start_node;
//            display(l);
        }
    }
    
    printf("------ 22 ------\n");
    for (int c = 0 ; c < sizeof(array)/sizeof(int); c++) {
        printf("%d\t",array[c]);
    }
    
    
    printf("\n");
    
    printf("最后胜出：%d\n",l.data);
    
}





int main(int argc, const char * argv[]) {

    Line& l = init_node(20);
    printf("起始\n");
    display(l);
    printf("开始操作\n");
    action(l, 3, 5);
    
    
//    Line& l2 = init_node(1);
//    display(l2);
    return 0;
}
void display(Line& l){
    
    Line *head = &l;
    
    if (head->next == head) {
        printf("就一个结点：%d\n",head->data);
    }else{
        do {
            printf("%d\t",head->data);
            head = head->next;
        } while (head != &l);
        printf("\n");
    }
}
