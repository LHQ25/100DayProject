//
//  CustomProtocol.h
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/31.
//  Copyright © 2020 亿存. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomProtocol <NSObject>

@property (nonatomic , copy) NSString *protocol_name;

@optional
- (void)protocl_method;

@end

NS_ASSUME_NONNULL_END
