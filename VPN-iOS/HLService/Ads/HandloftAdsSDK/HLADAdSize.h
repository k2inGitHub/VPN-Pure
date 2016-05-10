//
//  HLADSize.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct HLADAdSize {
    CGSize size;
    NSUInteger flags;
} HLADAdSize;

extern HLADAdSize const kHLADAdSizeBanner;

extern HLADAdSize const kHLADAdSizeLeaderboard;

extern HLADAdSize const kHLADAdSizeSmartBannerPortrait;

extern HLADAdSize const kHLADAdSizeSmartBannerLandscape;