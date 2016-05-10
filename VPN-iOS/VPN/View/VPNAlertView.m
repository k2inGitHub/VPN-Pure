//
//  VPNAlertController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/23.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNAlertView.h"
#import "VPNManager.h"
#import "KTUIFactory.h"
#import "HLService.h"
#import "AppDelegate.h"
#import "Canvas.h"
#import "NSUserDefaults+KTAdditon.h"

static NSMutableArray *_alertViews = nil;

@interface VPNAlertView ()

@property (nonatomic, weak) IBOutlet UILabel *unlockMsgLabel;

@property (nonatomic, weak) IBOutlet UILabel *vipMsgLabel;

@property (nonatomic, weak) IBOutlet UILabel *vipCommitButton;

@property (nonatomic, weak) IBOutlet UILabel *vipTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *tipMsgLabel;

@property (nonatomic, assign) int vipCount;

@property (nonatomic, assign) int vipCurrentCount;

@property (nonatomic, strong) NSArray *popViews;

@property (nonatomic, assign) BOOL adShow;

@property (nonatomic, strong) NSDate *lastDate;


- (void)onCancel:(id)sender;

@end

@implementation VPNAlertView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)hideAllAlertViews{
    for (VPNAlertView *alertView in _alertViews) {
        if ([alertView superview] != nil) {
            [alertView onCancel:nil];
        }
    }
}

+ (instancetype)showWithAlertType:(VPNAlertType)alertType
{
    return [VPNAlertView showWithAlertType:alertType andModel:nil];
}

+ (instancetype)showWithAlertType:(VPNAlertType)alertType andModel:(VPNHomeModel *)m {
  
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *names = @[@"VPNAlertVIP", @"VPNAlertUnlock", @"VPNAlertTip", @"VPNAlertVIP"];
    
    VPNAlertView *view = [[[NSBundle mainBundle] loadNibNamed:names[(int)alertType] owner:nil options:nil] lastObject];
    
    UIView *showView = app.window.rootViewController.view;
    view.frame = CGRectMake(0.0, 0.0, showView.frame.size.width, showView.frame.size.height);
    view.alertType = alertType;
    view.unlockModel = m;
    
    [view refresh];
 
    [showView addSubview:view];
    
    int tag = alertType== VPNAlertVPN ? (10 + VPNAlertVIP) : (10 + alertType);
    UIView  *animView = [view viewWithTag:tag];
    
    animView.transform = CGAffineTransformMakeScale(1, 1);
    float duration = 0.4;
    float delay = 0;
    [UIView animateKeyframesWithDuration:duration/2 delay:delay options:0 animations:^{
        // End
        animView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/2 delay:0 options:0 animations:^{
            // End
            animView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];

    }];
    
    if (_alertViews == nil) {
        _alertViews = [[NSMutableArray alloc] init];
    }
    [_alertViews addObject:view];
    
    return view;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    _lastDate = [NSDate distantFuture];
    _adShow = NO;
    
    
    return self;
}

- (void)onInterstitialFailure:(HLAdType *)adType{
}

- (void)onInterstitialPresent:(HLAdType *)adType{
    _adShow = NO;
}

- (void)onInterstitialFinish:(HLAdType *)adType {
    _adShow = YES;
    
}


- (void)didBecomeActive:(NSNotification*)notification {
    NSDate *now = [NSDate date];
    NSDate *compere = [NSDate dateWithTimeInterval:30 sinceDate:_lastDate];
    if (_adShow && [now compare:compere] > 0) {
        [self addVipCount];
    } else {
         _adShow = NO;
    }
}

- (void)willResignActive:(NSNotification*)notification {
    if (_adShow) {
        _lastDate = [NSDate date];
    }
}

- (void)onApplicationPause:(NSDictionary *)info {
    BOOL pause = [info[@"pause"] boolValue];
    NSLog(@"pause");
    
    if (!pause) {
        if (_adShow) {
            
            
        } else {
            _adShow = NO;
        }
    }
    
}

- (IBAction)onCancel:(id)sender {
    [self removeFromSuperview];
    [_alertViews removeObject:self];
}

- (IBAction)commit:(id)sender{
    
    switch (_alertType) {
        case VPNAlertUnlock:
        {
            if ([[VPNManager sharedManager] costCurrency:_unlockModel.reqCurrency]) {
                
                [_unlockModel setIsUnlock:YES];
                NSString *msg = [NSString stringWithFormat:@"激活成功 扣除%d金币", _unlockModel.reqCurrency];
                [KTUIFactory showAlertViewWithTitle:nil message:msg delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                if (_delegate) {
                    [_delegate onUnlockFinish:_unlockModel];
                }
            } else {
                return;
            }
            
            [self onCancel:nil];
        }
            break;
        case VPNAlertVPN:{
            if (_vipCurrentCount >= _vipCount) {
                [[VPNManager sharedManager] setVPNEnable:YES];
            } else {
                [[HLAdManager sharedInstance] showEncourageInterstitial];
                return;
            }
            [self onCancel:nil];
        }break;
        case VPNAlertVIP:{
            if (_vipCurrentCount >= _vipCount) {
                [[VPNManager sharedManager] setisVip:YES];
            } else {
#if 1
                [[HLAdManager sharedInstance] showEncourageInterstitial];
#else
                [self addVipCount];
#endif
                return;
            }
            [self onCancel:nil];
        }break;
        case VPNAlertTip:{
        
            [self onCancel:nil];
            [VPNAlertView showWithAlertType:VPNAlertVPN];
            
        }break;
        default:
            break;
    }
    
    
    
}

- (void)addVipCount{
    _vipCurrentCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:_vipCurrentCount forKey:_alertType == VPNAlertVIP ? @"vipCurrentCount" : @"vpnCurrentCount"];
    [self updateCommitDetail];
    if (_vipCurrentCount >= _vipCount) {
        
        if (_alertType == VPNAlertVIP) {
            [[VPNManager sharedManager] setisVip:YES];
            if (_delegate) {
                [_delegate onVipFinish];
            }
            
            [self onCancel:nil];
            [KTUIFactory showAlertViewWithTitle:nil message:@"恭喜你，获得VIP特权" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        } else {
            [[VPNManager sharedManager] setVPNEnable:YES];
            
            [self onCancel:nil];
            [KTUIFactory showAlertViewWithTitle:nil message:@"恭喜你，成功配置VPN" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)refresh {
    
    
    if (_alertType == VPNAlertUnlock) {
        _unlockMsgLabel.text = [NSString stringWithFormat:@"是否花费%d金币开启该服务", _unlockModel.reqCurrency];
    } else if (_alertType == VPNAlertVIP || _alertType == VPNAlertVPN) {
        
        _vipTitleLabel.text = _alertType == VPNAlertVIP ? @"VIP服务" : @"VPN服务";
        
        _vipCurrentCount = [[NSUserDefaults standardUserDefaults]integerForKey:_alertType == VPNAlertVIP ? @"vipCurrentCount" : @"vpnCurrentCount" defaultValue:0];
        _vipCount = [[VPNManager sharedManager].alertDic[_alertType == VPNAlertVIP ? @"vipCount" : @"vpnCount"] intValue];
        
        _vipMsgLabel.text = [VPNManager sharedManager].alertDic[_alertType == VPNAlertVIP ? @"vipMsg" : @"vpnMsg"];
        [self updateCommitDetail];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialFinish:) name:HLInterstitialFinishNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialPresent:) name:HLInterstitialPresentNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialFailure:) name:HLInterstitialFailureNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
    } else if (_alertType == VPNAlertTip) {
        
        _tipMsgLabel.text = [VPNManager sharedManager].alertDic[@"tipMsg"];
    }
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:VPNAlertCount];
//    UIView *targetView = nil;
//    for (int i = 0; i < VPNAlertCount; i++) {
//        UIView *view = [self.view viewWithTag:10+i];
//        if (view) {
//            view.hidden = !(i == (int)_alertType);
//            
//            if (i == (int)_alertType) {
//                targetView = view;
//            }
//            
//            [arr addObject:view];
//        }
//    }
//    
//    
//    
//}

- (void)updateCommitDetail{
    NSString *title = [NSString stringWithFormat:@"已完成%d/%d个",_vipCurrentCount, _vipCount];
    
    _vipCommitButton.text = title;
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
