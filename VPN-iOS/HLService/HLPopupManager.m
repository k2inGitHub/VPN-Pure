//
//  HLPopupManager.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/29.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLPopupManager.h"
#import "HLInterface.h"
#import "UIAlertView+Blocks.h"

@interface HLPopupManager ()



@end

@implementation HLPopupManager

+ (instancetype)sharedManager{
    static HLPopupManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[HLPopupManager alloc] init];
    });
    return _sharedManager;
}

- (void)showRate:(void(^)())onSure and:(void(^)())onCancel
{

    HLInterface *interface = [HLInterface sharedInstance];
    if (interface.comment_ctrl_switch == 1) {
        
        [UIAlertView showWithTitle:nil message:interface.comment_content cancelButtonTitle:interface.comment_btncancel otherButtonTitles:@[interface.comment_btnok] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:interface.comment_download_link]];
                if (onSure) {
                    onSure();
                }
            } else if (buttonIndex == 0) {
                if (onCancel) {
                    onCancel();
                }
            }
        }];
    }
}

- (void)showUpdate:(void(^)())onSure and:(void(^)())onCancel{

    HLInterface *interface = [HLInterface sharedInstance];
    
    if (interface.itunes_update_ctrl_switch == 1) {
        
        [UIAlertView showWithTitle:nil message:interface.itunes_update_content cancelButtonTitle:interface.itunes_update_btncancel otherButtonTitles:@[interface.itunes_update_btnok] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:interface.itunes_updated_url]];
                if (onSure) {
                    onSure();
                }
            } else if (buttonIndex == 0) {
                if (onCancel) {
                    onCancel();
                }
            }
        }];
    }
}


@end
