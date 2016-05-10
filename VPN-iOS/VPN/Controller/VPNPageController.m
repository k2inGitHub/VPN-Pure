//
//  VPNPageController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/27.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNPageController.h"
#import "KTUIFactory.h"
#import "VPNManager.h"
#import "HLService.h"
#import "NSUserDefaults+KTAdditon.h"
#import "VPNAlertView.h"
#import "UIColor+VPNAddition.h"
//@import NetworkExtension;

@interface VPNPageController ()

@property (nonatomic, weak) UILabel *vpnLabel;

@property (nonatomic, weak) UILabel *currencyLabel;

@end

@implementation VPNPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [VPNManager sharedManager].pageContrller = self;
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor vpnBlue];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
//
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    
//    negativeSpacer.width = -11; // it was -6 in iOS 6
//    
//    UILabel *lbl =[KTUIFactory customLabelWithFrame:CGRectMake(0, 0, 70, 40) text:@"VPN 未配置" textColor:[UIColor whiteColor] textFont:nil textSize:13 textAlignment:NSTextAlignmentLeft];
//    CGSize size = [lbl.text sizeWithAttributes:@{NSFontAttributeName : lbl.font}];
//    lbl.frame = CGRectMake(0, 0, size.width, 40);
//    
//    UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithCustomView:lbl];
//    self.navigationItem.leftBarButtonItems = @[negativeSpacer,bbiLeft];
//    _vpnLabel = lbl;
//    
//    lbl = [KTUIFactory customLabelWithFrame:CGRectMake(0, 0, 54, 40) text:@"$10000" textColor:[UIColor whiteColor] textFont:nil textSize:13 textAlignment:NSTextAlignmentRight];
//    UIBarButtonItem *bbiRight = [[UIBarButtonItem alloc] initWithCustomView:lbl];
//    
//    negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    
//    negativeSpacer.width = -11;
//    
//    
//    UIBarButtonItem *bbiCurrency = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vpn_Gold_icon"]]];
//    
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer,bbiRight, bbiCurrency];
//    _currencyLabel = lbl;
//    
//    
//    [self updateCurrency];
//    [self updateStatus];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:VPNStatusDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNCurrencyDidChangeNotification) name:VPNCurrencyDidChangeNotification object:nil];
    
    if ([HLInterface sharedInstance].market_reviwed_status == 1) {
        //弹窗逻辑
        BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"VPN_First" defaultValue:YES];
        if (isFirst) {
            [[HLPopupManager sharedManager] showRate:^{
                
                
                [VPNAlertView showWithAlertType:VPNAlertVIP];
                [self performSelector:@selector(showAd) withObject:nil afterDelay:1];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"VPN_First"];
            } and:^{
                
                [VPNAlertView showWithAlertType:VPNAlertVIP];
                
                [self performSelector:@selector(showAd) withObject:nil afterDelay:1];
            }];
            
            
        }
        [[HLPopupManager sharedManager] showUpdate:^{
            
        } and:^{
            
        }];
        [VPNManager showLaunchAd];
    }
    
    
    self.selectIndex = 1;
}

- (void)showAd{
    [[HLAdManager sharedInstance] showUnsafeInterstitial];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self reloadData];
//}

- (NSArray *)titles {
    return @[@"VIP服务", @"VPN配置", @"常见问题"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.menuItemWidth = 70;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 16;
        self.titleSizeNormal = 16;
        self.showOnNavigationBar = YES;
        self.menuBGColor = [UIColor clearColor];
        self.titleColorNormal = self.titleColorSelected = [UIColor whiteColor];//[UIColor colorWithRed:255.f/255.f green:252.f/255.f blue:0.f/255.f alpha:1];
        
        self.progressColor = [UIColor whiteColor];//[UIColor colorWithRed:250.f/255.f green:179.f/255.f blue:0/255.f alpha:1];
//        self.itemsWidths = @[@46,@46,@58];
//        self.menuHeight = 40.0;
//        self.menuViewStyle = WMMenuViewStyleLine;
//        self.menuItemWidth = 60;
        self.selectIndex = 1;
    }
    return self;
}

- (void) VPNCurrencyDidChangeNotification{
    [self updateCurrency];
}


- (void)updateCurrency {

    _currencyLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[VPNManager sharedManager].currency];
    
    CGSize size = [_currencyLabel.text sizeWithAttributes:@{NSFontAttributeName : _currencyLabel.font}];
    
    _currencyLabel.frame = CGRectMake(0, 0, MIN(size.width, 54), 40);
}

- (void)updateStatus{
    switch ([VPNManager sharedManager].status)
    {
        case VPNStatusInvalid:
        {
            NSLog(@"NEVPNStatusInvalid");
            _vpnLabel.text = @"VPN 未配置";
            break;
        }
        case VPNStatusDisconnected:
        {
            _vpnLabel.text = @"VPN 未连接";
            NSLog(@"NEVPNStatusDisconnected");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        
        case VPNStatusConnected:
        {
            _vpnLabel.text = @"VPN 已连接";
            NSLog(@"NEVPNStatusConnected");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        default:
            break;
    }
}

#pragma mark - VPN状态切换通知
- (void)VPNStatusDidChangeNotification
{
    [self updateStatus];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VPNStatusDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VPNCurrencyDidChangeNotification object:nil];
}

#pragma mark - WMPageController DataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    UIStoryboard *sb = [VPNManager sharedManager].storyboard;
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:self.titles[index]];
    return vc;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
