//
//  NSString+HLAD.h
//  HLADs
//
//  Created by 宋扬 on 16/3/21.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HLAD)

- (NSString *)MD5Hash;

+ (NSString *)JSONStringFromObject:(id)object;

@end
