//
//  AdMogoImp.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/26.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "AdMogoImp.h"
#import "AdMoGoView.h"
#import "AdMoGoInterstitial.h"
#import "AdMoGoInterstitialManager.h"
#import "Reachability.h"

@interface AdMogoImp ()<AdMoGoDelegate, AdMoGoWebBrowserControllerUserDelegate, AdMoGoInterstitialDelegate>

@property (nonatomic, assign) BOOL isPad;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) AdViewType adBannerType;

@property (nonatomic, assign) AdViewType adInterstitialType;

@property (nonatomic, strong) AdMoGoView* adsMoGoView;

@property (nonatomic, strong) AdMoGoInterstitial *adsMoGoInterstitial;


@end

@implementation AdMogoImp

- (UIView *)bannerView{
    return self.adsMoGoView;
}

- (void)getAd{
    self.isPad = [[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound;
    if (_isPad) {
        _key = self.infoDic[@"padID"];
        _adBannerType = AdViewTypeLargeBanner;
        _adInterstitialType = AdViewTypeiPadFullScreen;
    } else {
        _key = self.infoDic[@"phoneID"];
        _adBannerType = AdViewTypeNormalBanner;
        _adInterstitialType = AdViewTypeFullScreen;
    }
    
    
    [self initAdsMoGoView];
    [self initAdsMoGoInterstitial];
    [self hideBanner];
}

- (void)adjustAdSize {
//    if (!_adsMoGoView) {
//        return;
//    }
//    
//    CGRect newFrame = _adsMoGoView.frame;
//    UIView *parent = [self viewControllerForPresentAd].view;
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
//        
//        newFrame.origin.x = (parent.frame.size.width - 768)/2;
//        newFrame.origin.y = parent.frame.size.height - 100;
//        
//    } else {
//        
//        newFrame.origin.x = (parent.frame.size.width - 320)/2;
//        newFrame.origin.y =  [self viewControllerForPresentAd].view.frame.size.height - 50;
//    }
//    
//    _adsMoGoView.frame = newFrame;
    
}

- (void) initAdsMoGoView{
    if (_adsMoGoView != NULL) {
        return;
    }
    
    _adsMoGoView = [[AdMoGoView alloc] initWithAppKey:_key  adType:_adBannerType  adMoGoViewDelegate:self autoScale:YES];
    [_adsMoGoView setViewPointType:AdMoGoViewPointTypeDown_middle];
    _adsMoGoView.adWebBrowswerDelegate = self;
    
    UIViewController *controller = [self viewControllerForPresentAd];
    
    UIView *view = controller.view;
//    _adsMoGoView.frame = CGRectMake(0, 100, view.frame.size.width, view.frame.size.height);
    
    [view addSubview:_adsMoGoView];
    [view bringSubviewToFront:_adsMoGoView];
    
}

- (void)initAdsMoGoInterstitial{
    
    _adsMoGoInterstitial = [[AdMoGoInterstitialManager shareInstance] adMogoInterstitialByAppKey:self.key];
    _adsMoGoInterstitial.delegate = self;
    if (_adsMoGoInterstitial) {
        _adsMoGoInterstitial.adWebBrowswerDelegate = self;
    }
}

- (void)showBanner{
    
    [self initAdsMoGoView];
    if (_adsMoGoView) {
        _adsMoGoView.hidden = NO;
    }
    
    [self adjustAdSize];
}

- (void)hideBanner{
    if (_adsMoGoView) {
        _adsMoGoView.hidden = YES;
    }
}

- (void)showInterstitial{
    [self initAdsMoGoInterstitial];
    if (_adsMoGoInterstitial) {
        [_adsMoGoInterstitial interstitialShow:YES];
    }
}

- (BOOL)isInterstitialLoaded{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    //    Reachability2 *reach = [Reachability2 reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark AdMoGoDelegate delegate
/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView{
    return [self viewControllerForPresentAd];
}



/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
    //    UnitySendMessage("AdMoGoManager", "adMoGoDidStartAd","");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView{
    //    UnitySendMessage("AdMoGoManager","adMoGoDidReceiveAd","");
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error{
    //    NSString *errorStr = [error description];
    //    const char *err = [errorStr cStringUsingEncoding:NSUTF8StringEncoding];
    //    UnitySendMessage("AdMoGoManager","adMoGoDidFailToReceiveAd",err);
}
/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView{
    //    UnitySendMessage("AdMoGoManager","adMoGoClickAd","");
}
/**
 *You can get notified when the user delete the ad
 广告关闭回调
 */
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView{
    //    UnitySendMessage("AdMoGoManager","adMoGoDeleteAd","");
    [self showBanner];
}

- (void)adMoGoInitFinish:(AdMoGoView *)adMoGoView{
    //    UnitySendMessage("AdMoGoManager","adMoGoInitFinish","");
}


/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingInterstitialModalView{
    return [self viewControllerForPresentAd];
}


/*
 全屏广告开始请求
 */
- (void)adsMoGoInterstitialAdDidStart{
    //    UnitySendMessage("AdMoGoManager","adsMoGoInterstitialAdDidStart","");
}

/*
 全屏广告准备完毕
 */
- (void)adsMoGoInterstitialAdIsReady{
    //    UnitySendMessage("AdMoGoManager","adsMoGoInterstitialAdIsReady","");
}

/*
 全屏广告接收成功
 */
- (void)adsMoGoInterstitialAdReceivedRequest{
    //    UnitySendMessage("AdMoGoManager","adsMoGoInterstitialAdReceivedRequest","");
}

/*
 全屏广告将要展示
 */
- (void)adsMoGoInterstitialAdWillPresent{
    //    UnitySendMessage("AdMoGoManager","adsMoGoInterstitialAdWillPresent","");
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialPresentNotification object:nil userInfo:@{HLAdTypeKey : HLAdMogo}];
}

/*
 全屏广告接收失败
 */
- (void)adsMoGoInterstitialAdFailedWithError:(NSError *) error{
//    NSString *errorStr = [error description];
    //    const char *err = [errorStr cStringUsingEncoding:NSUTF8StringEncoding];
    //    UnitySendMessage("AdMoGoManager","adsMoGoInterstitialAdFailedWithError",err);
}

/*
 全屏广告消失
 */
- (void)adsMoGoInterstitialAdDidDismiss{
    //    UnitySendMessage("AdMoGoManager","adsMoGoInterstitialAdDidDismiss","");
    [[NSNotificationCenter defaultCenter] postNotificationName:HLInterstitialFinishNotification object:nil userInfo:@{HLAdTypeKey : HLAdMogo}];
}

/*
 全屏广告浏览器展示
 */
- (void)adsMoGoWillPresentInterstitialAdModal{
    //    UnitySendMessage("AdMoGoManager","adsMoGoWillPresentInterstitialAdModal","");
}

/*
 全屏广告浏览器消失
 */
- (void)adsMoGoDidDismissInterstitialAdModal{
    //    UnitySendMessage("AdMoGoManager","adsMoGoDidDismissInterstitialAdModal","");
}

/*
 芒果广告关闭
 */
- (void)adsMogoInterstitialAdClosed{
    //    UnitySendMessage("AdMoGoManager","adsMogoInterstitialAdClosed","");
    
}

/**
 *视频广告加载成功
 */
-(void)adsMogoInterstitial:(AdMoGoInterstitial *)adMoGoInterstitial didLoadVideoAd:(NSURL *)url{
    //    NSString *url_str = [url absoluteString];
    //    const char *url_char = [url_str cStringUsingEncoding:NSUTF8StringEncoding];
    //    UnitySendMessage("AdMoGoManager","didLoadVideoAd",url_char);
}
/**
 *视频广告加载失败
 */
-(void)adsMogoInterstitial:(AdMoGoInterstitial *)adMoGoInterstitial failLoadVideoAd:(NSURL *)url{
    //    NSString *url_str = [url absoluteString];
    //    const char *url_char = [url_str cStringUsingEncoding:NSUTF8StringEncoding];
    //    UnitySendMessage("AdMoGoManager","failLoadVideoAd",url_char);
}
/**
 *视频广告开始播放
 */
-(void)adsMogoInterstitial:(AdMoGoInterstitial *)adMoGoInterstitial didPlayVideoAd:(NSURL *)url{
    //    NSString *url_str = [url absoluteString];
    //    const char *url_char = [url_str cStringUsingEncoding:NSUTF8StringEncoding];
    //    UnitySendMessage("AdMoGoManager","didPlayVideoAd",url_char);
}
/**
 *视频广告播放完成
 */
-(void)adsMogoInterstitial:(AdMoGoInterstitial *)adMoGoInterstitial finishVideoAd:(NSURL *)url{
    //    NSString *url_str = [url absoluteString];
    //    const char *url_char = [url_str cStringUsingEncoding:NSUTF8StringEncoding];
    //    UnitySendMessage("AdMoGoManager","finishVideoAd",url_char);
}

/*
 芒果广告轮空回调
 */
- (void)adsMogoInterstitialAdAllAdsFail:(NSError *) error{
    //    NSString *errorStr = [error description];
    //    const char *err = [errorStr cStringUsingEncoding:NSUTF8StringEncoding];
    //    UnitySendMessage("AdMoGoManager","adsMogoInterstitialAdAllAdsFail",err);
}



-(BOOL)interstitialShouldAlertQAView:(UIAlertView *)alertView{
    return NO;
}

/*插屏初始化回调*/
- (void)adMoGoInterstitialInitFinish{
    //    UnitySendMessage("AdMoGoManager","adMoGoInterstitialInitFinish","");
}

- (void)adMoGoInterstitialInMaualfreshAllAdsFail{
    //    UnitySendMessage("AdMoGoManager","adMoGoInterstitialInMaualfreshAllAdsFail","");
}

#pragma mark -
#pragma mark AdMoGoWebBrowserControllerUserDelegate delegate

/*
 浏览器将要展示
 */
- (void)webBrowserWillAppear{
    NSLog(@"浏览器将要展示");
}

/*
 浏览器已经展示
 */
- (void)webBrowserDidAppear{
    NSLog(@"浏览器已经展示");
}

/*
 浏览器将要关闭
 */
- (void)webBrowserWillClosed{
    NSLog(@"浏览器将要关闭");
}

/*
 浏览器已经关闭
 */
- (void)webBrowserDidClosed{
    NSLog(@"浏览器已经关闭");
}
/**
 *直接下载类广告 是否弹出Alert确认
 */
-(BOOL)shouldAlertQAView:(UIAlertView *)alertView{
    return NO;
}

- (void)webBrowserShare:(NSString *)url{
    
}

@end
