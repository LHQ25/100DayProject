//
//  ObjcController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/8/3.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "ObjcController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ObjcController ()

@end

@implementation ObjcController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.cyanColor;
    
    [self instances];
    [self Obtaining_Object];
    [self associative_object];
    [self libraries_object];
}

//MARK: -
//MARK: -
- (void)instances{
    
    Person *p = [[Person alloc] init];
    p.name = @"9527";
    
    //MARK: - 复制指定的对象  'object_copy' is unavailable: not available in automatic reference counting mode
    //id p2 = object_copy(p, 10);
    
    //MARK: - 释放给定对象占用的内存   也是不能直接使用的
    //object_dispose(p2);
    
    //MARK: - 更改类实例的实例变量的值 'object_setInstanceVariable' is unavailable: not available in automatic reference counting mode
    //const char *property_name = "name";
    //const char *property_value = "value_name";
    //Ivar ivar = object_setInstanceVariable(p, property_name, (void *)property_value);
    
    //MARK: - 获取类实例的实例变量的值  'object_getInstanceVariable' is unavailable: not available in automatic reference counting mode
    //const char *property_out_value = "value_name";
    //Ivar ivar2 = object_getInstanceVariable(p, property_name, (void *)property_out_value);
    
    //MARK: - 一个指针，该指针指向分配给实例给定对象的任何额外字节
    void *ivar_pointer = object_getIndexedIvars(p);
    printf("一个指针，该指针指向分配给实例给定对象的任何额外字节:%p",ivar_pointer);
    
    //MARK: - 设置对象中实例变量的值
    NSString *name = @"9988";
    object_setIvar(p, class_getInstanceVariable(Person.class, "name"), name);
    NSLog(@"\n%@",p.name);
    
    //MARK: - 读取对象中实例变量的值
    id name_value = object_getIvar(p, class_getInstanceVariable(Person.class, "name"));
    char *n = (char *)name_value;
    printf("\n读取对象中实例变量的值：%s", n);
    
    //MARK: - 类的名称
    const char *class_name = object_getClassName(p);
    printf("\n类的名称: %s\n",class_name);
    
    //MARK: - 设置类的父类
//    Class set_class = object_setClass(p, NSObject.class);
    
    
    //MARK: - 给定对象的类的结构体  暂时无法获取到对应的属性  可以点进去看  结构的具体实现
    Class class_struct = object_getClass(p);
//    printf("%s",class_name);
    
    //MARK: - 更改类实例的实例变量的值
    char *name_2 = "name_2";
    Ivar i_set = object_setInstanceVariable(p, "name", (void *)name_2);
    NSLog(@"i_set ---  %@",p.name);
    
    //MARK: - 获取实例变量的值
    void *outValue = NULL;
    Ivar i_get = object_getInstanceVariable(p, "name", outValue);
    printf("\ni_get   %s: %s", ivar_getName(i_get), outValue);
}

//MARK: -
//MARK: - Obtaining Class Definitions
- (void)Obtaining_Object{
    
    //MARK: - 获取注册的类定义列表 返回一个整数值，指示已注册类的总数
    Class *buffers = NULL;
    int c = objc_getClassList(buffers, 0);
    printf("已注册类的总数:%d , %lu",c, sizeof(*buffers)/sizeof(buffers[0]));
    
    //MARK: - 创建并返回指向所有已注册类定义的指针的列表
    unsigned int count = 0;
    Class *class_s = objc_copyClassList(&count);
    printf("\n返回指向所有已注册类定义的指针的列表的个数: %lu",sizeof(*class_s)/sizeof(class_s[0]));
    
    //MARK: - 定类的类定义（结构体）
    const char *class_name = "Person";
    Class lookUpClass = objc_lookUpClass(class_name);
    
    //MARK: - 指定类的类定义（结构体）
    id class_struct = objc_getClass(class_name);
    
    //MARK: - 指定类的类定义（结构体）
    Class required_class = objc_getRequiredClass(class_name);
    /**
    此函数与objc_getClass相同，但是如果找不到该类，则将终止该进程。
    ZeroLink使用此功能，如果没有ZeroLink，则找不到类将是编译时链接错误。
    */
    
    //MARK: - 指定类的元类定义
    id meta_class_struct = objc_getMetaClass(class_name);
}

//MARK: -
//MARK: - Associative References

const int assoc_key = 999;
- (void)associative_object{
    
    Person *p = [[Person alloc] init];
    
//    objc_setAssociatedObject(p, &assoc_key, @"associate_value", OBJC_ASSOCIATION_COPY_NONATOMIC);
    //MARK: - 使用给定的键和关联策略为给定的对象设置关联的值  _cmd也是唯一的指针(函数的指针)
    objc_setAssociatedObject(p, _cmd, @"associate_value", OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //MARK: - 获取的关联值
    id value = objc_getAssociatedObject(p, _cmd);
    NSLog(@"关联值：%@",value);
    
    //MARK: - 删除给定对象的所有关联  通常，应将objc_setAssociatedObject与nil值一起使用以清除关联。（一般不直接使用这个方法）
    objc_removeAssociatedObjects(p);
}

//MARK: -
//MARK: - Working with Libraries
- (void)libraries_object{
    
    //MARK: - 所有已加载的Objective-C框架和动态库的名称
    unsigned int outCount = 0;
    const char ** names = objc_copyImageNames(&outCount); //太多,就不打印了
    printf("\n所有已加载的Objective-C框架和动态库的名称个数：%d",outCount);
    
    //MARK: - 类所属的动态库的名称
    const char *class_Image_name = class_getImageName(Person.class);
    printf("\n类所属的动态库的名称：%s",class_Image_name);
    
    //MARK: - 指定库或框架中所有类的名称
    const char * image = "NSObject";
    unsigned int outCount2 = 0;
    const char ** class_names = objc_copyClassNamesForImage(image, &outCount2);
    printf("\n指定库或框架中所有类的名称个数：%d",outCount2);
}

@end
