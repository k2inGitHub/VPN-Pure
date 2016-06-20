//
//  VPNSelectServerController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/28.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNSelectServerController.h"
#import "VPNManager.h"
#import "VPNSelectServerCell.h"
#import "KTUIFactory.h"
#import "HLService.h"
#import "NSUserDefaults+KTAdditon.h"
#import "VPNAlertView.h"
#import "UIAlertView+Blocks.h"

@interface VPNSelectServerController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation VPNSelectServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *btn = [KTUIFactory customButtonWithImage:@"bt_return_arrow" frame:CGRectMake(0, 0, 68, 40) title:nil titleFont:nil titleColor:[UIColor blackColor] titleSize:18 tag:0];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
    
    self.dataArray = [VPNManager sharedManager].serverDataArray;
    
    [VPNManager showAd1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIdx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)modelType:(NSInteger)idx{
    
    NSDictionary *homeModel = _dataArray[idx];
    int type = [homeModel[@"type"]intValue];
    
    if ([HLInterface sharedInstance].market_reviwed_status == 0 && type == 1) {
        return 0;
    }
    return type;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger type = [self modelType:indexPath.row];
    if (type == 1) {
        BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"VPN_Rated" defaultValue:NO];
        if (!flag) {
            [[HLPopupManager sharedManager] showRate:^{
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"VPN_Rated"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (self.OnSelectComplete) {
                    _OnSelectComplete(indexPath.row);
                }
                [self back:nil];
                [self.tableView reloadData];
            } and:^{
                
            }];
            return nil;
        }
        
        
    } else if (type == 2) {
        if (![VPNManager sharedManager].isVip) {
            if ([HLInterface sharedInstance].market_reviwed_status == 0) {
                [UIAlertView showWithTitle:nil message:@"请激活VIP服务后使用" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                }];
            } else {
                [VPNAlertView showWithAlertType:VPNAlertVIP];
            }
            
            return nil;
        }
    }
    
    if (self.OnSelectComplete) {
        _OnSelectComplete(indexPath.row);
    }
    [self back:nil];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 44;
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return [_dataArray count];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"SelectServerCell"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert([cell isKindOfClass:[VPNSelectServerCell class]]);
    VPNSelectServerCell *homeCell = (VPNSelectServerCell *)cell;
    NSDictionary *homeModel = _dataArray[indexPath.row];
    
    NSString *title;
    NSInteger type = [self modelType:indexPath.row];
    UIColor *titleColor;
    if (type == 0) {
        title = [NSString stringWithFormat:@"免费-%@",homeModel[@"server"]];
        titleColor = [UIColor blackColor];
    } else if (type == 1) {
        BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"VPN_Rated" defaultValue:NO];
        title = [NSString stringWithFormat:@"免费-%@%@",homeModel[@"server"], flag ? @"" : @"(好评)"];
         titleColor = [UIColor blackColor];
    } else if (type == 2) {
        title = [NSString stringWithFormat:@"VIP-%@",homeModel[@"server"]];
         titleColor = [UIColor redColor];
    }
    homeCell.titleLabel.text = title;
    homeCell.titleLabel.textColor = titleColor;
    homeCell.iconView.image = [UIImage imageNamed:homeModel[@"flag"]];
    //    cell.detailLabel.text = homeModel.detail;
    NSString *ping = homeModel[@"ping"];
    homeCell.detailLabel.text = ping;
    UIColor *color;
    if ([ping isEqualToString:@"较慢"]) {
        color = [UIColor redColor];
    } else if ([ping isEqualToString:@"流畅"]){
        color = [UIColor orangeColor];
    } else {
        color = [UIColor greenColor];
    }
    homeCell.detailLabel.textColor = color;
    
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
