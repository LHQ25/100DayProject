//
//  main.cpp
//  LinkStack
//
//  Created by 亿存 on 2020/8/25.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>

/* 栈的链式存储机构 简称 链栈*/

//栈只是栈顶来做插入和删除操作，栈顶放在表头还是表尾？
//由于单链表有头指针，而栈顶指针也是必须的，所以就二合一
//比较好的办法就是把栈顶放在单链表的头部  另外  已经有了栈顶在头部，单链表中比较常用的头结点就失去了意义
//通常对于链栈来说，是不需要头结点的

//对于链栈来说，基本不存在栈满的情况，除非内存已经没有可以用的空间
//对于空栈来说。链表原定义的头指针指向空，那么链栈的空就是top=NULL
typedef int SELemType;
typedef struct StackNode{
    
    SELemType data;
    struct StackNode *next;
}StackNode, *LinkStackPtr;

typedef struct LinkStack{
    LinkStackPtr top;
    int count;
}LinkStack;

//链栈的操作大部分都和单链表类似。只是在插入和删除上，特殊一些

/* 对比顺序栈与链栈，时间复杂度都是一样的，均为O(1)
    对于空间性能，顺序栈需要实现确定一个固定的长度，可能会存在内存空间的浪费，优势是存取时定位很方便
    链栈则要求每个元素都有指针域，同事增加了一些内存的开销，但是对于链栈的长度没有限制
 
    区别：如果栈的使用过程中元素的变化不可预料，有时候很小，有时候很大，最好用链栈，反之，如果它的变化在可控范围内，使用顺序栈会好一些
 */


///初始化头结点
LinkStack& initLinkStack(SELemType topData);
///插入操作
int stack_insert(LinkStack& stack, SELemType data);
///删除操作
int stack_pop(LinkStack& stack, SELemType *v);

void display(LinkStack& stack);
int main(int argc, const char * argv[]) {
    
    LinkStack stack = initLinkStack(10);
    display(stack);
    
    stack_insert(stack, 12);
    display(stack);
    
    stack_insert(stack, 16);
    display(stack);
    
    SELemType reslut;
    stack_pop(stack, &reslut);
    display(stack);
    printf("删除元素：%d\n",reslut);
    
    stack_pop(stack, &reslut);
    display(stack);
    printf("删除元素：%d\n",reslut);
    
    return 0;
}

LinkStack& initLinkStack(SELemType topData){
    
    LinkStack *link = (LinkStack *)malloc(sizeof(LinkStack));
    if (link == NULL) exit(0);
    
    LinkStackPtr ptr = (LinkStackPtr)malloc(sizeof(StackNode));
    if (ptr == NULL) exit(0);
    ptr->next = NULL;
    ptr->data = topData;
    
    link->top = ptr;
    link->count = 1;
    
    return *link;
}

int stack_insert(LinkStack& stack, SELemType data){
    
    LinkStackPtr node = (LinkStackPtr)malloc(sizeof(StackNode));
    if (node == NULL) return 0;
    node->data = data;
    
    node->next = stack.top; //当前的栈顶元素赋值给新结点的直接后继
    
    stack.top = node; //新结点赋值给栈顶元素
    stack.count += 1;

    return 1;
}

int stack_pop(LinkStack& stack, SELemType *v){
    
    if (stack.top == NULL) return 0;
    
    LinkStackPtr top = stack.top;
    *v = top->data;
    
    stack.top = top->next;
    stack.count -= 1;
    
    free(top); //释放结点
    
    return 1;
}

void display(LinkStack& stack){
    
    LinkStackPtr node = stack.top;
    while (node != NULL) {
        
        printf("\t%d",node->data);
        node = node->next;
    }
    printf("\n");
}
