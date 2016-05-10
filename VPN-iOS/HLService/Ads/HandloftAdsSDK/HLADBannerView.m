//
//  HLADBannerView.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLADBannerView.h"
#import "HLADCommon.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"
#import "UIButton+AFNetworking.h"
#import "HLADBannerModel.h"
#import "HLADConfig.h"
#import "HLADDeviceHelper.h"
#import "NSString+HLAD.h"

@interface HLADBannerView ()

@property (nonatomic, copy) NSString* redictURL;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSURL *imageRequest;

@property (nonatomic, strong) AFImageDownloader *imageDownloader;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, assign) HLADAdSize adSize;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) int row;

@property (nonatomic, readonly) HLADBannerModel*currentModel;
//goto config?
@property (nonatomic, assign) float refreshTime;

@property (nonatomic, strong) NSTimer *refreshTimer;

@property (nonatomic, strong) HLADRequest *request;

@end

@implementation HLADBannerView

-(HLADBannerModel *)currentModel{
    return self.dataArray[self.row];
}

- (void)requestAd{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeOut8;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[HLADDeviceHelper deviceInfoDict]];
    [dict setObject:@"补余" forKey:@"position_code"];
    [dict setObject:HLAD_Banner forKey:@"ad_format"];
    HLADLOG(@"dict = %@", dict);
    //    dict = @{@"haha":@"aa",@"gg":@"bb"};
    HLADLOG(@"des = %@", [NSString JSONStringFromObject:dict]);
    
    NSURLSessionDataTask *task = [manager GET:[HLADCommon adBannerUrl] parameters:@{@"code" : self.adUnitID, @"content": [NSString JSONStringFromObject:dict]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *root = responseObject[@"data"];
        NSString *status = responseObject[@"status"];
        if ([status intValue] == 0) {
            
            NSTimeInterval refreshTime = [responseObject[@"timer"] floatValue];
            if (self.refreshTime != refreshTime) {
                self.refreshTime = refreshTime;
                [self resetTimer];
            }
            
            NSArray *list = root[@"list"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:list.count];
            
            for (int i = 0; i < list.count; i++) {
                [array addObject:[[HLADBannerModel alloc] initWithDic:list[i]]];
            }
            self.dataArray = array;
            self.row = 0;
            
            if (self.currentModel.ctrl_recommend_banner_image.length > 0) {
                
                [self lazyCreateUI];
                [self refreshUI];
                if (self.delegate && [self.delegate respondsToSelector:@selector(adViewDidReceiveAd:)]) {
                    [self.delegate adViewDidReceiveAd:self];
                }
                if (self.superview != nil && !self.hidden) {
                    [self eventRequest:@"展示"];
                }
            }
            HLADLOG(@"banner success = %@", responseObject);
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(adView: didFailToReceiveAdWithError:)]) {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:@{@"status" : status}];
                [self.delegate adView:self didFailToReceiveAdWithError:error];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HLADLOG(@"banner error = %@", error);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(adView: didFailToReceiveAdWithError:)]) {
            [self.delegate adView:self didFailToReceiveAdWithError:error];
        }
    }];
    HLADLOG(@"url = %@", [task.originalRequest URL]);
}

- (void)loadRequest:(HLADRequest *)request{

    self.request = request;
    if ([HLADCommon adBannerUrl]) {
        [self requestAd];
    } else {
    
        [HLADCommon requestApiSuccess:^(NSString *adBannerUrl, NSString *adInterstitialUrl, NSString *adFixedInterstitialUrl) {
            [self requestAd];
        } failure:^(NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(adViewDidReceiveAd:)]) {
                [self.delegate adViewDidReceiveAd:self];
            }
        }];
    }
}

- (void)onClick{
    
    HLADLOG(@"url = %@", self.currentModel.ctrl_recommend_url);
    
    
    
    
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.currentModel.ctrl_recommend_url]]) {
        
        [self eventRequest:@"点击"];
        if (_delegate && [_delegate respondsToSelector:@selector(adViewWillLeaveApplication:)]) {
            [_delegate adViewWillLeaveApplication:self];
        }
    }
}

- (void)lazyCreateUI{

    if (!_bgImageView) {
        if (_adSize.flags == 1 || _adSize.flags == 2) {
            _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _bgImageView.image = HLADBundleImage(@"HLAD_bg");
            [self addSubview:_bgImageView];
        }
    }
    
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        if (self.adSize.flags == 1 || self.adSize.flags == 2) {
            size = HLADIsDevicePad() ? kHLADAdSizeLeaderboard.size : kHLADAdSizeBanner.size;
        }
        
        _button.frame = CGRectMake((self.frame.size.width - size.width)/2, 0, size.width, size.height);
        [_button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
}

- (void)refreshUI{

    self.imageRequest = [NSURL URLWithString:self.currentModel.ctrl_recommend_banner_image];
    [_button setBackgroundImageForState:UIControlStateNormal withURL:self.imageRequest];
    [_button setBackgroundImageForState:UIControlStateHighlighted withURL:self.imageRequest];
    [_button setBackgroundImageForState:UIControlStateSelected withURL:self.imageRequest];
}

- (void)refreshAd{
    
    if (self.request) {
        [self loadRequest:self.request];
    }
    
    
    
//    self.row++;
//    if (self.row >= self.dataArray.count) {
//        self.row = 0;
//    }
}

- (void)eventRequest:(NSString *)event{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TimeOut60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[HLADDeviceHelper deviceInfoDict]];
    [dict setObject:@"补余" forKey:@"position_code"];
    [dict setObject:HLAD_Banner forKey:@"ad_format"];
    [dict setObject:self.currentModel.list_id forKey:@"ad_list_id"];
    [dict setObject:self.currentModel.banner_id forKey:@"ad_id"];
    [dict setObject:self.currentModel.update_increase forKey:@"ad_version"];
    [dict setObject:event forKey:@"action"];
    [dict setObject:self.currentModel.event_id forKey:@"event_id"];
    [manager GET:AdEventUrl parameters:@{@"code":self.adUnitID,@"content":[NSString JSONStringFromObject:dict]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HLADLOG(@"event success = %@", responseObject);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HLADLOG(@"event error = %@", error);
    }];
}

- (void)commonInit{

    self.backgroundColor = [UIColor clearColor];
    self.imageDownloader = [[AFImageDownloader alloc] init];
    self.refreshTime = 30;
    [self resetTimer];
}

- (void)resetTimer{
    if (self.refreshTimer != nil) {
        [self.refreshTimer invalidate];
        self.refreshTimer = nil;
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:self.refreshTime target:self selector:@selector(refreshAd) userInfo:nil repeats:YES];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    self.adSize = kHLADAdSizeBanner;
    [self commonInit];
    
    return self;
}

- (instancetype)initWithAdSize:(HLADAdSize)adSize{
    CGRect frame;
    switch (adSize.flags) {
        case 0:
        {
            frame = CGRectMake(0, 0, adSize.size.width, adSize.size.height);
        }
            break;
        case 1:
        case 2:{
            frame = CGRectMake(0, 0, HLADScreenWidth(), HLADSmartBannerHeight());
        }
        default:
            break;
    }
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    self.adSize = adSize;
    [self commonInit];
    
    return self;
}

- (void)dealloc{
    [self.refreshTimer invalidate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
