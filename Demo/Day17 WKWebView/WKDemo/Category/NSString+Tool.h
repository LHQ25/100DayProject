//
//  NSString+Tool.h
//  WKDemo
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (Tool)

///图片转base64字符串
- (NSString* (^)(void))hq_bundleImageFileToBase64String;

///JSON 转 字符串
- (NSString* (^)(void))hq_jsonDataToStirng;
@end

NS_ASSUME_NONNULL_END
