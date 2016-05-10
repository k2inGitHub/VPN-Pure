//
//  AdVungleImp.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/14.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "AdVungleImp.h"
#import <VungleSDK/VungleSDK.h>

@interface AdVungleImp ()<VungleSDKDelegate>

@property (nonatomic, copy) NSString *appID;

@property (nonatomic, strong) VungleSDK *sdk;

@end

@implementation AdVungleImp


- (void)getAd{
    _appID = self.infoDic[@"appID"];
//    _isInitialized = NO;
//    _isShowing = NO;
//    _videoPlaying = NO;
    _sdk = [VungleSDK sharedSDK];
    _sdk.delegate = self;

    [_sdk startWithAppId:_appID];
}

- (void)showInterstitial{
    
    // Dict to set custom ad options
    NSDictionary* options = @{VunglePlayAdOptionKeyIncentivized: @YES,
                              VunglePlayAdOptionKeyIncentivizedAlertBodyText : @"如果视频没有播放结束，你不会获得奖励！你确定提前关闭么？",
                              VunglePlayAdOptionKeyIncentivizedAlertCloseButtonText : @"关闭",
                              VunglePlayAdOptionKeyIncentivizedAlertContinueButtonText : @"继续观看",
                              VunglePlayAdOptionKeyIncentivizedAlertTitleText : @"注意!"};
    
    NSError *error;
    [_sdk playAd:[self viewControllerForPresentAd] withOptions:options error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }
}

- (BOOL)isInterstitialLoaded{
    return [_sdk isAdPlayable];
}

#pragma mark - VungleSDK Delegate

- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable {
//    if (isAdPlayable) {
//        NSLog(@"An ad is available for playback");
//        if (!_showAdButton.enabled || !_showAdWithOptionsButton.enabled) {
//            [self enableAdButtons:YES];
//        }
//    } else {
//        NSLog(@"No ads currently available for playback");
//        [self enableAdButtons:NO];
//    }
}

- (void)vungleSDKwillShowAd {
    NSLog(@"An ad is about to be played!");
    //Use this delegate method to pause animations, sound, etc.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialPresentNotification object:nil userInfo:@{HLAdTypeKey : HLAdVungle}];
}

- (void) vungleSDKwillCloseAdWithViewInfo:(NSDictionary *)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet {
    
    if ([viewInfo[@"completedView"] boolValue]) {
       [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFinishNotification object:nil userInfo:@{HLAdTypeKey : HLAdVungle}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFailureNotification object:nil userInfo:@{HLAdTypeKey : HLAdVungle}];
    }
    
    if (willPresentProductSheet) {
        //In this case we don't want to resume animations and sound, the user hasn't returned to the app yet
        NSLog(@"The ad presented was tapped and the user is now being shown the App Product Sheet");
        NSLog(@"ViewInfo Dictionary:");
        for(NSString * key in [viewInfo allKeys]) {
            NSLog(@"%@ : %@", key, [[viewInfo objectForKey:key] description]);
        }
    } else {
        //In this case the user has declined to download the advertised application and is now returning fully to the main app
        //Animations / Sound / Gameplay can be resumed now
        NSLog(@"The ad presented was not tapped - the user has returned to the app");
        NSLog(@"ViewInfo Dictionary:");
        for(NSString * key in [viewInfo allKeys]) {
            NSLog(@"%@ : %@", key, [[viewInfo objectForKey:key] description]);
        }
        
    }
}


- (void)vungleSDKwillCloseProductSheet:(id)productSheet {
    NSLog(@"The user has downloaded an advertised application and is now returning to the main app");
    //This method can be used to resume animations, sound, etc. if a user was presented a product sheet earlier
}

@end
