//
//  main.cpp
//  Stack(括号匹配的检验)
//
//  Created by 亿存 on 2020/8/19.
//  Copyright © 2020 亿存. All rights reserved.
//

#include <iostream>
#define STACKMAXSIZE 10
#define INCRENTMENT 10
typedef struct {
    int *data;
    int *top;
    int stackSize;
}Stack;

//假设表达式中允许包含两种括号，圆括号()和方括号[], 嵌套的顺序随意，即(()[])或[([][])]等为正确的格式，[(])或((]))等均不为正确格式。检验括号是否匹配的方法可用 “期待的急迫程度”这个概念来描述，
//例：[([][])]  12345678

//接收第一个括号后，就期待与其匹配的第八个括号的的出现，然而等来的却是第二个括号，此时括号[只能暂时靠边
//而迫切等待与第二个括号相匹配的第七个括号)的出现，类似的，因等来的事期三个括号[
//其期待匹配的程度较第二个括号更迫切，则第二个括号也只能靠边，让位于第三个括号，显然第二个括号的期待急迫性高于第一个括号；
//在接受第四个括号的之后，第三个括号期待得到满足，消解之后，第二个括号的期待匹配就成为当前最急迫的任务。。。。依次类推，可见
//这个处理过程与栈的特点相吻合，由此，在算法中设置一个栈，没读入一个括号。若是右括号则或者使至于栈顶的最急迫的期待得到消解，或者使不合法的情况；
//若是左括号，则作为一个新的更急迫的期待压入栈中，自然是原有的在占中的所有未消解的期待的急迫性都降一级。
//另外，在算法开始和结束时，栈都应该是空的。

void init_stack(Stack &s);
int push(Stack &s, int e);
int pop(Stack &s, int *e);
int stak_top(Stack &s, int *e);
bool stack_empty(Stack &s);

int test(int num , int t);
int main(int argc, const char * argv[]) {
    
    Stack stack;
    init_stack(stack);
    
    // 1：(, 2：), 3：[, 4: ], 5: {, 6: }
    std::cout << "输入第一个符号：";
    int n;
    std::cin >> n;
    //入栈
    push(stack, n);
    
    while (stack_empty(stack)) {
        std::cout << "输入一个符号：";
        int temp;
        std::cin >> temp;
        
        int top;
        stak_top(stack,&top);
        //检测是否匹配
        if (test(temp, top)) {
            int v;
            pop(stack, &v);
            std::cout << "出栈  " << v << std::endl;
        }else{
            std::cout << "入栈  " << temp << std::endl;
            push(stack, temp);
        }
    }
    
    printf("匹配完成\n");
    
    
    return 0;
}

int test(int num , int t){
    
    if (num == 1 && t == 2) {
        return 1;
    }
    if (num == 2 && t == 1) {
        return 1;
    }
    
    if (num == 3 && t == 4) {
        return 1;
    }
    if (num == 4 && t == 3) {
        return 1;
    }
    
    if (num == 5 && t == 6) {
        return 1;
    }
    if (num == 6 && t == 5) {
        return 1;
    }
    
    return 0;
}

void init_stack(Stack &s){
    
    s.data = (int *)malloc(sizeof(int) * STACKMAXSIZE);
    if (s.data == NULL) exit(0);
    
    s.top = s.data;
    s.stackSize = STACKMAXSIZE;
    
}

int push(Stack &s, int e){
 
    if (s.top >= s.data + s.stackSize) {
        s.data = (int *)realloc(s.data, INCRENTMENT * sizeof(int));
        s.stackSize = s.stackSize + INCRENTMENT;
    }
    *s.top = e;
    s.top++;
    return 1;
}

int pop(Stack &s, int *e){
    
    if (s.top == s.data) return 0;
    
    *e = *(s.top - 1);
    s.top--;
    
    return 1;
}

int stak_top(Stack &s, int *e){
    
    
    *e = *(s.top - 1);
    
    return 1;
}

bool stack_empty(Stack &s){
    return s.top != s.data;
}
