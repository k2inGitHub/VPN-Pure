//
//  KTMathUtil.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "KTMathUtil.h"

@implementation KTMathUtil

+ (int)randomIntRange:(int)num1 and:(int)num2
{
    int start = num1;
    int end = num2;
    return( start + arc4random()%(end - start) );
}

+(float)randomFloatRange:(float)num1 and:(float)num2
{
    int startVal = num1*10000;
    int endVal = num2*10000;
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    float a = randomValue;
    
    return(a /10000.0);
}

+ (int) randomChoice:(NSArray *) weights
{
    float num = 0;
    for (NSNumber *num2 in weights) {
        num += [num2 floatValue];
    }
    float num3 = [KTMathUtil randomFloatRange:0 and:num];
    num = 0;
    int num4 = 0;
    while (true)
    {
        num += [weights [num4] floatValue];
        if (num3 <= num)
        {
            break;
        }
        num4++;
        if (num4 >= weights.count)
        {
            goto Block_3;
        }
    }
    return num4;
Block_3:
    return (int)weights.count - 1;
}

@end
