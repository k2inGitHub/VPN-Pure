//
//  HLADBannerModel.m
//  HLADs
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLADBannerModel.h"
#import "HLADCommon.h"

@implementation HLADBannerModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.banner_id = dic[@"banner_id"];
    self.update_increase = dic[@"update_increase"];
    self.ctrl_recommend_banner_image = dic[HLADIsDevicePad() ? @"ctrl_recommend_banner_1456x180" : @"ctrl_recommend_banner_640x100"];
    self.ctrl_recommend_url = dic[@"ctrl_recommend_url"];
    self.list_id = dic[@"list_id"];
    self.event_id = dic[@"event_id"];
    
    return self;
}

@end
