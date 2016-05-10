
//
//  NSString+KTAddition.m
//  colorful
//
//  Created by SongYang on 14-4-28.
//
//

#import "NSString+KTAddition.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define DES_KEY  @"8E[*Du9P"


@implementation NSString (KTAddition)

+ (NSString *)stringFromJasonDict:(NSDictionary *)dict
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *content = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (error) {
        NSLog(@"stringFromJasonDict error = %@", [error description]);
    }
    return content;
}

+ (NSString *)macAddress
{
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
    
    if ((buf = malloc(len)) == NULL) {
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
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+(NSString*)timeToken
{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    double i=time;
    
    NSString *token =[NSString stringWithFormat:@"%llu", (UInt64)i];
    return token;
}

-(NSString*)SDKEncodeString
{
    
    int length = (int)[self length];
    int unUseCount = [[self substringWithRange:NSMakeRange(0, 1)]intValue];
    
    NSString * randStr = [NSString stringWithFormat:@""];

    for (int i=0; i<unUseCount*length; i++) {
        randStr = [randStr stringByAppendingFormat:@"%d",rand()%10  ];
    }
    
    NSString * encodeStr = [NSString stringWithFormat:@""];
    
    for (int i=0; i<length; i++) {
        
        NSString * groupStr = [NSString stringWithFormat:@"%@%@",[self substringWithRange:NSMakeRange(i, 1)],[randStr substringWithRange:NSMakeRange(unUseCount*i, unUseCount)]];
        
        encodeStr =  [encodeStr stringByAppendingString:groupStr];
        
        
    }
    
    return encodeStr;
    
}

-(NSString*)SDKDecodeString
{
    int length = (int)[self length];
    int unUseCount = [[self substringWithRange:NSMakeRange(0, 1)]intValue];
    

    NSString * decodeStr =[NSString stringWithFormat:@""];
    for (int i=0; i<length/(unUseCount+1);i++) {
        decodeStr =  [decodeStr stringByAppendingString:[self substringWithRange:NSMakeRange((unUseCount+1)*i, 1)]];
    }

    return decodeStr;
}

-(NSString*)encodeNetData
{
    NSString * encrypt;
    encrypt = self;
    NSLog(@"url encode begin encypt = %@",encrypt);
    encrypt = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)encrypt, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSLog(@"url encode  encypt = %@",encrypt);
    return encrypt;
}

-(NSString*)decodeNetData
{
    return nil;
}

-(NSMutableArray*)parseUrlAndPar
{
    NSMutableArray * parameterArray = [[NSMutableArray alloc]init];
    
    NSRange range = [self rangeOfString:@"?"];
    
    NSString * url = [self substringWithRange:NSMakeRange(0, range.location)];
    
    
    [parameterArray addObject:url];
    
    NSString * paraString = [self substringWithRange:NSMakeRange(range.location+1, self.length - range.location-1)];
    
    
    NSArray * paraArray = [paraString componentsSeparatedByString:@"&"];
    
    for (NSString * str in paraArray) {
        
        NSArray * tec = [str componentsSeparatedByString:@"="];
        
        [parameterArray addObject:tec];
    }
    
    return parameterArray;
}
@end
