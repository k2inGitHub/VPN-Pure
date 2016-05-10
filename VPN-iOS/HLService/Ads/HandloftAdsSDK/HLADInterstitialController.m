//
//  HLADInterstitialController.m
//  HLADs
//
//  Created by 宋扬 on 16/3/17.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLADInterstitialController.h"
#import "HLADCommon.h"

@interface HLADInterstitialController ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *closeAdButon;

@end

@implementation HLADInterstitialController

- (void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    float aspi = self.contentImage.size.width / self.contentImage.size.height;
    _button.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/aspi);
    _button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [_button setBackgroundImage:self.contentImage forState:UIControlStateNormal];
    [_button setBackgroundImage:self.contentImage forState:UIControlStateHighlighted];
    [_button setBackgroundImage:self.contentImage forState:UIControlStateSelected];

    [_button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    _closeAdButon = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeAdButon.frame = CGRectMake(15, 15, 40, 40);
    [_closeAdButon setBackgroundImage:HLADBundleImage(@"HLAD_close") forState:UIControlStateNormal];
    [_closeAdButon addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeAdButon];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)onCancel{
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialControllerWillDismiss)]) {
        [_delegate interstitialControllerWillDismiss];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(interstitialControllerDidDismiss)]) {
            [_delegate interstitialControllerDidDismiss];
        }
    }];
}

- (void)onClick{
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.ctrl_recommend_url]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(interstitialControllerWillLeaveApplication)]) {
            [_delegate interstitialControllerWillLeaveApplication];
        }
    }
}

@end
