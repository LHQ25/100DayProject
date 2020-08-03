//
//  Person.h
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/30.
//  Copyright © 2020 亿存. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject<CustomProtocol>
{
    NSString *_lasName;
    
    NSUInteger _num;
    
    NSDate *_birthday;
}

@property (nonatomic , copy) NSString *name;
@property (nonatomic , assign) NSUInteger age;

@property (nonatomic, copy) NSArray *studys;
@property (nonatomic, strong) NSMutableArray *loves;

@property (nonatomic , strong , class) NSString *area;

+ (void)personInfo;
+ (void)personBirthdayPlace:(NSString *)place;
+ (NSString *)personCharacter;

- (void)sayHellow;
- (void)eat;
- (void)eatLaunch:(NSString *)foot withPersonCount:(NSUInteger)count;
- (void)eatDanner:(int)sum withPersonCount:(NSUInteger)count withPersonName:(NSString *)name;
- (NSInteger)numberOfClassInSchool;
- (int)timeForMinut;

@end

NS_ASSUME_NONNULL_END
