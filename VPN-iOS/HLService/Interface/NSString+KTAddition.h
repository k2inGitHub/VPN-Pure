//
//  NSString+KTAddition.h
//  colorful
//
//  Created by SongYang on 14-4-28.
//
//

#import <Foundation/Foundation.h>

@interface NSString (KTAddition)

+ (NSString *)macAddress;

+ (NSString*)timeToken;

+ (NSString *)stringFromJasonDict:(NSDictionary *)dict;

-(NSString*)SDKEncodeString;

-(NSString*)SDKDecodeString;

-(NSString*)encodeNetData;

-(NSString*)decodeNetData;

-(NSMutableArray*)parseUrlAndPar;
@end
