//
//  HLADCommon.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLADCommon.h"
#import "AFNetworking.h"
#import "HLADConfig.h"
#import "NSString+HLAD.h"
#import "HLADDeviceHelper.h"

static  NSString* _adBannerUrl = nil;

static  NSString* _adInterstitialUrl = nil;

static  NSString* _adFixedInterstitialUrl = nil;

@implementation HLADCommon

+ (void)requestApiSuccess:(void(^)(NSString *adBannerUrl, NSString *adInterstitialUrl, NSString *adFixedInterstitialUrl))success failure:(void(^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:AdApiUrl parameters:@{@"content":[NSString JSONStringFromObject:@{@"app_bundle_id":[HLADDeviceHelper bundleName],@"app_version":[HLADDeviceHelper bundleShortVersion]}]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _adFixedInterstitialUrl = responseObject[@"ctrl_fixed_pop_list_url"];
        _adBannerUrl = responseObject[@"ctrl_left_banner_list_url"];
        _adInterstitialUrl = responseObject[@"ctrl_left_pop_list_url"];
        if (success) {
            success(_adBannerUrl,_adInterstitialUrl,_adFixedInterstitialUrl);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSString *)adBannerUrl{
    return _adBannerUrl;
}

+ (NSString *)adInterstialUrl{
    return _adInterstitialUrl;
}

@end