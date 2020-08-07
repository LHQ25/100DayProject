//
//  main.cpp
//  DataStruct(线性表)
//
//  Created by 亿存 on 2020/8/6.
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

//线性表(linear_list): 最常用且是最简单的一组数据结构，一个线性表是n个数据元素的有限序列

//线性表的顺序表示是指用一组连续的存储单元一次存储线性表的数据元素(又叫顺序表)，
//线性表的第一个数据元素的存储位置通常称作线性表的起始位置或者基地址
//线性表的这种机内表示称作线性表的顺序存储结构或者顺序映像，称这种存储结构的线性表为顺序表
//特点是表中相邻的元素赋以相邻的存储位置,在计算机中也就是在相邻的下一块内存中
//所以只要确定了存储线性表的其实位置，线性表中的任一元素都可以随机存取，所以线性表的顺序存储结构是一种随机存取的存储结构。

//通常用数组来表示数据结构中的顺序存储结构，所以线性表的长度可变，且所需最大的存储空间随问题不同而不同
#define LIST_INIT_SIZE 100 //线性表存储空间的起始分配量
#define LISTINCREMENT 10 //线性表存储空间的分配增量
typedef struct {
    int *elem; //存储空间基址 （数组）
    int length; //当前长度
    int listsize; //当前分配的存储容量(以sizeof(ElementType)为单位)
}SqList;

//初始化线性表
SqList initList_Sq(){
    //构造一个空的线性表L
    SqList l;
    l.elem = (int *)malloc(LIST_INIT_SIZE * sizeof(int));
    if (!l.elem) exit(0); //初始化失败则退出程序
    
    l.length = 0;  //空表长度 0
    l.listsize = LIST_INIT_SIZE;  //初始存储容量
    return l;
};



//插入指定位置
Status listInsert_Sq(SqList &l, int i, int e){
    //在线性表中插入i位置
    //i 的合法值为 1 >=  i <= l.length + 1
    if (i < 1 || i > l.length + 1) return ERROR;  // i 的值不合法
    
    if (l.length >= l.listsize) {  //重新分配内存
        int *newBase = (int *)realloc(l.elem, (l.listsize + LISTINCREMENT) * sizeof(int));
        if (!newBase) exit(OVERFLOW);
        l.elem = newBase;
        l.listsize = l.listsize + LISTINCREMENT;
    }
    
    //原来的i(包括i)之后数据集体往后移动一位
    for (int j = l.length - 1; j >= i - 1; j--) {
        
        l.elem[j + 1] = l.elem[j];
    }
    //开始插入数据
    l.elem[i - 1] = e;
    l.length++;  //表长增 1
    return  OK;
}
//最后面新增一个数据
Status listAppend_Sq(SqList &l, int e){
    
    return listInsert_Sq(l, l.length + 1, e);
}

//删除指定位置的数据
Status listRemove_Sq(SqList &l, int idx){
    
    if (idx < 1 || idx > l.length) return ERROR;
    
    //把删除指定位置后面的数据前移一位就可以了
    for (int i = (idx - 1); i < (l.length - 1); i++) {
        l.elem[i] = l.elem[i + 1];
    }
    
    l.length--; //表长减 1
    return OK;
}

//查找元素的位置
Status list_findSq(SqList& l, int e, int& findIdx){
    
    if (l.length == 0) return ERROR;
    
    for (int i = 0; i < l.length - 1; i++) {
        if (l.elem[i] == e) {
            findIdx = i + 1;
            break;
        }
    }
    
    return OK;
}

///修改指定位置的数据
Status lisq_updateSq(SqList &l, int idx, int v){
    
    if (idx < 1 || idx > l.length) return ERROR;
    
    l.elem[idx - 1] = v;
    return OK;
}

Status list_update_v_Sq(SqList &l, int v, int nv){
    
    int count = 0;
    for (int i = 0; i < l.length; i++) {
        if (l.elem[i] == v) {
            l.elem[i] = nv;
            count++;
        }
    }
    return count > 0 ? OK : ERROR;
}

///顺序表合并   按非递减排列
SqList& list_merageSq(SqList &lv, SqList &rv){
    
    SqList *rc = new SqList;
    int* start_pointer = (int *)malloc(sizeof(int) * (lv.length + rv.length));
    if (!start_pointer) exit(OVERFLOW); //分配内存失败

    rc->elem = start_pointer;
    int *rc_elem = start_pointer;
    
    int *lp = lv.elem;
    int *rp = rv.elem;
    int *lp_last = &(lv.elem[lv.length - 1]);
    int *rp_last = &(rv.elem[rv.length - 1]);
    //printf("\n%d  %d  %d  %d\n",*lp,*lp_last,*rp,*rp_last);
    
    //归并
    while (lp <= lp_last && rp <= rp_last) {
        
        if (*lp <= *rp) {
            *(rc_elem++) = *(lp++);
        }else{
            *(rc_elem++) = *(rp++);
        }
    }
    //插入剩余lv的元素
    while (lp <= lp_last) {
        *(rc_elem++) = *(lp++);
    }
    //插入剩余rv的元素
    while (rp <= rp_last) {
        *(rc_elem++) = *(rp++);
    }
    rc->listsize = lv.length + rv.length;
    rc->length = lv.length + rv.length;
    return *rc;
}

void prine_Sq(const SqList &l){
    for (int i = 0; i < l.length; i++) {
        printf("%d\t",l.elem[i]);
    }
    printf("\n");
}

int main(int argc, const char * argv[]) {
    
    SqList l = initList_Sq();
    listAppend_Sq(l, 11);
    listAppend_Sq(l, 18);
    listAppend_Sq(l, 21);
    listAppend_Sq(l, 30);
    listAppend_Sq(l, 67);
    prine_Sq(l);
    
    //指定位置插入数据
    listInsert_Sq(l, 2, 90);
    prine_Sq(l);
    
    
    listRemove_Sq(l, 2);
    prine_Sq(l);
    
    int idx = 0;
    list_findSq(l, 30, idx);
    std::cout << "查找到的是第：" << idx << " 位" << std::endl;
    
    lisq_updateSq(l, 3, 90);
    prine_Sq(l);
    
    list_update_v_Sq(l, 30, 88);
    prine_Sq(l);
    
    
    printf("\n-----------------------------------------\n");
    
    SqList l2 = initList_Sq();
    listAppend_Sq(l2, 1);
    listAppend_Sq(l2, 181);
    listAppend_Sq(l2, 19);
    listAppend_Sq(l2, 33);
    listAppend_Sq(l2, 55);
    listAppend_Sq(l2, 77);
    
    SqList l3 = list_merageSq(l, l2);
    prine_Sq(l3);
    return 0;
}
