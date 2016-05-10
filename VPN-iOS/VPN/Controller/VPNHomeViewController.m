//
//  VPNHomeViewController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/22.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNHomeViewController.h"
#import "VPNManager.h"
#import "VPNHomeCell.h"
#import "VPNHomeModel.h"
#import "VPNLoadController.h"
#import "NSUserDefaults+KTAdditon.h"
#import "VPNAlertView.h"
#import "HLService.h"
#import "KTUIFactory.h"
#import "Masonry.h"

@interface VPNHomeViewController ()<UITableViewDataSource, UITableViewDelegate, VPNAlertContrllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) IBOutlet UIButton *vipButton;

@property (nonatomic, strong) CADisplayLink* display;

@property (nonatomic, assign) BOOL forward;


@end

@implementation VPNHomeViewController

- (IBAction)showVIP:(id)sender{
    
    [VPNAlertView showWithAlertType:VPNAlertVIP];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [VPNManager sharedManager].homeDataArray;
    
    
    [self updateVIP];
    [self addDisplayLink];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVIP) name:VPNVIPDidChangeNotification object:nil];
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

- (void)updateVIP {
    _vipButton.hidden = [[VPNManager sharedManager] isVip] || ([HLInterface sharedInstance].market_reviwed_status == 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
     NSParameterAssert([cell isKindOfClass:[VPNHomeCell class]]);
    VPNHomeCell *homeCell = (VPNHomeCell *)cell;
    VPNHomeModel *homeModel = _dataArray[indexPath.row];
    homeCell.titleLabel.text = homeModel.title;
    homeCell.detailLabel.text = homeModel.detail;
    homeCell.descriptionLabel.text = homeModel.descriptionText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    VPNLoadController *loadController = (VPNLoadController *)[segue destinationViewController];
    if (loadController) {
        loadController.homeModel = _dataArray[[_tableView indexPathForSelectedRow].row];
    }
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    BOOL flag = YES;
    if ([identifier isEqualToString:@"show"]) {
        
        
        
        int idx = (int)[_tableView indexPathForSelectedRow].row;
        VPNHomeModel* m = _dataArray[idx];
        
        if (m.url.length > 0) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:m.url]];
            
            flag = NO;
        } else {
            if (m.isVip) {
                
                if (![[VPNManager sharedManager] isVip]) {
                    VPNAlertView *alertView = [VPNAlertView showWithAlertType:VPNAlertVIP];
                    alertView.delegate = self;
                    flag = NO;
                }
                
            } else {
                
                if (![m isUnlock]) {
                    
                    VPNAlertView *alertView = [VPNAlertView showWithAlertType:VPNAlertUnlock andModel:m];
                    alertView.delegate = self;
                    
                    flag = NO;
                }
            }
        }
    }
    
    if (flag == NO) {
        [VPNManager showAd1];
    }
    
    return flag;
}

- (void)onUnlockFinish:(VPNHomeModel *)m {
    [self.tableView reloadData];
}

- (void)onVipFinish{
    [self.tableView reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VPNVIPDidChangeNotification object:nil];
}

@end
