//
//  Person.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/30.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
@implementation Person

+ (void)personInfo{
    NSLog(@"personInfo");
}
+ (void)personBirthdayPlace:(NSString *)place{
    NSLog(@"personBirthdayPlace: %@",place);
}
+ (NSString *)personCharacter{
    NSLog(@"personCharacter");
    return @"personCharacter";
}

- (void)sayHellow{
    NSLog(@"sayHellow");
}
- (void)eatLaunch:(NSString *)foot withPersonCount:(NSUInteger)count{
    NSLog(@"sayHellow");
}
- (NSInteger)numberOfClassInSchool{
    
    return 10;
}
- (int)timeForMinut{
    return  40;
}
- (void)eatDanner:(int)sum withPersonCount:(NSUInteger)count withPersonName:(NSString *)name{
    
    
}

- (void)eat{
    NSLog(@"吃东西");
}

//@dynamic area;

+(void)setArea:(NSString *)area{
    objc_setAssociatedObject(self, _cmd, area, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSString *)area{
    return objc_getAssociatedObject(self, @selector(setArea:));
}

@end
