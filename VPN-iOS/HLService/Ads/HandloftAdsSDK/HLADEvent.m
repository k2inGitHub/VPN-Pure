//
//  HLADEvent.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLADEvent.h"
#import "AFNetworking.h"
#import "HLADDeviceHelper.h"
#import "HLADConfig.h"
#import "NSString+HLAD.h"

@implementation HLADEvent

+ (void)eventLocalNotification:(UILocalNotification *)notification{
    if (!notification) {
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[HLADDeviceHelper deviceInfoDict]];
    [dict setObject:@"PUSH消息" forKey:@"position_code"];
    [dict setObject:@"PUSH消息" forKey:@"ad_format"];
    [dict setObject:@"0" forKey:@"ad_list_id"];
    [dict setObject:@"0" forKey:@"ad_id"];
    [dict setObject:@"0" forKey:@"ad_version"];
    [dict setObject:@"点击" forKey:@"action"];
    [dict setObject:notification.userInfo[@"msg_id"] forKey:@"msg_id"];
    
    [manager GET:AdEventUrl parameters:@{@"content":[NSString JSONStringFromObject:dict]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HLADLOG(@"HLADEvent success = %@", responseObject);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HLADLOG(@"HLADEvent error = %@", error);
    }];
    
    
}

@end
