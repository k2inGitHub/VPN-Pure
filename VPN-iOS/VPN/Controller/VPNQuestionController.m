//
//  VPNQuestionController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/29.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNQuestionController.h"
#import "VPNQuestionCell.h"
#import "VPNQuestionFooterCell.h"
#import "KTUIFactory.h"
#import "VPNManager.h"
#import "UIAlertView+Blocks.h"

@interface VPNQuestionController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) UIButton *ok;

@end

@implementation VPNQuestionController

- (IBAction)onOKClick:(UIButton *)sender{
    
    [[VPNManager sharedManager] setisVip:YES];
    [self back:nil];
    [UIAlertView showWithTitle:nil message:@"感谢您的参与  VIP服务激活" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
}

- (IBAction)onValueChange:(UISwitch *)sender{
    
    
    self.ok.hidden = !sender.on;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [KTUIFactory customButtonWithImage:@"bt_return_arrow" frame:CGRectMake(0, 0, 68, 40) title:nil titleFont:nil titleColor:[UIColor blackColor] titleSize:18 tag:0];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = back;
    
    self.dataArray = @[@{@"question":@"1.您的职业是？",@"answer":@[@"A.程序员",@"B.学生",@"C.白领",@" D.其他"]},
                       @{@"question":@"2.您之前使用过VPN吗？",@"answer":@[@"A.使用过",@"B.未用过",@"C.想使用"]},
                       @{@"question":@"3.您经常使用VPN吗?",@"answer":@[@"A.每天都用",@"B.每周会用",@"C.每月会用",@"D.从来不用"]},
                       @{@"question":@"4.您使用VPN经常访问的资源是？",@"answer":@[@"A.浏览网页",@"B.社交网站",@"C.视频网站",@"D.其他"]},
                       @{@"question":@"5.您会使用付费的VIP吗？",@"answer":@[@"A.会",@" B.不会",@"C.看情况"]},
                       @{@"question":@"6.您周围用VNP的朋友多吗？",@"answer":@[@"A.很多 ",@"B.很少",@"C.就我自己"]}];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ok.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"VPNQuestionCell"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert([cell isKindOfClass:[VPNQuestionCell class]]);
    VPNQuestionCell *homeCell = (VPNQuestionCell *)cell;
    NSDictionary *homeModel = _dataArray[indexPath.row];
    homeCell.titleLabel.text = homeModel[@"question"];
    NSArray *answers = homeModel[@"answer"];
    for (int i = 0; i < answers.count; i++) {
        if (homeCell.segment.numberOfSegments < i+1) {
            [homeCell.segment insertSegmentWithTitle:answers[i] atIndex:i animated:NO];
        } else {
            [homeCell.segment setTitle:answers[i] forSegmentAtIndex:i];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    VPNQuestionFooterCell *view =  [tableView dequeueReusableCellWithIdentifier:@"VPNQuestionFooterCell"];
    self.ok = view.ok;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150;
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
