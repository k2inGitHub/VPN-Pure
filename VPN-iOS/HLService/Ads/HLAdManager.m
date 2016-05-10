//
//  RateUs.m
//  zuanshimicheng
//
//  Created by zhangrui on 14-5-23.
//
//

#import "HLAdManager.h"
#import "HLInterface.h"
#import "NSString+KTAddition.h"
//#import "AdMobViewController.h"
//#import "BannerAdViewController.h"
//#import "UnityAdViewController.h"
//#import "AdMobViewController.h"
#import "AdMobImp.h"
#import "AdMogoImp.h"
#import "AdUnityImp.h"
#import "AdVungleImp.h"
#import "AdHLImp.h"
#import "AdDummyImp.h"

NSString * const HLInterstitialFinishNotification = @"HLInterstitialFinishNotification";

NSString * const HLInterstitialFailureNotification = @"HLInterstitialFailureNotification";

NSString * const HLInterstitialPresentNotification = @"HLInterstitialPresentNotification";

NSString * const HLAdTypeKey = @"AdType";

HLAdType HLAdMogo = @"mogo";
HLAdType HLAdAdmob = @"admob";
HLAdType HLAdUnity = @"unity";
HLAdType HLAdVungle = @"vungle";
HLAdType HLAdHandloft = @"handloft";

@interface HLAdManager ()

@property (nonatomic, strong) AdMobImp *adMob;

@property (nonatomic, strong) AdMogoImp *adMogo;

@property (nonatomic, strong) AdUnityImp *adUnity;

@property (nonatomic, strong) AdVungleImp *adVungle;

@property (nonatomic, strong) AdDummyImp *adDummy;

@property (nonatomic, strong) AdHLImp *adHL;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) float interval;

@end

@implementation HLAdManager


+(id)sharedInstance{
    static HLAdManager* instance = nil;
    if(instance == nil){
        @synchronized(self){
            if(instance == nil){
                instance = [[HLAdManager alloc] init];
            }
        }
    }
    return  instance;
}
-(id)init{
    self = [super init];
    if(self){
        
        HLInterface *hl = [HLInterface sharedInstance];
        
        _adMob = [[AdMobImp alloc] initWithAdManager:self
                                             andInfo:@{@"bannerID" : hl.ctrl_admob_banner_id,
                                                       @"initerialID" : hl.ctrl_admob_pop_id}];
        [_adMob getAd];
        
        
        _adMogo = [[AdMogoImp alloc] initWithAdManager:self
                                               andInfo:@{@"phoneID" : hl.ctrl_banner_iphone_id,
                                                         @"padID" : hl.ctrl_banner_ipad_id}];
        [_adMogo getAd];
        
        _adUnity = [[AdUnityImp alloc] initWithAdManager:self andInfo:@{@"appID" : hl.unityad_code}];
        [_adUnity getAd];
        
        _adVungle = [[AdVungleImp alloc] initWithAdManager:self andInfo:@{@"appID" : hl.vungle_code}];
        [_adVungle getAd];
        
        _adHL = [[AdHLImp alloc] initWithAdManager:self andInfo:@{@"bannerID" : hl.ctrl_left_banner_id,
                                                                  @"initerialID" : hl.ctrl_left_pop_id,
                                                                  @"fixIniterialID" : hl.ctrl_fixed_pop_id}];
        [_adHL getAd];
        
        _adDummy = [[AdDummyImp alloc] initWithAdManager:self andInfo:nil];
        [_adDummy getAd];
        
        mangoColdTime=unityColdTime=vungleColdTime=admobColdTime=-1;
        haveTick = false;
        
        _interval = 0.1f;
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(tick) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)showBanner{
    
    if ([HLInterface sharedInstance].market_reviwed_status == 0) {
        [_adDummy showBanner];
    }else if([[HLInterface sharedInstance] ctrl_admob_banner_switch]==1){
        [_adMob showBanner];
    } else if([[HLInterface sharedInstance] ctrl_banner_switch]==1){
        [_adMogo showBanner];
    } else if ([HLInterface sharedInstance].ctrl_left_banner_switch == 1) {
        [_adHL showBanner];
    }
}

- (UIView *)bannerView{
    AdBaseImp *ad = nil;
    if ([HLInterface sharedInstance].market_reviwed_status == 0) {
        ad = _adDummy;
    }else if([[HLInterface sharedInstance] ctrl_admob_banner_switch]==1){
        ad = _adMob;
    } else if([[HLInterface sharedInstance] ctrl_banner_switch]==1){
        ad = _adMogo;
    } else if ([HLInterface sharedInstance].ctrl_left_banner_switch == 1) {
        ad = _adHL;
    }
    if (ad != nil) {
        return [ad bannerView];
    }
    return nil;
}

-(void)hideBanner{
    [_adMob hideBanner];
    [_adMogo hideBanner];
    [_adHL hideBanner];
    [_adDummy hideBanner];
}

-(void)showSafeInterstitial{
    if([[HLInterface sharedInstance] ctrl_pop_switch]!=1){
        return;
    }
    if([[HLInterface sharedInstance] ctrl_admob_pop_switch]==1&&admobColdTime<=0){
        if(haveTick==true){
            admobColdTime=[[HLInterface sharedInstance] ctrl_admob_pop_time];
        }
        [_adMob showInterstitial];
    }
    else if([[HLInterface sharedInstance] ctrl_unityad_pop_switch]==1&&[_adUnity isInterstitialLoaded]==true&&unityColdTime<=0){
        if(haveTick==true){
            unityColdTime=[[HLInterface sharedInstance] ctrl_unityad_pop_time];
        }
        [_adUnity showInterstitial];
    }
    else if([[HLInterface sharedInstance] ctrl_mango_pop_switch]==1&&mangoColdTime<=0){
        if(haveTick==true){
            mangoColdTime=[[HLInterface sharedInstance] ctrl_mango_pop_time];
        }
        [_adMogo showInterstitial];
    } else if ([HLInterface sharedInstance].ctrl_vungle_pop_switch == 1 && vungleColdTime <= 0){
        if(haveTick==true){
            vungleColdTime=[[HLInterface sharedInstance] ctrl_vungle_pop_time];
        }
        [_adVungle showInterstitial];
    } else if ([HLInterface sharedInstance].ctrl_left_pop_switch == 1) {
        [_adHL showInterstitial];
    }
}

-(void)showUnsafeInterstitial{
    if([[HLInterface sharedInstance] ctrl_pop_switch]!=1){
        return;
    }
    if([[HLInterface sharedInstance] ctrl_unsafe_admob_pop_switch]==1&&admobColdTime<=0){
        if(haveTick==true){
            admobColdTime=[[HLInterface sharedInstance] ctrl_admob_pop_time];
        }
        [_adMob showInterstitial];
    }
    else if([[HLInterface sharedInstance] ctrl_unsafe_unityad_pop_switch]==1&&[_adUnity isInterstitialLoaded]==true&&unityColdTime<=0){
        if(haveTick==true){
            unityColdTime=[[HLInterface sharedInstance] ctrl_unityad_pop_time];
        }
        [_adUnity showInterstitial];
    }
    else if([[HLInterface sharedInstance] ctrl_unsafe_mango_pop_switch]==1&&mangoColdTime<=0){
        if(haveTick==true){
            mangoColdTime=[[HLInterface sharedInstance] ctrl_mango_pop_time];
        }
        [_adMogo showInterstitial];
    } else if ([HLInterface sharedInstance].ctrl_unsafe_vungle_pop_switch == 1 && vungleColdTime <= 0){
        if(haveTick==true){
            vungleColdTime=[[HLInterface sharedInstance] ctrl_vungle_pop_time];
        }
        [_adVungle showInterstitial];
    } else if ([HLInterface sharedInstance].ctrl_unsafe_left_pop_switch == 1) {
        [_adHL showInterstitial];
    }
}

- (BOOL)isEncourageInterstitialLoaded{
    BOOL ret = NO;
    if ([HLInterface sharedInstance].encouraged_ad_strategy_unityad_switch == 1 && [_adUnity isInterstitialLoaded]) {
        ret = YES;
    } else if ([HLInterface sharedInstance].encouraged_ad_strategy_vungle_switch == 1 && [_adVungle isInterstitialLoaded]) {
        ret = YES;
    }
    return ret;
}

- (void)showEncourageInterstitial{

    AdBaseImp *_targetAdEncouragedInterstitial = nil;
    if ([HLInterface sharedInstance].encouraged_ad_strategy_unityad_switch == 1 && [_adUnity isInterstitialLoaded]) {
        _targetAdEncouragedInterstitial = _adUnity;
    } else if ([HLInterface sharedInstance].encouraged_ad_strategy_vungle_switch == 1 && [_adVungle isInterstitialLoaded]) {
        _targetAdEncouragedInterstitial = _adVungle;
    }
    if (_targetAdEncouragedInterstitial != nil) {
        [_targetAdEncouragedInterstitial showInterstitial];
    }
}

- (BOOL)isSplashInterstitialLoaded{
    BOOL ret = NO;
    if ([HLInterface sharedInstance].loading_left_pop_switch && [_adHL isInterstitialSplashLoaded]) {
        ret = YES;
    } else if ([HLInterface sharedInstance].loading_admob_pop_switch && [_adMob isInterstitialLoaded]) {
        ret = YES;
    } else if ([HLInterface sharedInstance].loading_mango_pop_switch && [_adMogo isInterstitialLoaded]){
        ret = YES;
    }
    return ret;
}

- (void)showSplashInterstitial{

    if ([HLInterface sharedInstance].loading_left_pop_switch && [_adHL isInterstitialSplashLoaded]) {
        [_adHL showInterstitialSplash];
    } else if ([HLInterface sharedInstance].loading_admob_pop_switch && [_adMob isInterstitialLoaded]) {
        [_adMob showInterstitial];
    } else if ([HLInterface sharedInstance].loading_mango_pop_switch && [_adMogo isInterstitialLoaded]){
        [_adMogo showInterstitial];
    }
}

- (void)showButtonInterstitial:(NSString *)positionTag{
    if ([HLInterface sharedInstance].button_left_pop_switch && [_adHL isInterstitialButtonLoaded]) {
        [_adHL showInterstitialButton:positionTag];
    } else if ([HLInterface sharedInstance].button_unityad_pop_switch && [_adUnity isInterstitialLoaded]){
        [_adUnity showInterstitial];
    } else if ([HLInterface sharedInstance].button_vungle_pop_switch && [_adVungle isInterstitialLoaded]) {
        [_adVungle showInterstitial];
    }
}

- (void)tick{
    haveTick = true;
    admobColdTime -= _interval;
    unityColdTime -= _interval;
    mangoColdTime -= _interval;
    vungleColdTime -= _interval;
}

@end
