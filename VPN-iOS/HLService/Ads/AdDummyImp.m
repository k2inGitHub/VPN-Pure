//
//  AdDummyImp.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/31.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "AdDummyImp.h"
#import "HLDummyBanner.h"

@interface AdDummyImp ()

@property (nonatomic, strong) UIView *bannerView;

@end

@implementation AdDummyImp

- (instancetype)initWithAdManager:(HLAdManager *)adManager andInfo:(NSDictionary *)dic{
    
    
    return self;
}

- (void)getAd{
    
    _bannerView = [[HLDummyBanner alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIView *unityView = [self viewControllerForPresentAd].view;
    
    CGPoint center = CGPointMake(CGRectGetMidX(unityView.bounds),
                                 CGRectGetMaxY(unityView.bounds) - CGRectGetMidY(_bannerView.bounds));
    _bannerView.center = center;
    [[self viewControllerForPresentAd].view addSubview:_bannerView];
    [self hideBanner];
}

- (UIView *)bannerView{
    return _bannerView;
}

- (void)hideBanner
{
    if (_bannerView) {
        _bannerView.hidden = YES;
    }
}

- (void)showBanner{
    if (_bannerView) {
        _bannerView.hidden = NO;
    }
}

@end
