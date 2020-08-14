//
//  UIButton+Radio.h
//  Day18_OC(RadioButton)
//
//  Created by 亿存 on 2020/8/10.
//  Copyright © 2020 亿存. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Radio)

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *val;
+ (UIButton *)creatRadioWithName:(NSString *)name val:(NSString *)val selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
