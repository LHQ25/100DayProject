//
//  main.cpp
//  DataStructure(线性表-静态链表)
//
//  Created by 亿存 on 2020/8/11.
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


// 用数组代替指针，来描述单链表
// 首先让数组的元素都是由两个数组与组成，data和cur，也就是说，数组的每个下标都对应一个data和cur，数据域data用来存放数据，就是我们要处理的数据，游标cur相当于单链表中的next指针，存放该元素的后继在数组中的小白
//
//用数组描述的链表叫做静态链表(游标实现法)

/* 优点：
        在插入和删除操作时。只需要修改游标，不需要移动元素，从而改进了在顺序存储结构中的插入和删除操作需要移动大量元素的缺点
   缺点：
        1.没有解决连续存储分配带来的表长难以确定的问题
        2.失去了顺序存储结构随机存取的特性
 */


// 为了方便插入数据，需要把数组建立的大一些，方便插入是不至于溢出
/* 线性表的静态链表的存储结构 */
#define MAXSIZE  10   /* 假设链表的最大长度是1000 */
typedef struct {
    int data;
    int cur;  /* 游标(Cursor),为0时表示无指向 */
}Component, StaticLinkList[MAXSIZE];
//对数组的第一个和最后一个元素最为特殊元素处理，不存数据。通常把未被使用 的数据元素称为备用链表 现在范围在  1...998，
//数据的第一个元素，即下标为0的元素的cur就存放备用链表的的第一个结点的下标；
//而数组的最后一个元素cur则存放第一个有数值的元素的下标，相当于单链表中的头结点作用，当整个链表为空时，则0^2，

/* space[0].cur为头指针，"0"表示空指针*/
Status initList(StaticLinkList& space){
    
    for (int i = 0 ; i < MAXSIZE - 1; i++) {
        space[i].cur = i + 1;
        space[i].data = -9;
    }
    space[MAXSIZE - 1].cur = 0; /* 初始化时静态链表的为空，最后一个元素的cur为0*/
    return OK;
}

///下一个备用的结点
//如何用静态模拟动态链表结构的存储空间的分配，需要时申请，不需要是释放
//在动态链表中，结点的操作和释放分别借用malloc()和free()函数实现，在静态链表中操作的数组，不存在像动态链表的结点申请和释放的问题，需要自己实现这两个函数，才可以做插入和删除的操作
//为了辨明数组中的哪些分量未被使用，解决的办法是将所有未使用过的及已被删除的分量用游标链成一个备用的链表，每当进行插入时，便可以使用备用链表上取得第一个结点作为带插入的新结点
/* 若备用空间链表非空，则返回分配的结点下标，否则返回0 */
int malloc_SLL(StaticLinkList& space){
    
    int i = space[0].cur;  /* 当前数组第一个元素的cur存的值*/
    /* 就是返回的第一个备用空闲的下标*/
    if (space[0].cur)
        space[0].cur = space[i].cur; /* 由于要拿出一个分量来使用，所以就得把它的下一个分量来做备用*/
    return  i;
}
///插入操作
Status List_Insert(StaticLinkList& space, int i, int e){
    //判断插入的下标是否正确
    if (i < 1 || i >= MAXSIZE - 1) return ERROR;
   
    
    //1.判断是否还有空间插入， 获取即将下一个插入的游标,无法插入是返回0
    int insert_cur = malloc_SLL(space);
    
    //2. 即将插入元素的直接前驱
    int j = space[MAXSIZE - 1].cur + 1;
    while (j < i - 1) {
        j = space[j].cur;
    }
    //3. 插入数据的位置是否比现在实际链表长度还要长。插入的时候超出现有数据的范围
    if (space[j].data == -9) return ERROR;
    
    //4. 修改原先最后一个元素游标的指向(即将插入的新数据 -> 修改为直接前驱指向新插入的元素)，不修改就有两个游标指向同一个地方，形成死循环
    int last_change_cur = space[insert_cur].cur;  //即将插入元素的游标指向的位置
    //修改原先之前最后一个元素的游标的指向新添加元素的指向(防止打印和重新分配备用链表)
    int end_space = space[MAXSIZE - 1].cur + 1;
    while (space[end_space].cur != insert_cur) { //即将插入的数据位置不能是原先最后一个元素游标指向的位置，初始化的时候数组统一分配的每个游标指向后面一个元素
        end_space = space[end_space].cur;
    }
    space[end_space].cur = last_change_cur;  //修改原先最后一个元素游标的指向
    
    //5. 插入新元素。指定位置进行赋值
    space[insert_cur].data = e;
    //修改插入之后的游标指向
    space[insert_cur].cur = space[j].cur;
    space[j].cur = insert_cur;
    

    return OK;
}
///添加元素为最后一个
Status List_push(StaticLinkList& space, int e){
    int next_space = malloc_SLL(space);
    if (next_space == 0) return ERROR;
    //赋值操作
    space[next_space].data = e;
    return OK;
}
///修改指定位置数据
Status List_update(StaticLinkList& space, int i, int e){
    
    if (i < 1 || i >= MAXSIZE - 1) return ERROR;
    
    int start_i = space[MAXSIZE - 1].cur + 1;
    
    //是从第一个元素开始查，起始是1
    int j = 1;
    while (j < i) {
        start_i = space[start_i].cur;
        j++;
    }
    
    space[start_i].data = e;
    
    return OK;
}
///删除指定位置的元素
Status list_del(StaticLinkList& space, int i){
    if (i < 1 || i >= MAXSIZE - 1) return ERROR;
    
    //首结点
    int start_i = space[MAXSIZE - 1].cur + 1;
    //获取到要删除的元素的直接前驱的位置
    int j = 1;
    while (j < i - 1) {
        start_i = space[start_i].cur;
        j++;
    }
    //直接前驱指向删除元素的游标的指向
    int del_i = space[start_i].cur; //删除元素的位置
    space[start_i].cur = space[del_i].cur;
    
    //原先指向的备用链表被重新指向，(删除元素后变成备用链表的的第一个结点，然后指向这个)
    space[del_i].cur = space[0].cur;
    
    space[0].cur = del_i;  //指向(备用链表的的第一个结点) 前面有介绍第一个元素的作用
    space[del_i].data = -10;//感觉置不置-9都没事，
    return OK;
}

///获取指定位置的元素
Status List_query(StaticLinkList& space, int i, int& e){
    
    if (i < 1 || i >= MAXSIZE - 1) return ERROR;
    
    int start_i = space[MAXSIZE - 1].cur + 1;
    
    int j = 1;
    while (j < i) {
        start_i = space[start_i].cur;
        j++;
    }
    
    e = space[start_i].data;
    
    return OK;
}

void log(const StaticLinkList &spaces){
    
    int start_i = spaces[MAXSIZE - 1].cur + 1;
    while (spaces[start_i].data != -9) {
        printf("%d\t",spaces[start_i].data);
        start_i = spaces[start_i].cur;
    }
    printf("\n");
    int start_i2 = spaces[MAXSIZE - 1].cur + 1;
    while (spaces[start_i2].data != -9) {
        printf("%d\t",spaces[start_i2].cur);
        start_i2 = spaces[start_i2].cur;
    }
    printf("\n");
    
//    int start_i3 = spaces[MAXSIZE - 1].cur + 1;
//    while (spaces[start_i3].data != -9) {
//        printf("%d：%d\t",spaces[start_i3].cur,spaces[start_i3].data);
//        start_i3 = spaces[start_i3].cur;
//    }
//    printf("\n");
    for (int i = 1; i < MAXSIZE; i++) {
        Component component = spaces[i];
        if (component.data != 19) printf("(|%d::%d|)\t",component.cur,component.data);

    }
    printf("\n");
}

int main(int argc, const char * argv[]) {
    
    StaticLinkList spaces;
    initList(spaces);
    //log(spaces);
    
    //在最后面插入数据
    List_push(spaces, 11);
    List_push(spaces, 12);
    List_push(spaces, 13);
    List_push(spaces, 14);
    log(spaces);
    
    //指定位置插入数据
    printf("插入位置3,数据：15\n");
    List_Insert(spaces, 3, 15);
    log(spaces);
    //List_Insert(spaces, 8, 18);
    printf("插入位置4,数据：16\n");
    List_Insert(spaces, 4, 16);
    log(spaces);
    //List_Insert(spaces, 2, 17);
    //log(spaces);
    
    //删除
    list_del(spaces, 2);
    printf("删除位置2\n");
    log(spaces);
    
    //修改
    List_update(spaces, 3, 90);
    printf("修改位置3\n");
    log(spaces);
    
    //查找
    int res = 0;
    List_query(spaces, 3, res);
    printf("\n查找3位置的:%d\n",res);
    
    return 0;
}
