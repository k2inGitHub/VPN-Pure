//
//  ADMobImp.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/26.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "AdMobImp.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADInterstitial.h>

@interface AdMobImp () <GADBannerViewDelegate, GADInterstitialDelegate>

@property (nonatomic, assign) BOOL isPad;

@property (nonatomic, copy) NSString *bannerID;

@property (nonatomic, copy) NSString *initerialID;

@property (nonatomic, strong) NSArray *testDevices;

@property (nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic, strong) GADInterstitial *gadinterstitial;

@end

@implementation AdMobImp

- (UIView *)bannerView{
    return _bannerView;
}

- (void)getAd{
    self.isPad = [[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound;
    
    _bannerID = self.infoDic[@"bannerID"];
    
    _initerialID = self.infoDic[@"initerialID"];
    
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
}

- (void)requestBanner {
    if (_bannerView == nil) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        _bannerView.adUnitID = [self bannerID];
        _bannerView.delegate = self;
        _bannerView.rootViewController =
        [self viewControllerForPresentAd];
    }
    
    [_bannerView loadRequest:[self createRequest]];
}

- (void)requesInterstitial{
    if (_gadinterstitial != nil) {
        _gadinterstitial.delegate = nil;
        _gadinterstitial = nil;
    }
    
    _gadinterstitial = [[GADInterstitial alloc] initWithAdUnitID:self.initerialID];
    _gadinterstitial.delegate = self;
//    _gadinterstitial.adUnitID = self.initerialID;
    
    [_gadinterstitial loadRequest:[self createRequest]];
}

- (GADRequest *)createRequest{
    GADRequest *request = [GADRequest request];
    request.testDevices = _testDevices;
    return request;
}

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

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView{
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    NSLog(@"adViewWillDismissScreen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    [self requestBanner];
    [self showBanner];
    NSLog(@"adViewDidDismissScreen");
}

- (void) adViewDidReceiveAd:(GADBannerView *)view {
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

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialPresentNotification object:nil userInfo:@{HLAdTypeKey : HLAdAdmob}];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFinishNotification object:nil userInfo:@{HLAdTypeKey : HLAdAdmob}];
    [self requesInterstitial];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFailureNotification object:nil userInfo:@{HLAdTypeKey : HLAdAdmob}];
}

@end
