//
//  VPNCurrencyController.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNCurrencyController.h"

@interface VPNCurrencyController ()

@property (nonatomic, weak) IBOutlet UIView *spinContainerView;

@property (nonatomic, weak) IBOutlet UIView *guessContainerView;

@property (nonatomic, weak) IBOutlet UIButton *spinBtn;

@property (nonatomic, weak) IBOutlet UIButton *guessBtn;

@end

@implementation VPNCurrencyController

- (IBAction)pageSelect:(UIButton *)sender{
    if (_spinBtn == sender) {
        _spinContainerView.hidden = NO;
        _spinBtn.selected = YES;
        _guessContainerView.hidden = YES;
        _guessBtn.selected = NO;
        
    } else {
        _spinContainerView.hidden = YES;
        _spinBtn.selected = NO;
        _guessContainerView.hidden = NO;
        _guessBtn.selected = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageSelect:_spinBtn];
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
