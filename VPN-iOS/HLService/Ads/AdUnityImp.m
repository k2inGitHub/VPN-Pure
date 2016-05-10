//
//  AdUnityImp.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/26.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "AdUnityImp.h"
#include "UnityAds/UnityAds.h"

typedef NS_ENUM(NSUInteger, ShowResult){
    Failure,
    Success,
    Skipped,
};

@interface AdUnityImp () <UnityAdsDelegate>

@property (nonatomic, copy) NSString *appID;

@property (nonatomic, assign) BOOL isInitialized;

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, assign) BOOL appSelectorActive;
@property (nonatomic, assign) BOOL videoPlaying;

@end

@implementation AdUnityImp

- (void)getAd{
    _appID = self.infoDic[@"appID"];
    _isInitialized = NO;
    _isShowing = NO;
    _videoPlaying = NO;
    
    [[UnityAds sharedInstance] setDelegate:self];
    [[UnityAds sharedInstance] setDebugMode:NO];
    [[UnityAds sharedInstance] setTestMode:NO];
    [[UnityAds sharedInstance] startWithGameId:_appID andViewController:[self viewControllerForPresentAd]];
}

- (void)showInterstitial{
    
    if (!_isInitialized || _isShowing) {
        [self deliverCallback:Failure];
        return;
    }
    
    if ([self isInterstitialLoaded]) {
        [[UnityAds sharedInstance] show];
    }
}

- (BOOL)isInterstitialLoaded{
    return [[UnityAds sharedInstance] canShow];
}

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
    self.videoPlaying = false;
    if (skipped) {
        [self deliverCallback:Skipped];
    } else {
        [self deliverCallback:Success];
    }
}

- (void)unityAdsDidHide{
    self.videoPlaying = false;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    _isShowing = NO;
    [self deliverCallback:Skipped];
}

- (void)unityAdsFetchCompleted{
    _isInitialized = YES;
}

- (void)unityAdsFetchFailed{
    
}

- (void)unityAdsVideoStarted{
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialPresentNotification object:nil userInfo:@{HLAdTypeKey : HLAdUnity}];
}


- (void)deliverCallback:(ShowResult)result{
    if (result == Success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFinishNotification object:nil userInfo:@{HLAdTypeKey : HLAdUnity}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFailureNotification object:nil userInfo:@{HLAdTypeKey : HLAdUnity}];
    }
}

@end
