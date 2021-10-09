//
//  RadioGroup.m
//  Day18_OC(RadioButton)
//
//  Created by 亿存 on 2020/8/10.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "RadioGroup.h"

@interface RadioGroup()
@property (nonatomic, copy ) radioSelect selected;
@property (nonatomic, strong) NSMutableArray<UIButton *> *group;
@end

@implementation RadioGroup
- (instancetype)init
{
    self = [super init];
    if (self) {
        _group = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
+ (RadioGroup *)onView:(UIView *)view select:(radioSelect)select radios:(UIButton *)radio, ...{
    RadioGroup *radioGroup = [[RadioGroup alloc] init];
    [view addSubview:radioGroup];
    radioGroup.selected = select;
    va_list params; //定义一个指向个数可变的参数列表指针;
    va_start(params,radio);//va_start 得到第一个可变参数地址,
    UIButton *arg;
    if (radio) {
        [radio  addTarget:radioGroup action:@selector(radioClick:) forControlEvents:UIControlEventTouchUpInside];
        [radioGroup.group addObject:radio];
        [view addSubview:radio];
        if (radio.selected) {
            select(radio);
        }
        //va_arg 指向下一个参数地址
        //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
        while( (arg = va_arg(params,UIButton *)) )
        {
            if ( arg )
            {
                [radioGroup.group addObject:arg];
                [view addSubview:arg];
                [arg addTarget:radioGroup action:@selector(radioClick:) forControlEvents:UIControlEventTouchUpInside];
                if (arg.selected) {
                    select(radio);
                }
            }
        }
        //置空
        va_end(params);
    }
    return radioGroup;
}
- (UIButton *)getSelectedRadio{
    for (UIButton *obj in _group) {
        if (obj.selected) {
            return obj;
        }
    }
    return nil;
}
- (void)radioClick:(UIButton *)radio{
    for (UIButton *obj in _group) {
        obj.selected = NO;
    }
    radio.selected =YES;
    if (_selected) {
        _selected(radio);
    }
}
@end
