//
//  HLADCommon.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_INLINE BOOL HLADIsDevicePortrait(){
    return [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height;
}

NS_INLINE BOOL HLADIsDevicePad() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

NS_INLINE CGFloat HLADScreenWidth() {
    return [UIScreen mainScreen].bounds.size.width;
}

NS_INLINE CGFloat HLADSmartBannerHeight(){
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 90 : 50;
}

NS_INLINE UIImage* HLADBundleImage(NSString *name){
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource:@ "HandloftAdsSDK" ofType :@"bundle"];
    NSString *filePath = [[bundlePath stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"png"];
    return [UIImage imageWithContentsOfFile:filePath];
}

@interface HLADCommon : NSObject

+ (void)requestApiSuccess:(void(^)(NSString *adBannerUrl, NSString *adInterstitialUrl, NSString *adFixedInterstitialUrl))success failure:(void(^)(NSError *error))failure;

+ (NSString *)adBannerUrl;

+ (NSString *)adInterstialUrl;

@end
