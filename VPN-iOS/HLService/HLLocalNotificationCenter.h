//
//  KTLocalNotificationCenter.h
//  HLADs
//
//  Created by 宋扬 on 16/3/22.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLLocalNotificationCenter : NSObject

+ (instancetype)sharedCenter;

//申请闹铃权限
- (void)registerUserNotification;

//
- (void)schedeuleAll;

- (void)cancelALL;

- (void)scheduleNotification:(NSDate *)fireDate message:(NSString *)messgae sound:(BOOL)sound alarmID:(NSString *)alarmID badges:(int)badges repeatInterval:(NSCalendarUnit)repeatInterval userInfo:(NSDictionary *)userInfo;

- (void)scheduleNotificationWithTargetTime:(NSString *)targetTime message:(NSString *)msg userInfo:(NSDictionary *)userInfo;

@end
