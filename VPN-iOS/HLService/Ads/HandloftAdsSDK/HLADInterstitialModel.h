//
//  HLADInterstitialModel.h
//  HLADs
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLADInterstitialModel : NSObject

@property (nonatomic, copy) NSString *interstitial_id;

@property (nonatomic, copy) NSString *list_id;

@property (nonatomic, copy) NSString *update_increase;

@property (nonatomic, copy) NSString *ctrl_recommend_pop_image;

@property (nonatomic, copy) NSString *ctrl_recommend_url;

@property (nonatomic, copy) NSString *event_id;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
