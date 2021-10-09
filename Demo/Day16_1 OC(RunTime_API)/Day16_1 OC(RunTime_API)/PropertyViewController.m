//
//  PropertyViewController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/31.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "PropertyViewController.h"
#import "Person.h"
#import <objc/runtime.h>


@interface PropertyViewController ()

@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.purpleColor;
    
    /**
    R : readonly
    C : copy
    & : retain
    N : nonatomic
    G<name> : The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
    S<name> : The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
    D  : The property is dynamic (@dynamic).
    W  : The property is a weak reference (__weak).
    P   :  The property is eligible for garbage collection.
    t<encoding> : Specifies the type using old-style encoding.
    */
    NSDictionary *dic = @{@"R":@"readonly",
                          @"C":@"copy",
                          @"&":@"retain",
                          @"N":@"nonatomic",
                          @"G<name>":@"The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,)",
                          @"S<name>":@"The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,)",
                          @"D":@"The property is dynamic (@dynamic)",
                          @"W":@"The property is a weak reference (__weak)",
                          @"P":@"The property is eligible for garbage collection",
                          @"t<encoding>":@"Specifies the type using old-style encoding"};
    
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(Person.class, &count);
    
    for ( int i = 0; i<count; i++) {
        printf("\n-------------------%d--------------------",i);
        objc_property_t property = propertys[i];
        
        //属性名
        const char *p_name = property_getName(property);
        printf("\n属性名称：%s",p_name);
        
        //属性字符串
        const char *p_attribute = property_getAttributes(property);
        printf("\n属性：%s",p_attribute);
        
        //属性数组表示
        unsigned int outCount = 0;
        objc_property_attribute_t *p_attribute_array = property_copyAttributeList(property, &outCount);
        for (int i = 0; i<outCount; i++) {
            
            objc_property_attribute_t pp = p_attribute_array[i];
            
//            const char *k = "V";
//            strcmp(pp.name, k) == 0
            printf("\t\n属性数组表示（ %s: ",pp.name);
            NSString *key = [NSString stringWithCString:pp.name encoding:NSUTF8StringEncoding];
            if ([[dic allKeys] containsObject:key] == false) {
                printf("%s)",pp.value);
            }else{
                
                printf("%s)",[dic[key] cStringUsingEncoding:NSUTF8StringEncoding]);
            }
        }
        free(p_attribute_array);
        
        //property  某个属性的具体值
        const char attributeName[] = {'T'};
        char *value = property_copyAttributeValue(property, attributeName);
        printf("\n某一属性（%s）具体属性：%s",attributeName,value);
        free(value);
        
        printf("\n-------------------%d--------------------",i);
    }
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
