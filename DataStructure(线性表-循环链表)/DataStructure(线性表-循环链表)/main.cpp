//
//  main.cpp
//  DataStructure(线性表-循环链表)
//
//  Created by 亿存 on 2020/8/13.
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


//简单的来讲就是  成功的男人就是3岁时不尿裤子，5岁能自己吃饭。。。。80岁能自己吃饭，90岁能不尿裤子

/* 对于单链表来说，由于每个结点只存储了向后的指针，到了尾标志就停止了向后链的操作，当中某一个结点就无法找到它的前驱，也就不能回到从前了。
 定义：
    将单链表中终端结点的指针由空指针改为指向头结点，就使整个单链表形成一个环，这种头尾相接的单链表称为单循环链表，简称循环链表(circular linked list)
 */

/* 为了是空链表与非空链表处理一致，通常设一个头结点，并不是说，循环链表一定要头结点。
    循环链表和单链表的只要差异在于循环的判断条件，原来是判断p->next是否为空，现在则是判断等不等于头结点，则循环结束
 
 单循环列表的后续操作和顺序表表的操作就一致了，可以查之前的代码(只需要注意插入的最后一个结点都要指向头结点)
 */

/*          双向链表         */
//双向链表(double linked list)是在单链表中的每个结点，再设置一个指向其前驱结点的指针，所以在双向链表中的结点都有两个指针域，一个指向后继，另一个直接指向前驱
/* 线性表的双向链表存储结构 */
typedef struct DulNode{
    int data;
    struct DulNode *prior; //直接前驱指针
    struct DulNode *next;  //直接后继指针
}DulNode, *duLinklist;
//单链表可以有循环链表，双向链表当然也可以是循环表
//双向链表是单链表扩展出来的结构，很多操作和单链表相同的，比如求长队listlength，查找元素getelem，获得元素的位置location等，这些操作都要只涉及到一个方向的指针即可，另一个指针并不能提供什么帮助
//相应的代价是：在插入和删除是，需要更改两个指针变量

/* 简单总结：
    双向链表对于单链表来说，要复杂一点，比较多了一个前驱指针。对于插入和删除时，需要小心一点，另外它由于每个结点都需要记录两分钟指针，所以在空间上十占用略多一些，不过由于它良好的对称性，使得对某个结点的前后操作带来了方便，可以有效提高算法的时间性能，就是常说的用空间换时间。
 */

///初始化双向链表
Status initDulLink(DulNode& d, int e);
///在最后面添加
Status dulLink_append(DulNode& d, int e);
///指定位置插入数据
Status dulLink_insert(DulNode& d, int i, int e);
///链表的长度
int dulink_length(DulNode &d);
///输出
void display(DulNode& d);
int main(int argc, const char * argv[]) {
    
    DulNode d;
    initDulLink(d, 1);
    display(d);
    //在最后插入数据
    dulLink_append(d, 3);
    dulLink_append(d, 4);
    display(d);
    
    //指定位置插入数据
    dulLink_insert(d, 1, 9);
    display(d);
//    dulLink_insert(d, 2, 10);
//    display(d);
    
    return 0;
}


Status initDulLink(DulNode& d, int e){
    
    //头结点 前驱和后继都为空
    DulNode *pd = (DulNode *)malloc(sizeof(DulNode));
    if (!pd) return ERROR;
    
    pd->data = e;
    pd->prior = NULL;
    pd->next = NULL;
    d = *pd;
    return OK;
}

Status dulLink_append(DulNode& d, int e){
    
    DulNode *node = (DulNode *)malloc(sizeof(DulNode));
    if (!node) return ERROR;
        
    node->data = e;
    node->next = NULL;
    
    //操作前驱和后继指针
    duLinklist priorNode = &d;
    while (priorNode->next != NULL) {
        priorNode = priorNode->next;
    }
    
    priorNode->next = node;
    node->prior = priorNode;
    
    return OK;
}

Status dulLink_insert(DulNode& d, int i, int e){
    
    int l = dulink_length(d);
    //插入位置是否合法
    if (i < 1 || i > l) return ERROR;
    //生成新结点
    duLinklist node = (duLinklist)malloc(sizeof(DulNode));
    if (!node) return ERROR;
    //结点进行赋值
    node->data = e;
    node->prior = NULL;
    node->next = NULL;
    
    if (i == 1) { //插入到表头
        node->next = &d;
        d.prior = node;
        display(*node);
        
        //重新赋值给头结点
        d = *node;
//        initDulLink(d, 900);
        
    }else{
        int j = 0;
        duLinklist prioi_node = &d;
        while (j < i - 2) {
            prioi_node = prioi_node->next;
            j++;
        }
        //当前结点的前驱为上一个结点，后继为上一个结点的后继
        node->next = prioi_node->next;
        node->prior = prioi_node;
        //直接前驱的后继修改为当前结点
        prioi_node->next = node;
    }
    return OK;
}
int dulink_length(DulNode &d){
    
    int lenght = 0;
    duLinklist dd = &d;
    while (dd->next) {
        dd = dd->next;
        lenght++;
    }
    return lenght;
}

void display(DulNode& d){
    
    duLinklist tempNode = &d;
    while (tempNode != NULL) {
        if (tempNode->next == NULL) {
            printf("%d\n",tempNode->data);
        }else{
            printf("%d <-> ",tempNode->data);
        }
        tempNode = tempNode->next;
    }
}
