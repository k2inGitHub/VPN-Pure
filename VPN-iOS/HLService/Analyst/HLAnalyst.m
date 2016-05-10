//
//  HLAnalyst.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/28.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLAnalyst.h"
#import "MobClick.h"
#import "UMOnlineConfig.h"
#import "HLInterface.h"


@implementation HLAnalyst

+ (void)event:(NSString *)event{
    [MobClick event:event];
}

+ (void)start{
    [MobClick startWithAppkey:[HLInterface sharedInstance].umeng_code reportPolicy:REALTIME channelId:[HLInterface sharedInstance].umeng_Channel];
    [UMOnlineConfig updateOnlineConfigWithAppkey:[HLInterface sharedInstance].umeng_code];
    [UMOnlineConfig setLogEnabled:NO];
}

+ (NSString *)stringValue:(NSString *)key{
    return [self stringValue:key defaultValue:nil];
}
+ (NSString *)stringValue:(NSString *)key defaultValue:(NSString *)value{
    NSString *p = [UMOnlineConfig getConfigParams:key];
    if ([p length] > 0) {
        return p;
    }
    return value;
}

+ (int)intValue:(NSString *)key{
    return [self intValue:key defaultValue:0];
}

+ (int)intValue:(NSString *)key defaultValue:(int)value{
    NSString *p = [UMOnlineConfig getConfigParams:key];
    if ([p length] > 0) {
        return [p intValue];
    }
    return value;
}

+ (BOOL)boolValue:(NSString *)key{
    return [self boolValue:key defaultValue:NO];
}

+ (BOOL)boolValue:(NSString *)key defaultValue:(BOOL)value{
    NSString *p = [UMOnlineConfig getConfigParams:key];
    if ([p length] > 0) {
        return [p isEqualToString:@"1"];
    }
    return value;
}

+ (float)floatValue:(NSString *)key{
    return [self floatValue:key defaultValue:0];
}

+ (float)floatValue:(NSString *)key defaultValue:(float)value{
    NSString *p = [UMOnlineConfig getConfigParams:key];
    if ([p length] > 0) {
        return [p floatValue];
    }
    return value;
}

@end
