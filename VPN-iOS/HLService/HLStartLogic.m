//
//  HLStartLogic.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/4.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLStartLogic.h"
#import "HLService.h"
#import "UIAlertView+Blocks.h"
#import "NSUserDefaults+KTAdditon.h"

@implementation HLStartLogic

+ (void)start{
  
    
    if([[HLInterface sharedInstance] market_reviwed_status]==1){
        
        if([HLAnalyst boolValue:@"BeginVideoPush" defaultValue:NO]){
           
            [UIAlertView showWithTitle:nil message:@"下载广告app立马播放高清视频" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去下载"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [[HLAdManager sharedInstance] showUnsafeInterstitial];
                } else if (buttonIndex == 1) {
                    [[HLAdManager sharedInstance] showEncourageInterstitial];
                }
            }];
        }
        
        BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"MAJIA_First" defaultValue:YES];
        if (isFirst) {
            [[HLPopupManager sharedManager] showRate:^{
                
            } and:^{
                
            }];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MAJIA_First"];
        }
       
        [[HLPopupManager sharedManager] showUpdate:^{
            
        } and:^{
            
        }];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end
