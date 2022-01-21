   //
//  main.cpp
//  数组
//
//  Created by 娄汉清 on 2022/1/5.
//

#include <iostream>

#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
#define INFEASIBLE -1
#define OVERFLOW 3
#define UNDERFLOW 4

typedef int Status; //Status是函数的类型,其值是函数结果状态代码，如OK等
typedef int Boolean; //Boolean是布尔类型,其值是TRUE或FALSE
typedef int ElemType;

#define MAX_ARRAY_DIM 8 //假设数组维数的最大值为8
typedef struct
{
    ElemType *base; //数组元素基址，由InitArray分配
    int dim; //数组维数
    int *bounds; //数组维界基址，由InitArray分配
    int *constants; // 数组映象函数常量基址，由InitArray分配
} Array;


Status initArray(Array *A, int dim, ...) {
    //若维数dim和各维长度合法，则构造相应的数组A，并返回OK
    int elemtotal=1,i; // elemtotal是元素总值
    va_list ap;
    if(dim<1||dim>MAX_ARRAY_DIM)
            return ERROR;
        (*A).dim=dim;
        (*A).bounds=(int *)malloc(dim*sizeof(int));
        if(!(*A).bounds)
            exit(OVERFLOW);
        va_start(ap,dim);
        for(i=0; i<dim; ++i)
        {
            (*A).bounds[i]=va_arg(ap,int);
            if((*A).bounds[i]<0)
                return UNDERFLOW;
            elemtotal*=(*A).bounds[i];
        }
        va_end(ap);
        (*A).base=(ElemType *)malloc(elemtotal*sizeof(ElemType));
        if(!(*A).base)
            exit(OVERFLOW);
        (*A).constants=(int *)malloc(dim*sizeof(int));
        if(!(*A).constants)
            exit(OVERFLOW);
        (*A).constants[dim-1]=1;
        for(i=dim-2; i>=0; --i)
            (*A).constants[i]=(*A).bounds[i+1]*(*A).constants[i+1];
        return OK;
    
    return OK;
}
int main(int argc, const char * argv[]) {
    
    
//    std::cout << ""
    
    return 0;
}
