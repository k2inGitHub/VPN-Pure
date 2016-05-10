//
//  HLDeviceHelper.h
//  HLADs
//
//  Created by 宋扬 on 16/3/21.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLADDeviceHelper : NSObject

+ (NSDictionary *)deviceInfoDict;

+ (NSString *)bundleName;

+ (NSString *)bundleShortVersion;

@end
