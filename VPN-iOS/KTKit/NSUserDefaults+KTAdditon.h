//
//  NSUserDefaults+KTAddition.h
//  colorful
//
//  Created by SongYang on 14-4-24.
//
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (KTAddition)

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (int)integerForKey:(NSString *)key defaultValue:(int)defaultValue;

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

@end

