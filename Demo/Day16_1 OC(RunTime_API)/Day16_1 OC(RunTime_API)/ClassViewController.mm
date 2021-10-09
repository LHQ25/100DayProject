//
//  ClassViewController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/30.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "ClassViewController.h"
#import "Person.h"
#import <objc/runtime.h>

struct{
    NSString *name;
    NSInteger age;
}myStruct;


@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self class_class];
    [self ivar_class];
    [self class_property];
    [self method_class];
    [self class_protocol];
    [self other_class];
    [self add_class];
    [self class_instantating];
}
//MARK: -
//MARK: - Class
- (void)class_class{
    //MARK: - 获取类名
    const char *className = class_getName(Person.class);
    printf("类名:""%s",className);
    //MARK: - 获取父类
    Class superClass = class_getSuperclass(Person.class);
    printf("\n父类名:""%s",class_getName(superClass));
    //MARK: - 是否为元类
    BOOL result = class_isMetaClass(Person.class);
    NSLog(@"是否为元类: %d",result);
    //MARK: - 类的实例大小
    size_t size = class_getInstanceSize(Person.class);
    printf("\n类的实例大小:""%zu", size);
}

//MARK: -
//MARK: - Ivar
- (void)ivar_class{
    //MARK: - 实例变量
    const char *ivarName = "_lasName";
    Ivar ivar = class_getInstanceVariable(Person.class, ivarName);
    printf("\n实例变量: %s",ivar_getName(ivar));
    //MARK: - 类变量
    const char *classIvarName = "area";
    Ivar classIvar = class_getClassVariable(Person.class, classIvarName);
    printf("\n类变量变量: %s",ivar_getName(classIvar));
    
    //MARK: - 添加实例变量
    const char *addIvarName = "customIvar";
    BOOL addIvarResult = class_addIvar(Person.class, addIvarName, sizeof(NSString *), log(sizeof(NSString *)), @encode(NSString *));
    printf("\n添加实例变量: %d",addIvarResult);  //This function may only be called after objc_allocateClassPair and before objc_registerClassPair. Adding an instance variable to an existing class is not supported.
    
    //MARK: - 获取所有实例变量 (实例变量 + 属性)
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(Person.class, &count);
    // ivars是 指向一个数组首地址的指针, count:数组的长度,  遍历可以得到所有实例属性
    //    for (int i = 0 ; i< count; i++) {
    //        printf("\nivarName: %s",ivar_getName(ivars[i]));
    //    }
    
    //MARK: - 类的Ivar布局的描述。
    const uint8_t* layout = class_getIvarLayout(Person.class);
    printf("\nclass_getIvarLayout: %s",layout);
    //MARK: - 设置类的 Ivar 布局
    class_setIvarLayout(Person.class, layout);
    
    //MARK: - 类的weak Ivar 布局的描述
    const uint8_t* weakLayout = class_getWeakIvarLayout(Person.class);
    //MARK: - 设置类的weak Ivar 布局
    class_setWeakIvarLayout(Person.class, weakLayout);
}

//MARK: -
//MARK: - Property
- (void)class_property{
    
    //MARK: - 属性
    const char *name = "name";
    objc_property_t nameProperty = class_getProperty(Person.class, name);
    printf("/n属性名：%s",property_getName(nameProperty));
    
    //MARK: - 所有属性
    unsigned int count2 = 0;
    objc_property_t *propertys = class_copyPropertyList(Person.class, &count2);
    //propertys 指向一个数组首地址的指针, count:数组的长度,  遍历可以得到所有实例属性
    //    for (int i = 0 ; i< count2; i++) {
    //        printf("\nPropertyName: %s",property_getName(propertys[i]));
    //    }
    free(propertys);
    
    //MARK: - 添加属性
    const char *property_new = "custom_age";
    objc_property_attribute_t opat = {"T","i"}; //int
    objc_property_attribute_t opat2 = {"N"}; //nonatomic
    objc_property_attribute_t opat3 = {"V","_custom_age"}; //_custom_age
    objc_property_attribute_t attr[] = {opat,opat2,opat3};
    unsigned int attributeCount = 3; // attr数组 的 元素的个数
    BOOL addProperty_result = class_addProperty(Person.class, property_new, attr, attributeCount);
    printf("\n添加属性是否成功(property)：%d",addProperty_result);
    
    
    //MARK: - 替换属性
    const char *property_name = "name";
    objc_property_attribute_t replace_opat = {"T","NSString"}; //int
    objc_property_attribute_t replace_opat2 = {"N"}; //nonatomic
    objc_property_attribute_t replace_opat_copy = {"C"}; //nonatomic
    objc_property_attribute_t replace_opat3 = {"V","_custom_age"}; //_custom_age
    objc_property_attribute_t replace_attr[] = {replace_opat,replace_opat2,replace_opat3};
    unsigned int replace_attributeCount = 4; // attr数组 的 元素的个数
    class_replaceProperty(Person.class, property_name, replace_attr, replace_attributeCount);
}

//MARK: -
//MARK: - Method
-(void)method_class{
    //MARK: - 添加方法
    IMP imp = method_getImplementation(class_getClassMethod(ClassViewController.class, @selector(sayAddMethod)));
    BOOL addMethodResult = class_addMethod(Person.class, @selector(sayAddMethod), imp, "v@");
    printf("\n添加方法:%d",addMethodResult);
    
    //MARK: - 获取对象方法
    Method m = class_getInstanceMethod(Person.class, @selector(sayHellow));
    printf("\n获取对象方法:%s",method_getTypeEncoding(m));
    
    //MARK: - 方法列表
    unsigned int m_count = 0;
    Method *methods = class_copyMethodList(Person.class, &m_count);
    for (int i = 0 ; i< m_count; i++) {
        Method m = methods[i];
        NSLog(@"方法列表: %@",NSStringFromSelector(method_getName(m)));
        //        printf("\n方法列表: %s",NSStringFromSelector(method_getName(m)));
    }
    //MARK: - 方法替换
    IMP prev_imp = class_replaceMethod(Person.class, @selector(sayHellow), class_getMethodImplementation(ClassViewController.class, @selector(sayAddMethod)), "v:");
    printf("方法替换前的IMP地址：%p\n",prev_imp);
    Person *p = [[Person alloc] init];
    [p sayHellow];
    
    //MARK: - 方法的 函数指针
    IMP orig_imp = class_getMethodImplementation(ClassViewController.class, @selector(sayAddMethod));
    printf("\n方法具体实现的IMP地址：%p\n",orig_imp);
    
    //MARK: - 类的实例时将调用的函数指针
    IMP orig_imp2 = class_getMethodImplementation_stret(ClassViewController.class, @selector(sayAddMethod));
    printf("\n方法具体实现的IMP stet地址：%p\n",orig_imp2);
    
    //MARK: - 对象是否响应方法
    BOOL respondsToSelector = class_respondsToSelector(ClassViewController.class, @selector(sayAddMethod));
    printf("\n对象是否响应方法：%d",respondsToSelector);
}

//MARK: -
//MARK: - 协议
- (void)class_protocol{
    
    //MARK: - 添加协议
    Boolean add_protocol_result = class_addProtocol(Person.class, objc_getProtocol("CustomProtocol_Add"));
    printf("\n添加协议是否成功：%d",add_protocol_result);
    
    //MARK: - 类实现的协议
//    unsigned int outCount = 0;
//    Protocol **protocols = class_copyProtocolList(Person.class, &outCount);
//    for (int i = 0; i<outCount; i++) {
//        Protocol *p = protocols[i];
//        printf("\n类实现的协议：%s",protocol_getName(p));
//    }
    
    //MARK: - 指示类是否实现给定的协议
    BOOL conforms_protocol = class_conformsToProtocol(Person.class, objc_getProtocol("CustomProtocol_Add"));
    printf("\n添加协议是否成功：%d",conforms_protocol);

}

//MARK: -
//MARK: - Other
- (void)other_class{
    //MARK: - 类的版本号
    int class_version = class_getVersion(Person.class);
    printf("\n类的版本号：%d",class_version);
    
    //MARK: - 设置类的版本号
    //    class_setVersion(Person.class, 7);
}

//MARK: -
//MARK: - Add Class
- (void)add_class{
    
    //MARK: - 创建一个新的类和元类
    const char *class_name = "Student";
    size_t extraBytes = 0;  //额外字节数
    Class student_class = objc_allocateClassPair(NSObject.class, class_name, extraBytes);
    /**  然后就可以添加方法、属性、实例变量之类的操作
     Then set the class's attributes with functions like class_addMethod and class_addIvar.
     When you are done building the class,
     call objc_registerClassPair.   注册到内存中
     The new class is now ready for use.
     */
    
    //注册使用objc_allocateClassPair分配的类
    objc_registerClassPair(student_class);
    
    
    //由Foundation's 键值观察使用
//    const char *name = "";
//    size_t extraBytes2 = 0;  //额外字节数
//    objc_duplicateClass(student_class, name, extraBytes2);
    
    //销毁一个类及其关联的元类  如果存在cls类或任何子类的实例，请不要调用此函数。
    objc_disposeClassPair(student_class);
    
}

//MARK: -
//MARK: - Instantiating Classes
- (void)class_instantating{
    
    //MARK: - 初始化对象
    //第二个参数是分配额外的内存字节数  如果需要添加实例变量  可以额外分配
//    id p = class_createInstance(Person.class, 0);
    
    //在指定位置创建类的实例
//    size_t size = class_getInstanceSize(Person.class);
//    id p2 = objc_constructInstance(Person.class, &size);//'objc_constructInstance' is unavailable: not available in automatic reference counting mode
    
    //在不释放内存的情况下销毁类的实例，并删除其任何关联的引用
//    objc_destructInstance(p2);
}


- (void)sayAddMethod{
    NSLog(@"class_replaceMethod");
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
