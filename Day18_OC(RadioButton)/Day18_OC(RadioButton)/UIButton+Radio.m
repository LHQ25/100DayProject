//
//  UIButton+Radio.m
//  Day18_OC(RadioButton)
//
//  Created by 亿存 on 2020/8/10.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "UIButton+Radio.h"
#import <objc/runtime.h>
@implementation UIButton (Radio)

+ (UIButton *)creatRadioWithName:(NSString *)name val:(NSString *)val selected:(BOOL)selected{
    UIButton *radio = [UIButton buttonWithType:UIButtonTypeCustom];
    [radio setImage:[UIImage imageNamed:@"unSelectRadio"]  forState:UIControlStateNormal];
    [radio setImage:[UIImage imageNamed:@"selectRadio"] forState:UIControlStateSelected];
    [radio setTitle:[NSString stringWithFormat:@"  %@",name] forState:UIControlStateNormal];
    [radio setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    radio.val  = val;
    radio.selected = selected;
    radio.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return radio;
}

- (NSString *)name{
    return [self.currentTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setVal:(NSString *)val{
    objc_setAssociatedObject(self, _cmd, val, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)val{
    return objc_getAssociatedObject(self, @selector(setVal:));
}

@end
