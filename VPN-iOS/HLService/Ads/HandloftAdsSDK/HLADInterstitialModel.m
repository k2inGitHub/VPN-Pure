//
//  HLADInterstitialModel.m
//  HLADs
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLADInterstitialModel.h"
#import "HLADCommon.h"

@implementation HLADInterstitialModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.interstitial_id = dic[@"pop_id"];
    self.update_increase = dic[@"update_increase"];
    
    NSString *key;
    if (HLADIsDevicePad()) {
        if (HLADIsDevicePortrait()) {
            key = @"ctrl_recommend_pop_768x1024";
        } else {
            key = @"ctrl_recommend_pop_1024x768";
        }
    } else {
        if (HLADIsDevicePortrait()) {
            key = @"ctrl_recommend_pop_640x1136";
        } else {
            key = @"ctrl_recommend_pop_1136x640";
        }
    }
    self.ctrl_recommend_pop_image = dic[key];
    self.ctrl_recommend_url = dic[@"ctrl_recommend_url"];
    self.list_id = dic[@"list_id"];
    self.event_id = dic[@"event_id"];
    
    return self;
}

@end
