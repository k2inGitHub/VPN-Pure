//
//  HLADBannerView.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLADAdSize.h"
#import "HLADRequest.h"

@class HLADBannerView;

@protocol HLADBannerViewDelegate <NSObject>

@optional

/// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
/// the banner view to the view hierarchy if it hasn't been added yet.
- (void)adViewDidReceiveAd:(HLADBannerView *)bannerView;

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(HLADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error;

#pragma mark Click-Time Lifecycle Notifications

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)adViewWillPresentScreen:(HLADBannerView *)bannerView;

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(HLADBannerView *)bannerView;

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(HLADBannerView *)bannerView;

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)adViewWillLeaveApplication:(HLADBannerView *)bannerView;

@end

@interface HLADBannerView : UIView

- (instancetype)initWithAdSize:(HLADAdSize)adSize;

@property (nonatomic, copy) NSString* adUnitID;

@property (nonatomic, weak) id<HLADBannerViewDelegate> delegate;

@property (nonatomic, weak) UIViewController* rootViewController;

- (void)loadRequest:(HLADRequest *)request;

@end
