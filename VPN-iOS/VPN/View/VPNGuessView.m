//
//  VPNGuessView.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/25.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNGuessView.h"
#import "KTMathUtil.h"
#import "Canvas.h"
#import "VPNManager.h"
#import "UIAlertView+Blocks.h"

@interface VPNGuessView ()

@property (weak, nonatomic) IBOutlet UIButton *playerGuessView;

@property (weak, nonatomic) IBOutlet UIButton *pcGuessView;

@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, assign) VPNGuess guess;

@property (nonatomic, strong) NSArray *guessNames;

@property (nonatomic, strong) NSArray *guessBtns;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSUInteger guessCost;

@property (nonatomic, assign) NSUInteger guessMultiple;

@end

@implementation VPNGuessView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    _guessNames = @[@"scissors", @"cloth", @"stone"];
    
    _guessCost = [[VPNManager sharedManager].currencyDic[@"guessCost"] integerValue];

    _guessMultiple = [[VPNManager sharedManager].currencyDic[@"guessMultiple"] integerValue];
    
    return self;
}

- (void)awakeFromNib {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 3; i++) {
        UIView *view =[self viewWithTag:(10 + i)];
        if (view) {
            [array addObject:view];
        }
    }
    _guessBtns = array;
    
    [self restart];
    
    _descriptionLabel.text = [NSString stringWithFormat:@"规则：每次消耗%d金币，赢了翻%d倍，平局不扣钱", (int)_guessCost, (int)_guessMultiple];
}

- (void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changePCGuess) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)changePCGuess{
    
    NSString *name = [NSString stringWithFormat:@"bt_%@_big", [_guessNames objectAtIndex:[KTMathUtil randomIntRange:0 and:(int)_guessNames.count]]];
    [_pcGuessView setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
//    name = [NSString stringWithFormat:@"bt_%@_big", [_guessNames objectAtIndex:[KTMathUtil randomIntRange:0 and:(int)_guessNames.count]]];
//    [_playerGuessView setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

- (void)restart {
    self.userInteractionEnabled = YES;
    [self startTimer];
    
    for (int i = 0; i < _guessBtns.count; i++) {
        UIButton *btn = _guessBtns[i];
        btn.selected = NO;
    }
    
    _resultView.hidden = YES;
    
}

- (int)calculateResult:(VPNGuess)playerGuess and:(VPNGuess)pcGuess{
    if (playerGuess == pcGuess) {
        return 0;
    }
    if ((playerGuess == VPNGuessC && pcGuess == VPNGuessA) || (playerGuess == VPNGuessA && pcGuess == VPNGuessC)) {
        
       return (pcGuess - playerGuess) > 0 ? 1 : -1;
    }
    
    return (pcGuess - playerGuess) > 0 ? -1 : 1;
}

- (void)showResult {
    [self stopTimer];
    VPNGuess pcGuess = (VPNGuess)[KTMathUtil randomIntRange:0 and:(int)_guessNames.count];
    NSString *name = [NSString stringWithFormat:@"bt_%@_big", [_guessNames objectAtIndex:pcGuess]];
    [_pcGuessView setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    int ret =[self calculateResult:pcGuess and:_guess];
    NSString *retStr = ret == 0 ? @"平了" : (ret == 1 ? @"赢了" : @"输了");
    NSUInteger rewardCurrency = ret == 0 ? _guessCost : (ret == 1 ? _guessCost * _guessMultiple : 0);
    [[VPNManager sharedManager] addCurrency:rewardCurrency];
//    NSLog(@"%@", );
    
    UILabel *lbl = (UILabel *)[_resultView viewWithTag:22];
    lbl.text = retStr;
    _resultView.hidden = NO;
    [_resultView startCanvasAnimation];
    
    [self performSelector:@selector(restart) withObject:nil afterDelay:1];
    
    if (ret != -1) {
        [UIAlertView showWithTitle:nil message:[NSString stringWithFormat:@"恭喜你，获得%d金币", (int)rewardCurrency] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            [VPNManager showAd2];
        }];
    } else {
        [VPNManager showAd1];
    }
    
}

- (IBAction)onPlayerClick:(UIButton *)sender {

    if (![[VPNManager sharedManager] costCurrency:_guessCost]) {
        return;
    }
    
    for (UIButton* btn in _guessBtns) {
        if (sender == btn) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    self.userInteractionEnabled = NO;
    _guess = (VPNGuess)[_guessBtns indexOfObject:sender];
    NSString *name = [NSString stringWithFormat:@"bt_%@_big", [_guessNames objectAtIndex:_guess]];
    [_playerGuessView setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    [self showResult];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
