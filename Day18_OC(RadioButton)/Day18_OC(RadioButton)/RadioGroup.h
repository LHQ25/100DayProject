//
//  RadioGroup.h
//  Day18_OC(RadioButton)
//
//  Created by 亿存 on 2020/8/10.
//  Copyright © 2020 亿存. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@class YsyRadio;
typedef void(^radioSelect)(UIButton *radio);

@interface RadioGroup : UIView
/// 核心方法
/// @param view   父视图
/// @param select 点击选择的回掉block(block里需避免循环引用！请用weakSelf)
/// @param radio  可变参数，可往里添加多个radio对象，组成一组
+ (RadioGroup *)onView:(UIView *)view select:(radioSelect)select radios:(UIButton *)radio, ...;
/// 获取已选中的radio
- (UIButton *)getSelectedRadio;
@end
