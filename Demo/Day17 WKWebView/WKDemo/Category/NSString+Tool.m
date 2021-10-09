//
//  NSString+Tool.m
//  WKDemo
//
//  Created by 亿存 on 2020/8/4.
//  Copyright © 2020 YK. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

- (NSString* (^)(void))hq_bundleImageFileToBase64String{
    
    return ^(){
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:self ofType:nil];
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];//imagePath :沙盒图片路径
        NSString *base64_image_data = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        return [NSString stringWithFormat:@"data:image/jpg;base64,%@",base64_image_data];
    };
}

- (NSString* (^)(void))hq_jsonDataToStirng{
    
    return ^(){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    };
}

@end
