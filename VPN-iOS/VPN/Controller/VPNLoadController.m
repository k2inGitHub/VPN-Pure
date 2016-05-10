//
//  VPNLoadController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/23.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNLoadController.h"
#import "VPNManager.h"
#import "VPNAlertView.h"
#import "KTUIFactory.h"
#import "Masonry.h"
#import "HLService.h"
#import "VPNPageController.h"
//@import NetworkExtension;

@interface VPNLoadController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UILabel *detail;

@property (nonatomic, weak) IBOutlet UIView *loadingView;

@property (nonatomic, weak) IBOutlet UIView *infoView;

@property (nonatomic, weak) IBOutlet UIButton *vipButton;

@property (nonatomic, strong) CADisplayLink* display;

@property (nonatomic, assign) BOOL forward;

//@property (nonatomic, weak) UILabel *vpnLabel;

@property (nonatomic, weak) UILabel *currencyLabel;

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end

@implementation VPNLoadController

- (IBAction)showVIP:(id)sender{
    
    [VPNAlertView showWithAlertType:VPNAlertVIP];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (IBAction)refreshClick:(id)sender{

    [VPNManager showAd1];
    [self hideInfoView];
    [self performSelector:@selector(showInfoView) withObject:nil afterDelay:4];
}

- (IBAction)changeServer:(id)sender {

    [self.navigationController popViewControllerAnimated:NO];
    
    
    [VPNManager sharedManager].pageContrller.selectIndex = 1;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //nav
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSpacer.width = -11; // it was -6 in iOS 6
    
//    UILabel *lbl =[KTUIFactory customLabelWithFrame:CGRectMake(0, 0, 70, 40) text:@"VPN 未配置" textColor:[UIColor whiteColor] textFont:nil textSize:13 textAlignment:NSTextAlignmentLeft];
//    UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithCustomView:lbl];
    
    UIButton *btn = [KTUIFactory customButtonWithImage:@"bt_return_arrow" frame:CGRectMake(0, 0, 68, 40) title:nil titleFont:nil titleColor:[UIColor blackColor] titleSize:18 tag:0];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,back];
    
    UILabel * lbl = [KTUIFactory customLabelWithFrame:CGRectMake(0, 0, 54, 40) text:@"金币:1000000" textColor:[UIColor whiteColor] textFont:nil textSize:13 textAlignment:NSTextAlignmentRight];
    UIBarButtonItem *bbiRight = [[UIBarButtonItem alloc] initWithCustomView:lbl];
    
    negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSpacer.width = -11;
    
    UIBarButtonItem *bbiCurrency = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vpn_Gold_icon"]]];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,bbiRight, bbiCurrency];
    _currencyLabel = lbl;
    
    UIFont* titleFont = [UIFont boldSystemFontOfSize:18];
    CGSize requestedTitleSize = [_homeModel.title sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    lbl = [KTUIFactory customLabelWithFrame:CGRectMake(0, 0, requestedTitleSize.width, 44) text:[NSString stringWithFormat:@"%@\n%@", _homeModel.title, _homeModel.detail] textColor:[UIColor blackColor] textFont:@"system_bold" textSize:14 textAlignment:NSTextAlignmentCenter];
    lbl.numberOfLines = 2;
    
    NSDictionary *attribute1 = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                 NSBackgroundColorAttributeName: [UIColor clearColor],
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                 };
    
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                 NSBackgroundColorAttributeName: [UIColor clearColor],
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                                 };
    
    NSMutableAttributedString *info = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", _homeModel.title, _homeModel.detail]];
    
    [info setAttributes:attribute1 range:NSMakeRange(0, ([_homeModel.title length]))];
    [info setAttributes:attribute2 range:NSMakeRange(([_homeModel.title length]),([_homeModel.detail length]))];
    lbl.attributedText = info;
    
    self.navigationItem.titleView = lbl;
    
    _descriptionLabel.text = [VPNManager sharedManager].loadDescriptionText;
    _titleLabel.text = _homeModel.title;
    _detail.text = _homeModel.detail;
    
    _infoView.hidden = YES;
    [self performSelector:@selector(showInfoView) withObject:nil afterDelay:4];
    
    [self updateVIP];
    [self updateCurrency];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVIP) name:VPNVIPDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrency) name:VPNCurrencyDidChangeNotification object:nil];
    
    [self addDisplayLink];
}

- (void)addDisplayLink
{
    [self.display invalidate];
    self.display = nil;
    if (self.display == nil) {
        CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTransform)];
        self.display = display;
        [display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)changeTransform {
    
    _vipButton.transform = _forward ? CGAffineTransformScale(_vipButton.transform, 1.01,1.01) : CGAffineTransformScale(_vipButton.transform, 0.99,0.99);
    CGAffineTransform t = _vipButton.transform;
    float scale = sqrtf(t.a * t.a + t.c * t.c);
    if (scale >= 1.2) {
        _forward = NO;
        _vipButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } else if (scale <= 1) {
        _forward = YES;
        _vipButton.transform = CGAffineTransformMakeScale(1, 1);
    }
}

- (void)updateViewConstraints{

    [_vipButton mas_updateConstraints:^(MASConstraintMaker *make) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            make.bottom.offset(-90);
        } else {
            make.bottom.offset(-50);
        }
    }];
    
    [super updateViewConstraints];
}

- (void)showInfoView{
    _loadingView.hidden = YES;
    _infoView.hidden = NO;
}

- (void)hideInfoView{
     _loadingView.hidden = NO;
    _infoView.hidden = YES;
}

- (void)updateVIP {
    _vipButton.hidden = [[VPNManager sharedManager] isVip];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self rotate];
    [VPNManager showAd1];
}



- (void)rotate {
    [self runSpinAnimationOnView:_loadingView duration:10 rotations:1 repeat:1];
    [self performSelector:@selector(rotate) withObject:nil afterDelay:10];
}
     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) VPNCurrencyDidChangeNotification{
    [self updateCurrency];
}


- (void)updateCurrency {
    
    _currencyLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[VPNManager sharedManager].currency];
    
    CGSize size = [_currencyLabel.text sizeWithAttributes:@{NSFontAttributeName : _currencyLabel.font}];
    _currencyLabel.frame = CGRectMake(0, 0, MIN(size.width, 54), 40);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
