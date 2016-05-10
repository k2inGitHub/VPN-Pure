//
//  HLADInterstitial.h
//  HLADs
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLADRequest.h"
#import "HLADConfig.h"

@class HLADInterstitial;

@protocol HLADInterstitialDelegate <NSObject>
@optional

#pragma mark Ad Request Lifecycle Notifications

/// Called when an interstitial ad request succeeded. Show it at the next transition point in your
/// application such as when transitioning between view controllers.
- (void)interstitialDidReceiveAd:(HLADInterstitial *)ad;

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)interstitial:(HLADInterstitial *)ad didFailToReceiveAdWithError:(NSError *)error;

#pragma mark Display-Time Lifecycle Notifications

/// Called just before presenting an interstitial. After this method finishes the interstitial will
/// animate onto the screen. Use this opportunity to stop animations and save the state of your
/// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
/// Store from a link on the interstitial).
- (void)interstitialWillPresentScreen:(HLADInterstitial *)ad;

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(HLADInterstitial *)ad;

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(HLADInterstitial *)ad;

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(HLADInterstitial *)ad;


@end




@interface HLADInterstitial : NSObject

@property(nonatomic, readonly, copy) NSString *adUnitID;

@property(nonatomic, weak) id<HLADInterstitialDelegate> delegate;

@property(nonatomic, readonly, assign) BOOL isReady;

@property(nonatomic, readonly, assign) BOOL hasBeenUsed;

- (instancetype)initWithAdUnitID:(NSString *)adUnitID typeName:(HLADType)type;

- (void)loadRequest:(HLADRequest *)request;

- (void)presentFromRootViewController:(UIViewController *)rootViewController;

- (void)presentFromRootViewControllerAsSplash:(UIViewController *)rootViewController;

- (void)presentFromRootViewControllerAsButton:(UIViewController *)rootViewController positionTag:(NSString *)tag;

@end
