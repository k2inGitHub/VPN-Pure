//
//  HLDummyBanner.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/31.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "HLDummyBanner.h"
#import "KTUIFactory.h"

@interface HLDummyBanner ()

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) int idx;

@property (nonatomic, strong) NSTimer *nsTimer;

@end

@implementation HLDummyBanner

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.images = @[[UIImage imageNamed:@"banner1"], [UIImage imageNamed:@"banner2"]];
    UIButton *button = [KTUIFactory customButtonWithImage:@"banner1" frame:CGRectMake(0, 0, 320, 50) title:nil titleFont:nil titleColor:nil titleSize:0 tag:0];
    button.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    [button addTarget:self action:@selector(OnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(update) userInfo:nil repeats:YES];
    return self;
}

- (void)update{

    if ((++_idx) >= [_images count]) {
        _idx = 0;
    }
    [_button setBackgroundImage:_images[_idx] forState:UIControlStateNormal];
}

- (void)OnClick{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://203.195.128.244/q3/index.html"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
