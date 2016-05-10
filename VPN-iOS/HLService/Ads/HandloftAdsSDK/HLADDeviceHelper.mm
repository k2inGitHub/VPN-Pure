//
//  HLADDeviceHelper.m
//  HLADs
//
//  Created by 宋扬 on 16/3/21.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLADDeviceHelper.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "NSString+HLAD.h"
#import "HLADReachability.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


@implementation HLADDeviceHelper


+ (NSString *)uniqueIdentifier{
    static NSString *_uniqueIdentifier = nil;
    if (_uniqueIdentifier == nil) {
        _uniqueIdentifier = [[NSString stringWithFormat:@"%@,%@,%@",[HLADDeviceHelper idfa], [HLADDeviceHelper macAddress], @"C4veqM0bQpXWmADE"] MD5Hash];
    }
    return _uniqueIdentifier;
}

+ (NSString *)macAddress
{
    static NSString *_macAddress = nil;
    if (_macAddress == nil) {
        int                    mib[6];
        size_t                len;
        char                *buf;
        unsigned char        *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl    *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error/n");
            return NULL;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1/n");
            return NULL;
        }
        
        if ((buf = (char *)malloc(len)) == NULL) {
            printf("Could not allocate memory. error!/n");
            return NULL;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 2");
            return NULL;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        free(buf);
        _macAddress = [outstring uppercaseString];
    }
    return _macAddress;
}

+ (NSString*)idfa{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *)systemLanguage{
    static NSString *_systemLanguage = nil;
    if (_systemLanguage == nil) {
        NSArray* lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        if(lang.count > 0)
            _systemLanguage = lang[0];
    }
    return _systemLanguage;
}

+ (NSString *)connectionInfo{
    NetworkStatus status = [HLADReachability reachabilityForInternetConnection].currentReachabilityStatus;
    NSString *result;
    if (status == NotReachable) {
        result = @"NotReachable";
    } else if (status == ReachableViaWiFi){
        result = @"Wifi";
    } else {
        result = @"Carrier";
    }
    return result;
}

+ (NSString *)carrier{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        static CTTelephonyNetworkInfo *_info = nil;
        if (_info == nil) {
            _info = [[CTTelephonyNetworkInfo alloc] init];
        }
        return _info.subscriberCellularProvider.carrierName != nil ? _info.subscriberCellularProvider.carrierName : @"";
    } else {
        return @"";
    }
}

+ (NSString *)deviceModel{
    static NSString* _DeviceModel = nil;
    
    if(_DeviceModel == nil)
    {
        size_t size;
        ::sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        
        char* model = (char*)::malloc(size + 1);
        ::sysctlbyname("hw.machine", model, &size, NULL, 0);
        model[size] = 0;
        
        _DeviceModel = [NSString stringWithUTF8String:model];
        
        ::free(model);
    }
    
    return _DeviceModel;
}

+ (NSString *)bundleName{
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [dic objectForKey:@"CFBundleIdentifier"];
    return bundleName;
}

+ (NSString *)bundleShortVersion{
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleShortVersion = [dic objectForKey:@"CFBundleShortVersionString"];
    return bundleShortVersion;
}

+ (NSDictionary *)deviceInfoDict{

    UIDevice *device = [UIDevice currentDevice];
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleShortVersion = [dic objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleName = [dic objectForKey:@"CFBundleIdentifier"];
    NSString *bundleDisplayName = [dic objectForKey:@"CFBundleName"];
    NSDictionary *result = @{@"device_type":[HLADDeviceHelper deviceModel],
                             @"device_name":device.name,
                             @"device_idfa":[HLADDeviceHelper idfa],
                             @"device_mac":[HLADDeviceHelper macAddress],
                             @"unique_id":[HLADDeviceHelper uniqueIdentifier],
                             @"os_platform":[NSString stringWithFormat:@"%@ %@", device.systemName, device.systemVersion],
                             @"os_language":[HLADDeviceHelper systemLanguage],
                             @"connection_type":[HLADDeviceHelper connectionInfo],
                             @"carrier_name":[HLADDeviceHelper carrier],
                             @"app_name":bundleDisplayName,
                             @"app_bundle_id":bundleName,
                             @"app_version":bundleShortVersion};
    
    return result;
}

@end
