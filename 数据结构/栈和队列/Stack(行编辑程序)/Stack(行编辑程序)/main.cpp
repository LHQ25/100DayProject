//
//  main.cpp
//  Stack(行编辑程序)
//
//  Created by 亿存 on 2020/8/19.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
//#include <>
#define STACKMAXSIZE 10
#define INCRENTMENT 10
typedef char SELement;

typedef struct {
    SELement *data;
    SELement *top;
    int stackSize;
}Stack;

//接收用户从终端输入的程序或数据，并保存入用户的数据区。
//由于用户在终端进行输入时，不能保证不出错，若在编辑程序中“每接收一个字符即存入用户数据区”的做法显然不是罪恰当的。
//较好的做法是，设立一个输入缓冲区，用以接收用户输入的一行字符，然后逐行存入用户数据区，
//允许用户输入出差错，并在发现有误时可以及时更正
//例如: 当用户发现刚刚键入的一个字符是错的时，可以补进一个退格符“#”，以表示当前的祖父无效；如果发现当前键入的行内差错较多或者难以补救，则可以输入一个退行符“@”,以表示当前行中的字符均无效
//

void init_stack(Stack &s);
int push(Stack &s, SELement e);
int pop(Stack &s, SELement *e);
int stak_top(Stack &s, SELement *e);
int stack_clear(Stack &s);
int stack_destroy(Stack& s);
bool stack_empty(Stack &s);
void display(Stack &s);


int main(int argc, const char * argv[]) {
    
    Stack stack;
    init_stack(stack);
    
    SELement ch;
    //接受第一个字符
    std::cout << "接收第一个字符：";
    std::cin >> ch;
    while (ch != '&') {  //结束符
        while (ch != '&' && ch != '\n') {
            SELement v;
            switch (ch) {
                case '#':
                    pop(stack, &v); //仅当栈非空是退栈
                    printf("清楚一个字符：%c\n",v);
                    break;
                case '@':
                    stack_clear(stack); //重置栈
                    break;
                default:
                    push(stack, ch);//有效字符进栈
                    break;
            }
            //获取一个新字符
            std::cout << "录入字符：";
            std::cin >> ch;
        }
        //模拟将栈内的字符串保存起来
        //暂为实现  可以仅为打印栈中的数据
        display(stack);
        //清空栈
        stack_clear(stack);
        
        if (ch != '&') {
            //再次获取一个新字符，开始第二段录入
            std::cout << "录入字符：";
            std::cin >> ch;
        }
    }
    //栈不再使用  销毁
    stack_destroy(stack);
    
    return 0;
}

void init_stack(Stack &s){
    
    s.data = (SELement *)malloc(sizeof(SELement) * STACKMAXSIZE);
    if (s.data == NULL) exit(0);
    
    s.top = s.data;
    s.stackSize = STACKMAXSIZE;
    
}

int push(Stack &s, SELement e){
 
    if (s.top >= s.data + s.stackSize) {
        s.data = (SELement *)realloc(s.data, INCRENTMENT * sizeof(SELement));
        s.stackSize = s.stackSize + INCRENTMENT;
    }
    *s.top = e;
    s.top++;
    return 1;
}

int pop(Stack &s, SELement *e){
    
    if (s.top == s.data) return 0;
    
    *e = *(s.top - 1);
    s.top--;
    
    return 1;
}

int stak_top(Stack &s, SELement *e){
    
    
    *e = *(s.top - 1);
    
    return 1;
}
int stack_clear(Stack &s){
    
    s.data = (SELement *)malloc(sizeof(SELement) * STACKMAXSIZE);
    if (s.data == NULL) return 0;
    s.top = s.data;
    s.stackSize = STACKMAXSIZE;
    
    return 1;
}

bool stack_empty(Stack &s){
    return s.top != s.data;
}

int stack_destroy(Stack& s){
    
    free(s.data);
    s.top = NULL;
    s.data = NULL;
    s.stackSize = 0;
    return 1;
}

void display(Stack &s){
    
    if (s.data == NULL) {
        return;
    }
    
    for (int i = 0; i <= s.top - s.data; i++) {
        printf("%c",*(s.top-i));
    }
    printf("\n");
}
