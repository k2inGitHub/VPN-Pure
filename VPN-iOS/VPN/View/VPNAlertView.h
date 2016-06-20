//
//  VPNAlertController.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/23.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNHomeModel.h"

typedef NS_ENUM(NSInteger, VPNAlertType) {
    VPNAlertVIP,
    VPNAlertUnlock,
    VPNAlertTip,
    VPNAlertVPN,
    VPNAlertInfo,
    VPNAlertCount,
};

@protocol VPNAlertContrllerDelegate <NSObject>

@optional
- (void)onUnlockFinish:(VPNHomeModel *)m;

- (void)onVipFinish;

@end

@interface VPNAlertView : UIView

@property (nonatomic, assign) VPNAlertType alertType;

@property (nonatomic, strong) VPNHomeModel *unlockModel;

@property (nonatomic, weak) id<VPNAlertContrllerDelegate> delegate;

+ (instancetype)showWithAlertType:(VPNAlertType)alertType;

+ (instancetype)showWithAlertType:(VPNAlertType)alertType andModel:(VPNHomeModel *)m ;

+ (void)hideAllAlertViews;

@end
