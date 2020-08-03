//
//  MethodViewController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/31.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "MethodViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface MethodViewController ()

@end
/**
 c                          ：  char
 i                           ： int
 s                           :  short
 l                            : long
 q                          :  long long
 C                          :  unsigned char
 I                           :  unsigned int
 S                          :  unsigned short
 L                          :  unsigned long
 Q                         :  unsigned long long
 f                          :   float
 d                         :  double
 B                         :  C++ bool or a C99 _Bool
 v                         : v oid
 *           : character string (char *)
 @                       : object (whether statically typed or typed id)
 #                        : class object (Class)
 :                         : method selector (SEL)
 [array type]      :  array
 {name=type...} : structure
 (name=type...) : union
 bnum                : bit field of num bits
 ^type                : pointer to type
 ?                       : unknown type (among other things, this code is used for function pointers)
*/
@implementation MethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.yellowColor;
    
    unsigned int count = 0;
    Method *methods = class_copyMethodList(Person.class, &count);
    for (int i = 0; i<count; i++) {
        Method m = methods[i];
        printf("-------------------%d--------------------",i);
        
        //MARK: - 方法的名称
        SEL m_sel = method_getName(m);
        NSLog(@"\n方法的名称：%@",NSStringFromSelector(m_sel));
        
        //MARK: - 方法体实现的地址指针
        IMP m_Imp = method_getImplementation(m);
        printf("方法体实现的地址指针：%p",m_Imp);
        
        //MARK: - 法参数的字符串和返回类型
        const char *m_type_encoding = method_getTypeEncoding(m);
        printf("\n方法参数的字符串和返回类型：%s",m_type_encoding);
        
        //MARK: - 方法的返回值类型
        char *method_return_type_str = method_copyReturnType(m);
        printf("\n方法的返回值类型：%s",method_return_type_str);
        
        //MARK: - 方法的单个参数类型的字符串
        unsigned int index = 2;  //索引：参数在第几位  （返回值 方法申明  参数）从第三位开始是参数
        char *m_argument_type = method_copyArgumentType(m, index);
        printf("\n方法的单个参数类型的字符串：%s",m_argument_type);
//        free(m_argument_type);
        
        //MARK: - 通过引用返回描述方法返回类型的字符串
        char dst[10] = {};
        size_t dst_len = 10;
        method_getReturnType(m, dst, dst_len);
        printf("\n通过引用返回描述方法返回类型的字符串：%s",dst);
        //实际调用：char *strncpy(char *dest, const char *src, size_t n) ,  赋值给 申明的dst，dst_len是复制时候的长度(最多复制 dst_len 个字符。当 src 的长度小于 dst_len 时，dest 的剩余部分将用空字节填充)
        
//        unsigned int m_parameters = count = method_getNumberOfArguments(m);
//        printf("\n方法中参数的数量：%d",m_parameters);
        
        //MARK: - 通过引用返回方法的单个参数类型的字符串
        unsigned int index_2 = 2;
        char dst_2[10] = {};
        size_t dst_len_2 = 10;
        method_getArgumentType(m, index_2, dst_2, dst_len_2);
        printf("\n通过引用返回方法的单个参数类型的字符串：%s",dst_2);
        
        
        //MARK: - 方法的描述(结构体)
        /**
         struct objc_method_description {
             SEL _Nullable name;               // The name of the method
             char * _Nullable types;           //The types of the method arguments
         };
         */
        struct objc_method_description *method_description = method_getDescription(m);
        NSLog(@"\nmethod_description-方法的名称：%@",NSStringFromSelector(method_description->name));
        printf("nmethod_description-方法的参数类型：%s",method_description->types);
        
        printf("\n-------------------%d--------------------\n",i);
    }
    
    //MARK: - 替换实现方法
    //设置方法实现的函数体   替换 MethodViewController 中的 实现方法 为Person类中的eat方法
//    Method m1 = class_getClassMethod(Person.class, @selector(eat));
    IMP previous_imp = method_setImplementation(class_getInstanceMethod(MethodViewController.class, @selector(eatFood)), class_getMethodImplementation(Person.class, @selector(eat)));
    printf("\n替换方法IMP之前的旧的IMP：%p\n",previous_imp);
    [self eatFood];
    
    
    //MARK: - 交换方法  1
    Method ori_method = class_getInstanceMethod(Person.class, @selector(sayHellow));
    Method swi_method = class_getInstanceMethod(MethodViewController.class, @selector(sayBye));
    method_exchangeImplementations(ori_method, swi_method);
    Person *p = [[Person alloc] init];
    [p sayHellow];
    
    //MARK: - 交换方法  2
    //类似于替换IMP   交换两个方法的IMP就可以了
    
    
//    method_invoke();
}
-(void)sayBye{
    
    NSLog(@"say bye bye");
}
-(void)eatFood{
    
    NSLog(@"替换eat实现方法");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
