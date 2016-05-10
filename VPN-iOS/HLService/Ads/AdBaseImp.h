//
//  AdInterface.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/26.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLAdManager.h"

@interface  AdBaseImp : NSObject

@property (nonatomic, weak) HLAdManager *adManager;

@property (nonatomic, strong) NSDictionary *infoDic;

- (instancetype)initWithAdManager:(HLAdManager *)adManager andInfo:(NSDictionary *)dic;

- (void)getAd;

- (void)showBanner;

- (void)hideBanner;

- (void)showInterstitial;

- (BOOL)isInterstitialLoaded;

- (UIViewController *)viewControllerForPresentAd;

- (UIView *)bannerView;

@end
