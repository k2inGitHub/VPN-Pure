//
//  HLAnalyst.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/28.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 使用最新版本的友盟 在线参数成为单独的模块
 在线参数更新时间10min
 */
@interface HLAnalyst : NSObject

+ (void)start;

+ (NSString *)stringValue:(NSString *)key;
+ (NSString *)stringValue:(NSString *)key defaultValue:(NSString *)value;
+ (int)intValue:(NSString *)key;
+ (int)intValue:(NSString *)key defaultValue:(int)value;;
+ (BOOL)boolValue:(NSString *)key;
+ (BOOL)boolValue:(NSString *)key defaultValue:(BOOL)value;
+ (float)floatValue:(NSString *)key;
+ (float)floatValue:(NSString *)key defaultValue:(float)value;

+ (void)event:(NSString *)event;


@end
