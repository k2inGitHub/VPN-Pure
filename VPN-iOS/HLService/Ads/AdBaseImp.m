//
//  AdBaseImp.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/26.
//  Copyright © 2016年 handloft. All rights reserved.
//


#import "AdBaseImp.h"
#import "AppDelegate.h"

@implementation AdBaseImp

- (instancetype)initWithAdManager:(HLAdManager *)adManager andInfo:(NSDictionary *)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _adManager = adManager;
    _infoDic = dic;
    
    return self;
}

- (UIView *)bannerView{
    return nil;
}

- (void)getAd
{

}

- (void)hideBanner
{
    
}

- (void)showBanner{
}

- (void)showInterstitial{
    
}

- (BOOL)isInterstitialLoaded{
    return NO;
}

- (UIViewController *)viewControllerForPresentAd {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return app.window.rootViewController;
}

@end
