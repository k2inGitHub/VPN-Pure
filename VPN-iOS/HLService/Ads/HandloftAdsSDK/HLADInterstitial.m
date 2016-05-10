//
//  HLADInterstitial.m
//  HLADs
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLADInterstitial.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"
#import "UIButton+AFNetworking.h"
#import "HLADConfig.h"
#import "HLADInterstitialModel.h"
#import "HLADInterstitialController.h"
#import "HLADDeviceHelper.h"
#import "NSString+HLAD.h"
#import "HLADCommon.h"

@interface HLADInterstitial ()<HLADInterstitialControllerDelegate>

@property(nonatomic, copy) NSString *adUnitID;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) int row;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) AFImageDownloader *imageDownloader;

@property (nonatomic, strong) NSURLRequest *imageURL;

@property (nonatomic, readonly) HLADInterstitialModel *currentModel;

@property (nonatomic, assign) BOOL isReady;

@property (nonatomic, assign) BOOL hasBeenUsed;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, weak) UIViewController *rootViewController;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) HLADInterstitialController *interstitialController;

@property (nonatomic, strong) HLADRequest *request;

@property (nonatomic, copy) NSString *positionTag;

@property (nonatomic, copy) HLADType typeName;

@end

@implementation HLADInterstitial

- (void)interstitialControllerWillLeaveApplication{
    [self eventRequest:@"点击"];
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialWillLeaveApplication:)]){
        [_delegate interstitialWillLeaveApplication:self];
    }
}

- (void)interstitialControllerWillDismiss{
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialWillDismissScreen:)]){
        [_delegate interstitialWillDismissScreen:self];
    }
}

- (void)interstitialControllerDidDismiss{
    
    [self eventRequest:@"关闭"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialDidDismissScreen:)]){
        [_delegate interstitialDidDismissScreen:self];
    }
}

- (HLADInterstitialModel *)currentModel{
    return self.dataArray[_row];
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController{
    self.positionTag = @"补余";
    self.rootViewController = rootViewController;
    [self present];
    
}

- (void)presentFromRootViewControllerAsButton:(UIViewController *)rootViewController positionTag:(NSString *)tag{
    self.positionTag = tag;
    self.rootViewController = rootViewController;
    [self present];
}

- (void)presentFromRootViewControllerAsSplash:(UIViewController *)rootViewController{
    self.positionTag = @"开始";
    self.rootViewController = rootViewController;
    [self present];
}

- (void)present{
    if (!self.isReady) {
        if (_delegate && [_delegate respondsToSelector:@selector(interstitial: didFailToReceiveAdWithError:)]) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:@{NSLocalizedFailureReasonErrorKey:@"广告未准备好"}];
            [_delegate interstitial:self didFailToReceiveAdWithError:error];
        }
        return;
    }
    if (self.hasBeenUsed) {
        if (_delegate && [_delegate respondsToSelector:@selector(interstitial: didFailToReceiveAdWithError:)]) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:@{NSLocalizedFailureReasonErrorKey:@"广告已使用"}];
            [_delegate interstitial:self didFailToReceiveAdWithError:error];
        }
        return;
    }
    if (!self.rootViewController) {
        HLADLOG(@"未指定根视图控制器，无法继续");
        return;
    }
    
    
    
    if (!self.interstitialController) {
        _interstitialController = [[HLADInterstitialController alloc] init];
        _interstitialController.contentImage = self.image;
        _interstitialController.model = [self currentModel];
        _interstitialController.delegate = self;
        _interstitialController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    [self eventRequest:@"展示"];
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialWillPresentScreen:)]) {
        [_delegate interstitialWillPresentScreen:self];
    }
    [self.rootViewController presentViewController:_interstitialController animated:YES completion:^{
        
//        _row++;
//        if (_row >= self.dataArray.count) {
//            _row = 0;
//        }
        self.hasBeenUsed = YES;
    }];
}

- (void)eventRequest:(NSString *)event{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TimeOut60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[HLADDeviceHelper deviceInfoDict]];
    [dict setObject:self.positionTag forKey:@"position_code"];
    [dict setObject:self.typeName forKey:@"ad_format"];
    [dict setObject:self.currentModel.list_id forKey:@"ad_list_id"];
    [dict setObject:self.currentModel.interstitial_id forKey:@"ad_id"];
    [dict setObject:self.currentModel.update_increase forKey:@"ad_version"];
    [dict setObject:event forKey:@"action"];
    [dict setObject:self.currentModel.event_id forKey:@"event_id"];
    
    [manager GET:AdEventUrl parameters:@{@"code":self.adUnitID,@"content":[NSString JSONStringFromObject:dict]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HLADLOG(@"event success = %@", responseObject);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HLADLOG(@"event error = %@", error);
    }];
}

- (void)requestAd{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TimeOut15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[HLADDeviceHelper deviceInfoDict]];
    [dict setObject:@"" forKey:@"position_code"];
    [dict setObject:self.typeName forKey:@"ad_format"];
    
    NSURLSessionDataTask *task = [manager GET:[HLADCommon adInterstialUrl] parameters:@{@"code":self.adUnitID,@"content":[NSString JSONStringFromObject:dict]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *root = responseObject[@"data"];
        NSArray *list = root[@"list"];
        NSString *status = responseObject[@"status"];
        if ([status intValue] == 0) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
            for (int i = 0; i < list.count; i++) {
                [array addObject:[[HLADInterstitialModel alloc] initWithDic:list[i]]];
            }
            self.dataArray = array;
            if (self.currentModel.ctrl_recommend_pop_image.length>0) {
                self.imageURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentModel.ctrl_recommend_pop_image] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeOut15];
                HLADLOG(@"imageURL = %@", self.currentModel.ctrl_recommend_pop_image);
                [self.imageDownloader downloadImageForURLRequest:self.imageURL success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                    self.image = responseObject;
                    
                    if (self.image) {
                        self.isReady = YES;
                        if (_delegate && [_delegate respondsToSelector:@selector(interstitialDidReceiveAd:)]) {
                            [_delegate interstitialDidReceiveAd:self];
                        }
                    } else {
                        if (_delegate && [_delegate respondsToSelector:@selector(interstitial: didFailToReceiveAdWithError:)]) {
                            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:@{NSLocalizedFailureReasonErrorKey:@"展示图片为空"}];
                            [_delegate interstitial:self didFailToReceiveAdWithError:error];
                        }
                    }
                    
                } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                    if (_delegate && [_delegate respondsToSelector:@selector(interstitial: didFailToReceiveAdWithError:)]) {
                        
                        [_delegate interstitial:self didFailToReceiveAdWithError:error];
                    }
                }];
            }
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(interstitial: didFailToReceiveAdWithError:)]) {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:@{@"status" : status}];
                [_delegate interstitial:self didFailToReceiveAdWithError:error];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_delegate && [_delegate respondsToSelector:@selector(interstitial: didFailToReceiveAdWithError:)]) {
            [_delegate interstitial:self didFailToReceiveAdWithError:error];
        }
    }];
    
    HLADLOG(@"url = %@", [task.originalRequest URL]);
}

- (void)loadRequest:(HLADRequest *)request{
    self.request = request;
    
    if ([HLADCommon adInterstialUrl]) {
        [self requestAd];
    } else {
        [HLADCommon requestApiSuccess:^(NSString *adBannerUrl, NSString *adInterstitialUrl, NSString *adFixedInterstitialUrl) {
            [self requestAd];
        } failure:^(NSError *error) {
            if (_delegate && [_delegate respondsToSelector:@selector(interstitial: didFailToReceiveAdWithError:)]) {
                [_delegate interstitial:self didFailToReceiveAdWithError:error];
            }
        }];
    }
}

- (instancetype)initWithAdUnitID:(NSString *)adUnitID typeName:(HLADType)type{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.adUnitID = adUnitID;
    self.imageDownloader = [[AFImageDownloader alloc] init];
    self.isReady = NO;
    self.hasBeenUsed = NO;
    _row = 0;
    self.typeName = type;
    return self;
}

-(void)dealloc{

    if (_interstitialController.presentingViewController != nil) {
        [_interstitialController performSelector:@selector(onCancel)];
    }
}

@end
