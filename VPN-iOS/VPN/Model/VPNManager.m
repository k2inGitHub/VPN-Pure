//
//  VPNManager.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/23.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNManager.h"
#import "VPNHomeModel.h"
#import "NSUserDefaults+KTAdditon.h"
#import "KTUIFactory.h"
#import "HLService.h"
#import "KTMathUtil.h"
#import "UIAlertView+Blocks.h"
#import "VPNAlertView.h"
#import "VPNPageController.h"

NSString * const VPNCurrencyDidChangeNotification = @"VPN_CurrencyDidChange";

NSString * const VPNVIPDidChangeNotification = @"VPN_VipDidChange";

NSString * const VPNStatusDidChangeNotification = @"VPNStatusDidChangeNotification";


@interface VPNManager () <UIAlertViewDelegate>

@end

@implementation VPNManager

+ (void)showLaunchAd{
    if ([HLAnalyst boolValue:@"showLaunchAd" defaultValue:NO]) {
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
    }
}

+ (void)showAd1{
    if ([HLAnalyst floatValue:@"showAd1" defaultValue:0.5] > [KTMathUtil randomFloatRange:0 and:1]) {
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
    }
}

+ (void)showAd2{
    if ([HLAnalyst floatValue:@"showAd2" defaultValue:0.5] > [KTMathUtil randomFloatRange:0 and:1]) {
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
    }
}


- (void)setisVip:(BOOL)isVip{
    if (isVip != [self isVip]) {
        [[NSUserDefaults standardUserDefaults] setBool:isVip forKey:@"VPN_isVip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:VPNVIPDidChangeNotification object:nil];
        
        if (isVip) {
            [self setStatus:VPNStatusDisconnected];
        }
    }
}

- (BOOL)isVip
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"VPN_isVip" defaultValue:NO];
}

- (void)setVPNEnable:(BOOL)enable{

    if (enable != [self isVPNEnable]) {
        [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"VPN_VPNEnable"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (enable) {
            [self setStatus:VPNStatusDisconnected];
        }
    }
}

- (BOOL)isVPNEnable{

    return [[NSUserDefaults standardUserDefaults] boolForKey:@"VPN_VPNEnable" defaultValue:NO];
}


+ (instancetype)sharedManager
{
    static VPNManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[VPNManager alloc] init];
    });
    return _sharedManager;
}

- (void)setCurrency:(NSUInteger)currency
{
    if (_currency != currency) {
        _currency = currency;
        [[NSUserDefaults standardUserDefaults] setInteger:_currency forKey:@"VPN_Currency"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:VPNCurrencyDidChangeNotification object:nil];
    }
}

- (void)setStatus:(VPNStatus)status{
    if (_status != status) {
        
        _status = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:VPNStatusDidChangeNotification object:nil];
    }
}

- (BOOL)costCurrency:(NSUInteger)cost {
    
    if (cost > _currency) {
        
//        if (_currency < 50) {
//            [KTUIFactory showAlertViewWithTitle:nil message:@"您的金币不足，系统将赠送您100金币" delegate:self tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        } else
        {
            
            [UIAlertView showWithTitle:nil message:@"金币还差一点哦 快去看视频领金币吧" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
//                [self performSelector:@selector(setSelectIdx) withObject:nil afterDelay:0];
            }];
        }
        
        return NO;
    }
    self.currency -= cost;
    return YES;
}

- (void)setSelectIdx{
    [VPNAlertView hideAllAlertViews];
    _pageContrller.selectIndex = 2;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 0) {
        self.currency += 100;
    }
}

- (void)addCurrency:(NSUInteger)add {
    self.currency += add;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.storyboard = [UIStoryboard storyboardWithName:@"VPN" bundle:nil];
    
    NSString *rootString = [HLAnalyst stringValue:@"VPNConfigData"];
//    NSLog(@"rootString = %@", rootString);
    NSData *rootData = [rootString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSPropertyListFormat format;
    
    NSDictionary *root = rootData.length>0 ? [NSPropertyListSerialization propertyListWithData:rootData options:NSPropertyListImmutable format:&format error:&error] : nil;
    
//    NSLog(@"NSDictionary = %@", root);
    
    if (!root || [root count] == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"VPNConfigData"    ofType:@"plist"];
        root = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    NSDictionary* home = root[@"home"];
    NSArray* homeDataArray = home[@"dataArray"];
    
    _homeDataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in homeDataArray) {
        if (![dic[@"hidden"] boolValue]) {
            [_homeDataArray addObject:[[VPNHomeModel alloc] initWithDict:dic]];
        }
    }
    
    _serverDataArray = root[@"center"][@"serverDataArray"];
    
    self.descriptionText = root[@"alert"][@"descriptionText"];
    
    self.loadDescriptionText = root[@"alert"][@"loadDescriptionText"];
    
    _currency = [[NSUserDefaults standardUserDefaults] integerForKey:@"VPN_Currency" defaultValue:[root[@"baseCurrency"] intValue]];
    
#if VPN_Debug
    _currency = 10000;
#endif
    
    _currencyDic = root[@"currency"];
    
    _alertDic = root[@"alert"];
    
    if ([self isVPNEnable]) {
        _status = VPNStatusDisconnected;
    } else {
        _status = VPNStatusInvalid;
    }
    
    return self;
}

@end
