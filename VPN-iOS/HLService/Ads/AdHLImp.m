//
//  ADMobImp.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/26.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "AdHLImp.h"
#import "HandloftAdsSDK.h"
@interface AdHLImp ()<HLADBannerViewDelegate, HLADInterstitialDelegate>

@property (nonatomic, assign) BOOL isPad;

@property (nonatomic, copy) NSString *bannerID;

@property (nonatomic, copy) NSString *initerialID;

@property (nonatomic, copy) NSString *fixIniterialID;

@property (nonatomic, strong) NSArray *testDevices;

@property (nonatomic, strong) HLADBannerView *bannerView;

@property (nonatomic, strong) HLADInterstitial *gadinterstitial;

@property (nonatomic, strong) HLADInterstitial *fixinterstitial;

@property (nonatomic, strong) HLADInterstitial *btninterstitial;

@end

@implementation AdHLImp

- (UIView *)bannerView{
    return _bannerView;
}

- (void)getAd{
    self.isPad = [[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound;
    
    _bannerID = self.infoDic[@"bannerID"];
    _initerialID = self.infoDic[@"initerialID"];
    _fixIniterialID = self.infoDic[@"fixIniterialID"];
    _testDevices = @[
                     @"Simulator",
                     @"d36aaf8324841ed2b367c0d1b41cb666",
                     @"1be99ba152571a2a11f3cbdd3492eed8",
                     @"479df7b1bd4a4c3ccbe49c6124044a15",
                     @"bd158f8b26cc3b5c4bf4b7be2b61cc4c",
                     @"6babac2bcc4b5c0b1d2408479be54a8f",
                     @ "3e5be61410e3b1f8ec5aa11468958b59",
                     ];
    
    [self requestBanner];
    [self hideBanner];
    [self requesInterstitial];
    [self requestFixInterstitial];
    [self requestBtnInterstitial];
}

- (void)requestBanner {
    if (_bannerView == nil) {
        _bannerView = [[HLADBannerView alloc] initWithAdSize:kHLADAdSizeSmartBannerPortrait];
        _bannerView.adUnitID = [self bannerID];
        _bannerView.delegate = self;
        _bannerView.rootViewController =
        [self viewControllerForPresentAd];
    }
    [_bannerView loadRequest:[HLADRequest request]];
}

- (void)requesInterstitial{
    if (_gadinterstitial != nil) {
        _gadinterstitial.delegate = nil;
        _gadinterstitial = nil;
    }
    
    _gadinterstitial = [[HLADInterstitial alloc] initWithAdUnitID:self.initerialID typeName:HLAD_Interstitial];
    _gadinterstitial.delegate = self;
    [_gadinterstitial loadRequest:[HLADRequest request]];
}

- (void)requestFixInterstitial{
    if (_fixinterstitial != nil) {
        _fixinterstitial.delegate = nil;
        _fixinterstitial = nil;
    }
    
    _fixinterstitial = [[HLADInterstitial alloc] initWithAdUnitID:self.fixIniterialID typeName:HLAD_Splash];
    _fixinterstitial.delegate = self;
    [_fixinterstitial loadRequest:[HLADRequest request]];
}

- (void)requestBtnInterstitial{
    if (_btninterstitial != nil) {
        _btninterstitial.delegate = nil;
        _btninterstitial = nil;
    }
    
    _btninterstitial = [[HLADInterstitial alloc] initWithAdUnitID:self.fixIniterialID typeName:HLAD_Button];
    _btninterstitial.delegate = self;
    [_btninterstitial loadRequest:[HLADRequest request]];
}


//
//- (GADRequest *)createRequest{
//    GADRequest *request = [GADRequest request];
//    request.testDevices = _testDevices;
//    return request;
//}

- (void)showBanner {
    if (_bannerView) {
        _bannerView.hidden = NO;
    }
}

- (void)hideBanner
{
    if (_bannerView) {
        _bannerView.hidden = YES;
    }
}

- (BOOL)isInterstitialSplashLoaded{
    return _fixinterstitial.isReady;
}

- (BOOL)isInterstitialButtonLoaded{
    return _btninterstitial.isReady;
}

- (void)showInterstitialSplash{
    if (_fixinterstitial.isReady) {
        
        [_fixinterstitial presentFromRootViewControllerAsSplash:[self viewControllerForPresentAd]];
    } else {
        [self requestFixInterstitial];
    }
}

- (void)showInterstitialButton:(NSString *)positionTag{
    if (_btninterstitial.isReady) {
        [_btninterstitial presentFromRootViewControllerAsButton:[self viewControllerForPresentAd] positionTag:positionTag];
    } else {
        [self requestBtnInterstitial];
    }
}

- (void)showInterstitial{

    if ([self isInterstitialLoaded]) {
        [_gadinterstitial presentFromRootViewController:[self viewControllerForPresentAd]];
    } else {
        [self requesInterstitial];
    }
}

- (BOOL)isInterstitialLoaded{
    if (_gadinterstitial) {
        return _gadinterstitial.isReady;
    }
    return NO;
}

- (void)adViewDidDismissScreen:(HLADBannerView *)adView {
    [self requestBanner];
    [self showBanner];
}

- (void) adViewDidReceiveAd:(HLADBannerView *)view {
    UIView *unityView = [self viewControllerForPresentAd].view;
    
    CGPoint center = CGPointMake(CGRectGetMidX(unityView.bounds),
                         CGRectGetMaxY(unityView.bounds) - CGRectGetMidY(_bannerView.bounds));
    if (_bannerView) {
        [_bannerView removeFromSuperview];
        
    }
    self.bannerView = view;
    self.bannerView.center = center;
    [unityView addSubview:self.bannerView];
}

- (void)adView:(HLADBannerView *)view didFailToReceiveAdWithError:(NSError *)error
{
    
}

- (void)interstitialWillPresentScreen:(HLADInterstitial *)ad{
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialPresentNotification object:nil userInfo:@{HLAdTypeKey : HLAdHandloft}];
}

- (void)interstitialDidDismissScreen:(HLADInterstitial *)ad
{
    
    if (ad == _btninterstitial) {
        [self requestBtnInterstitial];
    } else if (ad == _gadinterstitial) {
        [self requesInterstitial];
    } else if (ad == _fixinterstitial){
        [self requestFixInterstitial];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFinishNotification object:nil userInfo:@{HLAdTypeKey : HLAdHandloft}];
}

- (void)interstitial:(HLADInterstitial *)ad didFailToReceiveAdWithError:(NSError *)error{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFailureNotification object:nil userInfo:@{HLAdTypeKey : HLAdHandloft}];
}

@end
