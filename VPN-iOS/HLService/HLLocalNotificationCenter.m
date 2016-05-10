//
//  KTLocalNotificationCenter.m
//  HLADs
//
//  Created by 宋扬 on 16/3/22.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLLocalNotificationCenter.h"
#import "AFNetworking.h"
#import "NSString+HLAD.h"
#import "HLADDeviceHelper.h"
#import "HLADEvent.h"



#define SERVERCE_IOS (1)
#define SERVERCE_UNITY (0)

#if SERVERCE_IOS
#import "HLAdManager.h"
#endif

#if SERVERCE_UNITY
#import "UnityAppController.h"
#endif

static NSString* const notificationURL = @"http://203.195.128.244/ao2/u3d_pc.php";

@interface HLLocalNotificationCenter ()

@property (nonatomic, strong) NSArray* dataArray;

@end

@implementation HLLocalNotificationCenter

- (void)schedeuleAll{
    
    [self cancelALL];
    if (self.dataArray) {
        for (NSDictionary *dic in self.dataArray) {
            [self scheduleNotificationWithTargetTime:dic[@"msg_sending_time"] message:dic[@"msg_content"] userInfo:dic];
        }
    }
}

- (void)cancelALL{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self requestData];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (handle_NotificationEvent:)
                               name: @"kUnityDidReceiveLocalNotification"
                             object: nil];
    
    return self;
}

- (void)handle_NotificationEvent:(NSNotification *) receivedNotification {
    [HLADEvent eventLocalNotification:(UILocalNotification *)receivedNotification.userInfo];
#if SERVERCE_IOS
    if ([[HLAdManager sharedInstance] isSplashInterstitialLoaded]) {
        [[HLAdManager sharedInstance] showSplashInterstitial];
    }
#endif
#if SERVERCE_UNITY
    UnitySendMessage("HandloftAdsManager", "receivedNotification","");
#endif
}

- (void)requestData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSURLSessionDataTask *task = [manager GET:notificationURL parameters:@{@"content":[NSString JSONStringFromObject:@{@"app_bundle_id":[HLADDeviceHelper bundleName],@"app_version" : [HLADDeviceHelper bundleShortVersion]}]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"]intValue]==0) {
            NSDictionary *data = responseObject[@"data"];
            self.dataArray = data[@"list"];
            [[NSUserDefaults standardUserDefaults] setObject:self.dataArray forKey:@"HL_LocalNotifications"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {
            self.dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"HL_LocalNotifications"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"HL_LocalNotifications"];
    }];
    
    NSLog(@"task = %@", task.originalRequest.URL);
}

- (void)scheduleNotificationWithTargetTime:(NSString *)targetTime message:(NSString *)msg userInfo:(NSDictionary *)userInfo{

    NSDate *currentDate = [NSDate date];
    NSDateFormatter* df2 = [[NSDateFormatter alloc] init];
    df2.timeZone = [NSTimeZone localTimeZone];
    df2.dateFormat = @"yyyy/MM/dd";
//    NSLog(@"str = %@", [df2 stringFromDate:currentDate]);
    NSString *todayStr = [df2 stringFromDate:currentDate];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@", todayStr, targetTime];
    NSDateFormatter* df3 = [[NSDateFormatter alloc] init];
    df3.timeZone = [NSTimeZone localTimeZone];
    df3.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate *targetDate = [df3 dateFromString:dateStr];
    
    
    if ([currentDate compare:targetDate] == NSOrderedDescending) {
        targetDate = [targetDate dateByAddingTimeInterval:60*60*24];
    }
    NSLog(@"targetDate = %@", targetDate);
    [self scheduleNotification:targetDate message:msg sound:YES alarmID:@"" badges:1 repeatInterval:NSCalendarUnitDay userInfo:userInfo];
}

- (void)scheduleNotification:(NSDate *)fireDate message:(NSString *)messgae sound:(BOOL)sound alarmID:(NSString *)alarmID badges:(int)badges repeatInterval:(NSCalendarUnit)repeatInterval userInfo:(NSDictionary *)userInfo{
    

    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.repeatInterval = repeatInterval;
    localNotification.fireDate = fireDate;
    
//    NSLog(@"fireDate = %@", localNotification.fireDate);
//    NSLog(@"now = %@", [NSDate date]);
    
    localNotification.alertBody = messgae;
    localNotification.timeZone = [NSTimeZone localTimeZone];
//    if (badges > 0)
//        localNotification.applicationIconBadgeNumber = badges;
    
    
    if(sound) {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    localNotification.userInfo = userInfo;
    
    [self registerUserNotification];
//    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:alarmID forKey:@"AlarmKey"];
//    // Set some extra info to your alarm
//    localNotification.userInfo = userInfo;
//    
//    NSLog(@"scheduleNotification AlarmKey: %@", alarmID);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

- (void)registerUserNotification{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

+ (instancetype)sharedCenter{
    static HLLocalNotificationCenter *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[[self class] alloc] init];
    });
    return _sharedManager;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
