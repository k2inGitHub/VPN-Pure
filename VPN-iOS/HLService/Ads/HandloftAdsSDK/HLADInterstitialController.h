//
//  HLADInterstitialController.h
//  HLADs
//
//  Created by 宋扬 on 16/3/17.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLADInterstitialModel.h"

@protocol HLADInterstitialControllerDelegate <NSObject>

@required
- (void)interstitialControllerWillDismiss;

- (void)interstitialControllerDidDismiss;

- (void)interstitialControllerWillLeaveApplication;

@end

@interface HLADInterstitialController : UIViewController

@property (nonatomic, strong) HLADInterstitialModel *model;

@property (nonatomic, strong) UIImage *contentImage;

@property (nonatomic, weak) id<HLADInterstitialControllerDelegate> delegate;

- (void)onCancel;

@end
