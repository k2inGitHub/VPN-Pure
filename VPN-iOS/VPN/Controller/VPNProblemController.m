//
//  VPNProblemController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/28.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNProblemController.h"
#import "HLService.h"
#import "UIButton+AFNetworking.h"
#import "Masonry.h"
#import "VPNManager.h"

@interface VPNProblemController ()

@property (nonatomic, weak) IBOutlet UIButton *girlButton;

@end

@implementation VPNProblemController

- (void)updateViewConstraints{
    
    [self.girlButton mas_updateConstraints:^(MASConstraintMaker *make) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            make.bottom.offset(-90);
        } else {
            make.bottom.offset(-50);
        }
    }];
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.girlButton.hidden = [HLInterface sharedInstance].market_reviwed_status == 0;
    [self.girlButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[HLInterface sharedInstance].ctrl_btn_img_url_02] placeholderImage:[_girlButton backgroundImageForState:UIControlStateNormal]];
}

- (IBAction)onGirl:(id)sender{
    [[HLAdManager sharedInstance] showButtonInterstitial:@"按钮right"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
