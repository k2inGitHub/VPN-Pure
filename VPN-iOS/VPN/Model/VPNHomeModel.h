//
//  VPNHomeModel.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/23.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNHomeModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, assign) int reqCurrency;

@property (nonatomic, assign) BOOL isVip;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *descriptionText;

- (NSString *)descriptionText;

- (instancetype)initWithDict:(NSDictionary *)dic;

- (BOOL)isUnlock;

- (void)setIsUnlock:(BOOL)unlock;

@end
