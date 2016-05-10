//
//  HLADConfig.h
//  HLADs
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HLAD_DEBUG (1)

#if !defined(HLAD_DEBUG) || HLAD_DEBUG == 0
#define HLADLOG(...)       do {} while (0)
#elif HLAD_DEBUG == 1
#define HLADLOG(format, ...)      NSLog(format, ##__VA_ARGS__)
#endif

FOUNDATION_EXPORT NSString* const AdApiUrl;

FOUNDATION_EXPORT NSString* const AdBannerUrl;

FOUNDATION_EXPORT NSString* const AdInterstitialUrl;

FOUNDATION_EXPORT NSString* const AdEventUrl;

FOUNDATION_EXPORT const NSTimeInterval TimeOut8;

FOUNDATION_EXPORT const NSTimeInterval TimeOut15;

FOUNDATION_EXPORT const NSTimeInterval TimeOut60;

typedef NSString * HLADType;

static HLADType HLAD_Splash = @"开屏广告";
static HLADType HLAD_Button = @"按钮广告";
static HLADType HLAD_Interstitial = @"插页广告";
static HLADType HLAD_Banner = @"横幅广告";