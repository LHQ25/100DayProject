//
//  SELController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/8/3.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "SELController.h"
#import "Person.h"
#import <objc/runtime.h>
@interface SELController ()

@end

@implementation SELController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.cyanColor;
    
    unsigned int count = 0;
    Method *method = class_copyMethodList(Person.class, &count);
    Method m = class_getClassMethod(Person.class, @selector(eatLaunch:withPersonCount:));
    
    //MARK: - 在Objective-C运行时系统中注册方法名称
    const char * selector_name = "sayGoodsStudy_new";
    SEL s = sel_getUid(selector_name);
    printf("Selector名称：%s",sel_getName(s));
    
    //MARK: - 在Objective-C运行时系统中注册方法，将方法名称映射到选择器，然后返回selector值。
    const char * selector_register_name = "sayGoodsStudy_new_two";
    SEL s2 = sel_registerName(selector_register_name);
    printf("\nSelector名称：%s",sel_getName(s2));
    
    //MARK: - 两个selector是否相等
    BOOL result = sel_isEqual(s, s2);
    printf("\n两个selector是否相等：%d", result);
}

- (void)sayGoodsStudy{
    
}


@end
