//
//  IvarViewController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/31.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "IvarViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface IvarViewController ()

@end

@implementation IvarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = UIColor.cyanColor;
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(Person.class, &count);
    
    for (int i = 0 ; i < count ; i++) {
        Ivar ivar = ivars[i];
        printf("-------------------%d--------------------",i);
        printf("\n实例变量名：%s",ivar_getName(ivar));
        printf("\n实例变量类型：%s",ivar_getTypeEncoding(ivar));
        printf("\n实例变量的偏移量：%td",ivar_getOffset(ivar));
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
