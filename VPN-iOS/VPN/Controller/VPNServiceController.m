//
//  VPNServiceController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/28.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNServiceController.h"
#import "Masonry.h"
#import "HLService.h"
#import "UIButton+AFNetworking.h"
#import "VPNManager.h"

@interface VPNServiceController ()

@property (nonatomic, weak) IBOutlet UIButton *girlButton;


@end

@implementation VPNServiceController

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
    self.girlButton.hidden = [HLInterface sharedInstance].market_reviwed_status == 0;
    
    [self.girlButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[HLInterface sharedInstance].ctrl_btn_img_url_01] placeholderImage:[_girlButton backgroundImageForState:UIControlStateNormal]];
}

- (IBAction)onGirl:(id)sender{
    [[HLAdManager sharedInstance] showButtonInterstitial:@"按钮left"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [VPNManager showAd1];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 88;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 44;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return [_dataArray count];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return @"非VIP用户";
//    } else {
//        return @"VIP用户";
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return [_dataArray[section] count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:@"ServiceCell"];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
////    NSParameterAssert([cell isKindOfClass:[VPNHomeCell class]]);
////    VPNHomeCell *homeCell = (VPNHomeCell *)cell;
////    VPNHomeModel *homeModel = _dataArray[indexPath.row];
//    cell.detailTextLabel.text = _dataArray[indexPath.section][indexPath.row];
//    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
////    cell.detailLabel.text = homeModel.detail;
//}

//- (void)updateViewConstraints{
//    
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            make.bottom.offset(-90);
//        } else {
//            make.bottom.offset(-50);
//        }
//    }];
//    
//    [super updateViewConstraints];
//}

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
