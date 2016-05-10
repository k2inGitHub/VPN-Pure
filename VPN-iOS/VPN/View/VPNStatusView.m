//
//  VPNStatusView.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNStatusView.h"
#import "VPNManager.h"
#import "HLService.h"
//@import NetworkExtension;

@implementation VPNStatusView

//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (!self) {
//        return nil;
//    }
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:NEVPNStatusDidChangeNotification object:nil];
//    
//    return self;
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNCurrencyDidChangeNotification) name:VPNCurrencyDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:NEVPNStatusDidChangeNotification object:nil];
    
    return self;
}

- (void)awakeFromNib {
    
    [self updateCurrency];
    [self updateStatus];
}

- (void) VPNCurrencyDidChangeNotification{
    [self updateCurrency];
}


- (void)updateCurrency {
    
    _currencyLabel.hidden = [HLInterface sharedInstance].market_reviwed_status == 0;
    _currencyLabel.text = [NSString stringWithFormat:@"金币:%lu", (unsigned long)[VPNManager sharedManager].currency];
}

- (void)updateStatus{
//    switch ([NEVPNManager sharedManager].connection.status)
//    {
//        case NEVPNStatusInvalid:
//        {
//            NSLog(@"NEVPNStatusInvalid");
//            _vpnLabel.text = @"未配置";
//            break;
//        }
//        case NEVPNStatusDisconnected:
//        {
//            _vpnLabel.text = @"未连接";
//            NSLog(@"NEVPNStatusDisconnected");
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            break;
//        }
//        case NEVPNStatusConnecting:
//        {
//            _vpnLabel.text = @"连接中...";
//            NSLog(@"NEVPNStatusConnecting");
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//            break;
//        }
//        case NEVPNStatusConnected:
//        {
//            _vpnLabel.text = @"已连接";
//            NSLog(@"NEVPNStatusConnected");
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            break;
//        }
//        case NEVPNStatusReasserting:
//        {
//            NSLog(@"NEVPNStatusReasserting");
//            break;
//        }
//        case NEVPNStatusDisconnecting:
//        {
//            NSLog(@"NEVPNStatusDisconnecting");
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//            
//            break;
//        }
//        default:
//            break;
//    }
}

#pragma mark - VPN状态切换通知
- (void)VPNStatusDidChangeNotification
{
    [self updateStatus];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NEVPNStatusDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VPNCurrencyDidChangeNotification object:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
