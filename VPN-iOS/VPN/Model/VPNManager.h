//
//  VPNManager.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/23.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


extern NSString * const VPNCurrencyDidChangeNotification;

extern NSString * const VPNVIPDidChangeNotification;

extern NSString * const VPNStatusDidChangeNotification;

#define VPN_Debug (0)

typedef NS_ENUM(NSInteger, VPNStatus) {
    VPNStatusInvalid,
    VPNStatusDisconnected,
    VPNStatusConnected,
};

@class VPNPageController;

@interface VPNManager : NSObject

@property (nonatomic, strong) NSMutableArray *homeDataArray;

@property (nonatomic, strong) NSArray *serverDataArray;

@property (nonatomic, strong) UIStoryboard *storyboard;

@property (nonatomic, assign) NSUInteger currency;

@property (nonatomic, strong) NSDictionary *currencyDic;

@property (nonatomic, strong) NSDictionary *alertDic;

@property (nonatomic, assign) VPNStatus status;

@property (nonatomic, weak) VPNPageController *pageContrller;

@property (nonatomic, copy) NSString *descriptionText;

@property (nonatomic, copy) NSString *loadDescriptionText;

- (void)setisVip:(BOOL)isVip;

- (BOOL)isVip;

- (void)setVPNEnable:(BOOL)enable;

- (BOOL)isVPNEnable;

- (void)addCurrency:(NSUInteger)add;

- (BOOL)costCurrency:(NSUInteger)cost;

+ (instancetype)sharedManager;

+ (void)showLaunchAd;

+ (void)showAd1;

+ (void)showAd2;


@end
