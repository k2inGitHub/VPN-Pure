//
//  VPNSpinView.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNSpinView.h"
#import "KTMathUtil.h"
#import "Canvas.h"
#import "VPNManager.h"
#import "UIAlertView+Blocks.h"

@interface VPNSpinView ()

@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (nonatomic, weak) UIButton *lastClickBtn;
@property (nonatomic, strong) NSArray *btns;
@property (nonatomic, strong) CADisplayLink *display;
@property (weak, nonatomic) IBOutlet UIView *centerView;
// 按钮初始化时的角度
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, strong) NSArray* choices;

@property (nonatomic, strong) NSArray* multiples;

@property (nonatomic, weak) IBOutlet UIView *rewardView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, assign) NSUInteger spinCost;



@end

@implementation VPNSpinView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return  nil;
    }
    
    _choices = @[@0.2,@0.02,@0.2,@0.09,@0.15,@0.06, @0.2, @0.08];
    _multiples = @[@0,@5,@2,@3,@0,@4,@2,@3];
    
    _spinCost = [[VPNManager sharedManager].currencyDic[@"spinCost"] integerValue];
    
    
    return self;
}

- (void)awakeFromNib
{
    [self addBtns];
    self.angle = 0;
    [self hideRewardView];
//    [self start];
    
    _descriptionLabel.text = [NSString stringWithFormat:@"规则：每次消耗%d金币，指针转到几就获得对应倍数收益，转到“祝你好运”无奖励", (int)_spinCost];
}

//+ (instancetype)wheelView
//{
//    return [[[NSBundle mainBundle] loadNibNamed:@"LuckyWheel" owner:nil options:nil] lastObject];
//}



- (void)addBtns
{
//    UIImage *bgImg = [UIImage imageNamed:@"LuckyAstrology"];
//    UIImage *selImg = [UIImage imageNamed:@"LuckyAstrologyPressed"];
//    NSArray *images = @[@"0",@"5",@"2",@"3",@"0",@"4",@"2",@"3"];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:8];
    int count = 8;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnW = 65;
        CGFloat btnH = 134;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = self.centerView.center;
        CGFloat angle = i * (M_PI * 2 / count) ;
        btn.transform = CGAffineTransformMakeRotation(angle);
        [self.centerView addSubview:btn];
        
        // 计算裁剪的尺寸
//        CGFloat scale = [UIScreen mainScreen].scale;
//        CGFloat imgY = 0;
//        CGFloat imgW = (bgImg.size.width / 12) * scale;
//        CGFloat imgX = i * imgW;
//        CGFloat imgH = bgImg.size.height * scale;
//        CGRect imgRect = CGRectMake(imgX, imgY, imgW, imgH);
//        
//        // 裁剪图片
//        CGImageRef cgImg = CGImageCreateWithImageInRect(bgImg.CGImage, imgRect);
//        [btn setImage:[UIImage imageWithCGImage:cgImg] forState:UIControlStateNormal];
//        
//        CGImageRef selCgImg = CGImageCreateWithImageInRect(selImg.CGImage, imgRect);
//        [btn setImage:[UIImage imageWithCGImage:selCgImg] forState:UIControlStateSelected];
        
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:[_multiples[i] stringValue]] forState:UIControlStateNormal];
//        btn.contentEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 17);
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        btn.tag = i;
        if (i == 0) {
            [self btnClick:btn];
        }
        [arr addObject:btn];
    }
    _btns = arr;
}

- (void)btnClick:(UIButton *)sender
{
    self.lastClickBtn.selected = NO;
    sender.selected = YES;
    // 每次点击一个按钮，都减去一个按钮的角度值
    self.angle -= sender.tag * M_PI / 4;
    self.lastClickBtn = sender;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    [self bringSubviewToFront:self.centerBtn];
}

- (void)addDisplayLink
{
    [self.display invalidate];
    self.display = nil;
    self.userInteractionEnabled = YES;
    // 添加定时刷新
    if (self.display == nil) {
//        CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTransform)];
//        self.display = display;
//        [display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)changeTransform
{
    self.centerView.transform = CGAffineTransformRotate(self.centerView.transform, M_PI / 900);
    self.angle += M_PI / 900;
    // 转一圈以后，将角度重新置为0
    if (self.angle >= M_PI * 2) {
        self.angle = 0;
    }
}

- (void)start
{
    [self addDisplayLink];
}

- (void)stop
{
    [self.display invalidate];
    self.display = nil;
}


- (IBAction)startSelectNumber {
    
    if (![[VPNManager sharedManager] costCurrency:_spinCost]) {
        return;
    }
    
    int idx = [KTMathUtil randomChoice:_choices];
    
    self.angle -= idx * M_PI / 4;
    self.lastClickBtn = _btns[idx];
    
    
    [self stop];
    
    // 禁止交互
    self.userInteractionEnabled = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    // 计算核心动画旋转的角度
    animation.toValue = @(M_PI * 2 * 4 - self.lastClickBtn.tag * M_PI / 4);
    animation.duration = 2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    
    [self.centerView.layer addAnimation:animation forKey:@"animation"];
    
//    
//    CGRect frame = self.centerView.frame;
//    frame.origin = CGPointZero;
//    self.centerView.frame = frame;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 将view旋转到顶部
    
    self.centerView.transform = CGAffineTransformMakeRotation( -( self.lastClickBtn.tag * M_PI / 4));
    self.angle = -self.lastClickBtn.tag * M_PI / 4;
    // 移除核心动画
    [self.centerView.layer removeAnimationForKey:@"animation"];
    // 1秒后添加转动
    [self performSelector:@selector(addDisplayLink) withObject:nil afterDelay:1];
    int multiple = [_multiples[_lastClickBtn.tag] intValue];
    NSUInteger toAdd = _spinCost * multiple;
    [[VPNManager sharedManager] addCurrency:toAdd];
    UILabel *lbl = [_rewardView viewWithTag:22];
    NSString *text = nil;
    if (multiple != 0) {
        text = [NSString stringWithFormat:@"获得%d倍回报", multiple];
    } else {
        text = @"祝你好运";
    }
    
    lbl.text = text;
    _rewardView.hidden = NO;
    [_rewardView startCanvasAnimation];
    [self performSelector:@selector(hideRewardView) withObject:nil afterDelay:2];
    if (multiple != 0) {
        [UIAlertView showWithTitle:nil message:[NSString stringWithFormat:@"恭喜你，获得%d金币", (int)toAdd] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            [VPNManager showAd2];
        }];
    } else {
        [VPNManager showAd1];
    }
}

- (void)hideRewardView{
    _rewardView.hidden = YES;
}

@end
