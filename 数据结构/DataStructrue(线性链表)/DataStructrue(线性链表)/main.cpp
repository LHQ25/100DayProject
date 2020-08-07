//
//  main.cpp
//  DataStructrue(线性链表)
//
//  Created by 亿存 on 2020/8/7.
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
//MARK: - 线性链表
//线性表的链式存储结构的特点是用一组任意的存储单元存储线性表的数据元素(这组存储单元可以是连续的也可以是不连续的)
//为了表示每个数据元素a与其直接后继数据元素b之间的逻辑关系,对数据元素a来说，除了存储其本身的信息之外，还需要存储一个指示其直接后继的信息(及直接后继的存储位置)
//这两个部分组成数据元素a的存储映像 称为结点(Node)
//结点包括两个域：其中存储数据元素信息的域称为数据域,存储直接后继的存储的域称为指针域，
//指针域中存储的信息称为指针或者链，
//n个结点链结成一个链表 即为线性表的链式存储结构
//又由于此链表的每个结点中只包括一个指针域，又称为线性链表或单链表

//链表的存储必须从头指针开始，头指针指向链表中第一个结点的存储位置。由于最后一个元素没有直接后继，则线性链表的最后一个结点的指针为NULL


//- - - - - 线性表的单链表存储结构 - - - - -
typedef struct LNode {
    
    int data;
    struct LNode *next;
}LNode, *LinkList;
//在单链表中，取得第i个数据元素必须从头指针出发寻找，因此，单链表是表是非随机存取的存储结构


//建立线性表的链式存储结构的过程就是一个动态生成链表的过程,即从空表的初始状态起依次建立各个元素结点，并逐个插入链表
//从表尾到表头逆向建立单链表   时间复杂度O(n)
LNode& List_init(int data){
    
    //建立一个带头结点的单链表
    LinkList top_node = (LinkList)malloc(sizeof(LNode));
    if (!top_node) exit(ERROR);
    top_node->next = NULL;

    //生成一个新节点
    LinkList node = (LinkList)malloc(sizeof(LNode));
    if (!node) exit(ERROR);
    node->data = data;

    //形成链关系
    node->next = top_node->next;
    top_node->next = node;
    
    return *top_node;
    //逆位序创建，建立带表头结点的单链线性表
//    LinkList l = (LinkList)malloc(sizeof(LNode));
//    l->next = NULL; //先建立一个带头结点的单链表
//    for (int i = 0; i < 3; i++) {
//        LinkList p = (LinkList)malloc(sizeof(LNode)); //生成新结点
//        p->data = i + 3;   //输入元素值
//        p->next = l->next;  //插入到表头
//        l->next = p;
//    }
//
//    return *l;
}

/// 在最后插入数据
/// @param l 链表
/// @param e 元素
Status ListAppend_L(LNode &l, int e){
    
    LinkList node = (LinkList)malloc(sizeof(LNode));
    if (!node) exit(ERROR);
    node->data = e;
    
    LinkList last_node = l.next;
    while (last_node->next != NULL) {
        last_node = last_node->next;
    }
    node->next = last_node->next;
    last_node->next = node;
    
    return OK;
}

//在指定位置前插入数据   a -> b -> c -> d  ==>  a -> x -> b -> c -> d
//插入元素x，首先要生成一个数据域为x的结点，然后插入在单链表汇总
//根据插入操作的逻辑定义，还需要修改结点a中的指针域，使其指向结点x，而结点x的指针域应指向b
Status List_insert_L(LNode &l, int i, int e){
    
    LinkList p = &l;
    int j = 0;
    //找到指定位置的结点的前一个结点  方便插入当前的数据
    while (p && j < i - 1) {
        p = p->next;
        j++;
    }
    
    if (!p || j > i - 1) return ERROR;
    
    LinkList node = (LinkList)malloc(sizeof(LNode));
    if (!node) exit(ERROR);
    node->data = e;
    
    node->next = p->next;
    p->next = node;
    
    return OK;
}
///修改指定位置结点的数据
Status list_update_l(LNode& l, int i, int e){
    
    LinkList node = &l;
    int j = 0;
    while (node != NULL && j < i) {
        node = node->next;
        j++;
    }
    //判断要寻找的结点是否存在
    if (node == NULL || j > i) return ERROR;
    
    //修改数据
    node->data = e;
    
    return OK;
}
///获取指定结点的数据
Status list_get_elem_l(LNode&l ,int i, int* v){
    
    LinkList p = &l;
    int j = 0;
    //找到指定位置的结点
    while (p && j < i) {
        p = p->next;
        j++;
    }
    
    if (!p || j > i) return ERROR;
    *v = p->data;
    
    return OK;
}
//删除指定位置上的结点    a -> b -> c -> d   ==>   a -> c -> d
//在线性表中删除元素b时，为在单链表中实现元素啊a,b和c之间的逻辑关系的变化，仅需要修改结点a中的指针域即可
Status list_del_l(LNode& l, int i){
    LinkList p = &l;
    int j = 0;
    //找到指定位置的上一个结点
    while (p && j < i - 1) {
        p = p->next;
        j++;
    }
    if (!p || j > i - 1) return ERROR;
    
    LinkList delNode = p->next;
    
    p->next = delNode->next;
    
    free(delNode);
    
    return OK;
}

void print_node(LNode &node){
    
    LNode *next_node = node.next;
    printf("---- 输出当前链表中的数据 ----\n");
    while (next_node != NULL) {
        
        printf("%d\t",next_node->data);
        next_node = next_node->next;
    }
    printf("\n--------------------------\n");
}


//两个有序链表合并成一个有序链表
void mergeList(LNode& la, LNode& lb, LinkList lc){
    
    //已知单链线性表la和lb的元素按值非递减排列
    //归并la和lb得到新的单链线性表lc，lc的元素也按值非递减排列
    LinkList pa = la.next;
    LinkList pb = lb.next;
    
    LinkList top_node = (LinkList)malloc(sizeof(LNode));
    top_node->next = NULL;
    
    LinkList pc = top_node;
    
    
    while (pa && pb) {
//        printf("(%d   %d)\t",pa->data,pb->data);
        LinkList node = (LinkList)malloc(sizeof(LNode));
        if (pa->data <= pb->data) {
            node->data = pa->data;
            pa = pa->next;
        }else{
            node->data = pb->data;
            pb = pb->next;
        }
        pc->next = node;
        pc = node;
    }
    
    pc->next = pa ? pa : pb;
    
//    print_node(*top_node);
    *lc = *top_node;
    
}



int main(int argc, const char * argv[]) {
    
    //初始化
    LNode list_node = List_init(16);
    print_node(list_node);
    //在最后面插入
    ListAppend_L(list_node, 8);
    ListAppend_L(list_node, 18);
    ListAppend_L(list_node, 40);
    ListAppend_L(list_node, 10);
    print_node(list_node);
    //指定位置插入数据
    List_insert_L(list_node, 2, 88);
    print_node(list_node);
    //修改指定位置的数据
    list_update_l(list_node, 3, 66);
    print_node(list_node);
    //获取指定位置结点的数据
    int v = 0;
    list_get_elem_l(list_node, 4, &v);
    printf("查找指定位置的数据：%d\n",v);
    //删除指定位置上结点
    list_del_l(list_node, 2);
    print_node(list_node);
    
    
    LNode list_node2 = List_init(12);
    ListAppend_L(list_node2, 5);
    ListAppend_L(list_node2, 15);
    ListAppend_L(list_node2, 90);
    ListAppend_L(list_node2, 21);
    ListAppend_L(list_node2, 9);
    ListAppend_L(list_node2, 15);
    
    LNode l3 = List_init(11);
    mergeList(list_node, list_node2, &l3);
    print_node(l3);
    return 0;
}
