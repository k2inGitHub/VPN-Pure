//
//  VPNHomeModel.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/23.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNHomeModel.h"
#import "VPNManager.h"
#import "NSUserDefaults+KTAdditon.h"

@implementation VPNHomeModel

- (BOOL)isUnlock {
    NSString *key = [NSString stringWithFormat:@"VPN_home_unlock_%@", _name];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key defaultValue:NO];
}

- (void)setIsUnlock:(BOOL)unlock {
    NSString *key = [NSString stringWithFormat:@"VPN_home_unlock_%@", _name];
    [[NSUserDefaults standardUserDefaults] setBool:unlock forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = dic[@"name"];
    _title = dic[@"title"];
    _detail = dic[@"detail"];
    _reqCurrency = [dic[@"reqCurrency"] intValue];
    _isVip = [dic[@"isVip"] boolValue];
    _url = dic[@"url"];
    _descriptionText = dic[@"description"];
    
    return self;
}

- (NSString *)descriptionText{
    
    if (_url.length > 0) {
        
        return _descriptionText;
    }
    
    if (_isVip) {
        if ([[VPNManager sharedManager]isVip]) {
            return @"VIP专享";
        } else {
            return @"VIP专享";
        }
    }
    
    if ([self isUnlock]) {
        return [NSString stringWithFormat:@"已解锁"];
    }
    return [NSString stringWithFormat:@"%d金币解锁",_reqCurrency];
}

@end
