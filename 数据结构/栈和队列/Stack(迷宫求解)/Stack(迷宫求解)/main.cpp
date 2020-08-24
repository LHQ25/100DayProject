//
//  main.cpp
//  Stack(迷宫求解)
//
//  Created by 亿存 on 2020/8/19.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
/* 迷宫求解同事用“穷举求解”的方法，即从入口出发，顺着某一方向向前探索，若能走通，则继续往前走；否则沿原路返回。换一个方向在继续探索，知道可能的所有道路都探索到为止
 */
//为了保证在任何位置上都能沿原路返回，显然需要一个后进先出的结构老保存荣入口到当前位置的路径。
/*
        0  1  2  3  4  5  6  7  8  9
    0   *  *  *  *  *  *  *  *  *  *
    1   *  x     *           *     *
    2   *                    *     *
    3   *              *  *        *
    4   *     *  *  *              *
    5   *           *              *
    6   *     *           *        *
    7   *     *  *  *     *  *     *
    8   *  *                    o  *
    9   *  *  *  *  *  *  *  *  *  *
 */
//所求路径必须是简单路径，即在求得的路径上不能重复出现同一块通道

//#include <sys>

#define STACKMAXSIZE 130
#define INCRENTMENT 10


typedef struct Point {
    int x;
    int y;
    
    bool operator==(const Point& p){
        
        return this->x == p.x && this->y == p.y;
    }
}PosType;

typedef struct {
    int ord;  //通道块在路径上的 序号
    PosType seat; // 通道块在迷宫中的 坐标位置
    int di; //从此通道走向下一块通道的  方向
}SELemType;


typedef SELemType SELement;
typedef struct {
    SELement *data;
    SELement *top;
    int stackSize;
}Stack;



void init_stack(Stack &s);
int push(Stack &s, SELement e);
int pop(Stack &s, SELement *e);
int stak_top(Stack &s, SELement *e);
int stack_clear(Stack &s);
int stack_destroy(Stack& s);
bool stack_empty(Stack &s);
void display(Stack &s);


void printfPuzzle(int array[11][11]);
bool beign(PosType start, PosType end);

bool pass(PosType pos, int array[11][11], PosType endType);
void footPrint(PosType pos, int arr[11][11]);
PosType NextPos(PosType curpos, int fx);
void markPrint(PosType pos, int array[11][11]);
int main(int argc, const char * argv[]) {
    
    
    
    PosType s = {2,2};
    PosType e = {9,9};
    bool res = beign(s, e);
    res ? printf("成功\n") : printf("失败\n");
    return 0;
}

bool beign(PosType start, PosType end){
    int array[11][11] = {
        {4,1,2,3,4,5,6,7,8,9,1},
        {1,1,1,1,1,1,1,1,1,1,1},
        {2,1,0,0,1,0,0,0,1,0,1},
        {3,1,0,0,0,0,0,0,1,0,1},
        {4,1,0,0,0,0,1,1,0,0,1},
        {5,1,0,1,1,1,0,0,0,0,1},
        {6,1,0,0,0,1,0,0,0,0,1},
        {7,1,0,1,0,0,0,1,0,0,1},
        {8,1,0,1,1,1,0,1,1,0,1},
        {9,1,1,0,0,0,0,0,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1}
    };
    array[start.x][start.y] = 2;
    array[end.x][end.y] = 3;
    printfPuzzle(array);
    
    //若迷宫中存在从入口start到出口end的通道，则求得一条存放在栈中(从栈底到栈顶)，并返回true，否则返回false
    Stack stack;
    init_stack(stack);
    
    PosType curpos = start; //当前位置
    int curStep = 1;  //探索迷宫的第一步
        
    do {
        
        if (pass(curpos,array, end)) {
            printf("第%d步：{%d,%d}；通过\n",curStep,curpos.x,curpos.y);
            footPrint(curpos, array);  //留下足迹
            
            //入栈
            SELemType e = {curStep,curpos,1};
            push(stack, e);  //加入路径
            
            if (curpos == end) { //到底终点
                return true;
            }
            
            //下一步将要走的坐标 // 1 向右 2 向上 3 向左 4 向下
            curpos = NextPos(curpos, 1);
            //探索步骤加1
            curStep++;
        }else{ //不能通过
            printf("第%d步：{%d,%d}；不能通过\n",curStep,curpos.x,curpos.y);
            if (!stack_empty(stack)) {
                //移除栈顶元素
                SELement v;
                pop(stack, &v);
                //四个方向都已经探索完成 且 栈不为空，则返回上一步，并标记此位置不能通过
                while (v.di == 4 && !stack_empty(stack)) {
                    markPrint(v.seat, array);
                    pop(stack, &v);
                }
                if (v.di < 4) {
                    v.di++; //修改上个位置标记的探索方向(初始化的时候都为1)
                    push(stack, v); //从新入栈
                    //新探索方向的坐标
                    curpos = NextPos(v.seat, v.di);
                }
            }
        }
        
    } while (!stack_empty(stack));
//        } while (curStep < 39);
    
    return false;
}
//MARK: - 迷宫操作
///是否能通过
bool pass(PosType pos, int array[11][11], PosType endType){
    if (pos == endType) {
        return true;
    }
    return array[pos.x][pos.y] == 0 || array[pos.x][pos.y] == 2;
}

void footPrint(PosType pos, int arr[11][11]){
    
    arr[pos.x][pos.y] = 5;
    printfPuzzle(arr);
}

PosType NextPos(PosType curpos, int fx){
    
    if (fx == 1) {
        curpos.y++;
    }else if(fx == 2){
        curpos.x--;
    }else if(fx == 3){
        curpos.y--;
    }else{
        curpos.x++;
    }
    return curpos;
}

void markPrint(PosType pos, int array[11][11]){
    array[pos.x][pos.y] = 4;
    printfPuzzle(array);
}

//MARK: - 栈操作
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
    return s.top == s.data;
}

int stack_destroy(Stack& s){
    
    free(s.data);
    s.top = NULL;
    s.data = NULL;
    s.stackSize = 0;
    return 1;
}

void display(Stack &s){
    
//    if (s.data == NULL) {
//        return;
//    }
//
//    for (int i = 0; i <= s.top - s.data; i++) {
//        printf("%c",*(s.top-i));
//    }
    printf("\n");
}


void printfPuzzle(int array[11][11]){
    
//    system("clear");
    
    printf("\n");
    for (int x = 0; x < 11; x++) {
        for (int y = 0; y < 11; y++) {
            if (x == 0 && y == 0){
                std::cout << " ";
            }else if (x == 0 ){
                std::cout << "  " << array[x][y];
            }else if (y == 0){
                std::cout << array[x][y];
            }else if (array[x][y] == 1){ //墙
                std::cout << "  " << "*";
            }else if (array[x][y] == 2){ //起始点位置
                std::cout << "  " << "X";
            }else if (array[x][y] == 3){ //结束点位置
                std::cout << "  " << "O";
            }else if (array[x][y] == 4){ //此位置已经探测，但是不能通过
                std::cout << "  " << "@";
            }else if (array[x][y] == 5){ //走过的路径
                std::cout << "  " << "&";
            }else{
                std::cout<< "   ";
            }
        }
        std::cout << std::endl;
    }
}
