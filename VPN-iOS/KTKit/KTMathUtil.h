//
//  KTMathUtil.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTMathUtil : NSObject

+ (int)randomIntRange:(int)num1 and:(int)num2;

+ (float)randomFloatRange:(float)num1 and:(float)num2;

+ (int)randomChoice:(NSArray *) weights;

@end
