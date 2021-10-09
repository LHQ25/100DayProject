//
//  ProtocolViewController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/31.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "ProtocolViewController.h"
#import "Person.h"
#import <objc/runtime.h>

#import "CustomProtocol.h"

@interface ProtocolViewController ()

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.cyanColor;
    
    //MARK: - 指定的协议
    const char *protocol_name = "CustomProtocol";
    Protocol *p_protocol = objc_getProtocol(protocol_name);
    printf("协议名： %s",protocol_getName(p_protocol));
    
    //MARK: - 运行时已知的所有协议的数组
    unsigned int count = 0;
    Protocol **protocols = class_copyProtocolList(Person.class, &count);
    
    for (int i = 0 ; i < count ; i++) {
        Protocol *p = protocols[i];
        const char *protocol_name = protocol_getName(p);
        printf("\n协议名： %s",protocol_name);
    }
    free(protocols);
    
    
    
    //MARK: - 创建一个新的协议实例  必须注册新创建的协议
    const char *protocol_new = "CustomProtocol_New";
    Protocol *protocol_create = objc_allocateProtocol(protocol_new);
    /**
     当使用objc_allocateProtocol创建新协议时，
     可以通过调用此函数在Objective-C运行时中注册它。
     协议成功注册后，它是不可变的并且可以使用。
     
     */
    
    //MARK: - 向正在构建的协议中添加属性
    const char *property_name = "property_custom";
    objc_property_attribute_t opat = {"T","i"}; //int
    objc_property_attribute_t opat2 = {"N"}; //nonatomic
    objc_property_attribute_t opat3 = {"V","_property_custom"}; //_custom_age
    const objc_property_attribute_t attrs[] = {opat, opat2, opat3};
    unsigned int attributeCount = 3;
    BOOL isProperty_required = true;
    BOOL isProperty_instance = true; //True:则该属性的访问器方法是实例方法;设置为NO，则该属性将不会添加到协议中
    protocol_addProperty(protocol_create, property_name, attrs, attributeCount, isProperty_required, isProperty_instance);
    
    //MARK: - 协议添加方法
    SEL register_sel = sel_registerName("protocol_method");
    const char * types = "v:@";
    BOOL isRequriedMethod = false; //该方法是否是必须实现的方法。
    BOOL isInstanceMethod = true; //如果为true，则该方法为实例方法；否则为false,该方法为类方法。
    protocol_addMethodDescription(protocol_create, register_sel, types, isRequriedMethod, isInstanceMethod);
    
    //MARK: - 将注册的协议添加到正在构建的另一个协议中
    //要添加到（协议）的协议必须正在构建中-已分配但尚未在Objective-C运行时中注册。
    //要添加（添加）的协议必须已经注册。
    protocol_addProtocol(protocol_create, objc_getProtocol("CustomProtocol"));
    
    //MARK: - 在Objective-C运行时中注册新创建的协议   然后就可以使用了
    objc_registerProtocol(protocol_create);
    
    
    //MARK: - 协议是否相等
    BOOL result = protocol_isEqual(protocol_create, objc_getProtocol("CustomProtocol_Add"));
    printf("\n协议是否相等：%d",result);
    
    //MARK: - 获取协议中的指定类型的方法
    unsigned int outCount = 0;
    struct objc_method_description *protocol_methods = protocol_copyMethodDescriptionList(protocol_create, isRequriedMethod, isInstanceMethod, &outCount);
    for (int i = 0 ; i < outCount; i++) {
        struct objc_method_description omd = protocol_methods[i];
        SEL p_sel = omd.name;
        char *p_m_type = omd.types;
        printf("\n\t获取协议中的指定类型的方法,方法名：%s  类型：%s",sel_getName(p_sel), p_m_type);
    }
    
    //MARK: - 返回给定协议的指定方法的方法描述结构
    struct objc_method_description special_method_description = protocol_getMethodDescription(protocol_create, @selector(protocol_method), false, true);
    printf("\n获取协议中的指定类型的方法,方法名：%s  类型：%s",sel_getName(special_method_description.name), special_method_description.types);
    
    //MARK: - 协议中的属性
    objc_property_t *opt = protocol_copyPropertyList(protocol_create, &outCount);
    for (int i = 0 ; i < outCount; i++) {
        objc_property_t property = opt[i];
        printf("\n\t协议中的属性,属性名：%s  类型：%s",property_getName(property), property_getAttributes(property));
    }
    
    //MARK: - 获取协议中指定的属性
    const char *property_n = "property_custom";
    objc_property_t p = protocol_getProperty(protocol_create, property_n, isProperty_required, isProperty_instance);
    printf("\n获取协议中指定的属性,属性名：%s  类型：%s",property_getName(p), property_getAttributes(p));
    
    //MARK: - 协议继承的协议数组
    Protocol **ps = protocol_copyProtocolList(protocol_create, &outCount);
    for (int i = 0 ; i < outCount; i++) {
        Protocol *pro = ps[i];
        printf("\n\t协议继承的协议数组,协议名：%s",protocol_getName(pro));
    }
    
    //MARK: - 返回一个布尔值，该值指示一个协议是否符合另一个协议。
    result = protocol_conformsToProtocol(protocol_create, objc_getProtocol("CustomProtocol"));
    printf("\n一个协议是否符合另一个协议：%d",result);
    
    //MARK: - 在foreach迭代期间检测到突变时，由编译器插入
//    objc_enumerationMutation(id  _Nonnull obj)
    //MARK: - 设置当前的Mutation处理程序
//    objc_setEnumerationMutationHandler(<#void (* _Nullable handler)(id _Nonnull)#>)
    
    //MARK: - 创建一个指向在调用方法时调用指定块的函数的指针
//    imp_implementationWithBlock(<#id  _Nonnull block#>)
    //MARK: - 返回与使用imp_implementationWithBlock创建的IMP关联的块。
//    imp_getBlock(<#IMP  _Nonnull anImp#>)
    //MARK: - 将块与使用imp_implementationWithBlock创建的IMP解除关联，并释放创建的块的副本
//    imp_removeBlock(<#IMP  _Nonnull anImp#>)
    
    //MARK: - 加载弱指针引用的对象并返回它
//    objc_loadWeak(<#id  _Nullable * _Nonnull location#>)
    //MARK: - 将新值存储在__weak变量中
//    objc_storeWeak(<#id  _Nullable * _Nonnull location#>, <#id  _Nullable obj#>)
}

@end
