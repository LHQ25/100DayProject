//
//  UINavigationController+MYNavigationController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/30.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "UINavigationController+MYNavigationController.h"
#import <objc/runtime.h>
@implementation UINavigationController (MYNavigationController)


+ (void)load{
    
    Method swMethod = class_getInstanceMethod(UINavigationController.class, @selector(my_pushViewController:animated:));
    Method oriMethod = class_getInstanceMethod(UINavigationController.class, @selector(pushViewController:animated:));
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        method_exchangeImplementations(oriMethod, swMethod);
    });
}

- (void)my_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
 
    if (self.viewControllers.count == 0) {
        viewController.hidesBottomBarWhenPushed = true;
    }
    [self my_pushViewController:viewController animated:animated];
}

@end
