//
//  NSUserDefaults+KTAddition.m
//  colorful
//
//  Created by SongYang on 14-4-24.
//
//

#import "NSUserDefaults+KTAdditon.h"

@implementation NSUserDefaults (KTAddition)

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    BOOL ret = defaultValue;
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (value)
    {
        ret = [value boolValue];
    }
    return ret;
}

- (int)integerForKey:(NSString *)key defaultValue:(int)defaultValue
{
    int ret = defaultValue;
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (value)
    {
        ret = [value intValue];
    }
    
    return ret;
}

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (! str)
    {
        return defaultValue;
    }
    else
    {
        return str;
    }
}

@end
