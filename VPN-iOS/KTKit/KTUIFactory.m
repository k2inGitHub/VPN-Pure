//
//  KTUIFactory.m
//  TestDemo
//
//  Created by Yang Soong on 13-8-6.
//  Copyright (c) 2013年 K2. All rights reserved.
//

#import "KTUIFactory.h"
//#import "Reachability.h"

@implementation KTUIFactory

+ (UILabel *)customLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textFont:(NSString *)textFont textSize:(float)textSize textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:textColor];
    UIFont *font;
    if ([textFont isEqualToString:@"system"]) {
        font = [UIFont systemFontOfSize:textSize];
    } else if ([textFont isEqualToString:@"system_bold"]) {
        font = [UIFont boldSystemFontOfSize:textSize];
    } else {
        font = [UIFont fontWithName:textFont size:textSize];
    }
    label.font = font;
    
    label.textAlignment = textAlignment;
    return label;
}

+ (UIButton *)customButtonWithImage:(NSString *)imageFile frame:(CGRect)frame title:(NSString *)title titleFont:(NSString *)titleFont titleColor:(UIColor *)titleColor titleSize:(CGFloat)titleSize tag:(int)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIColor *color = [UIColor colorWithPatternImage:];
    [btn setBackgroundImage:[UIImage imageNamed:imageFile] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:titleFont size:titleSize];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
//  当frame的长宽为0时Button的大小采用图片的默认大小  
    CGRect rect;
    if (frame.size.width == 0 || frame.size.height == 0) {
        UIImage *image = [UIImage imageNamed:imageFile];
        rect = CGRectMake(frame.origin.x, frame.origin.y, image.size.width, image.size.height);
    }else {
        rect = frame;
    }
    btn.frame = rect;
    btn.tag = tag;
    return btn;
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(int)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    view.tag = tag;
    [view show];
}

+ (void)showTextFieldAlertViewWithTitle:(NSString *)title delegate:(id)delegate tag:(int)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:title message:nil delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    view.alertViewStyle = UIAlertViewStylePlainTextInput;
    view.tag = tag;
    [view show];
}

+ (NSString *)stringForTableViewDotLine
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ";
    } else {
        return @"-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ";
    }
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

+ (void)rotateView:(UIView *)view
{
    CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/2);
    [view setTransform:at];
    view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
}

+ (void)rotateView:(UIView *)view rotation:(float)rotation
{
    CGAffineTransform at = CGAffineTransformMakeRotation(rotation);
    [view setTransform:at];
    view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
}

+(bool)network
{
//    Reachability *reach = [Reachability reachabilityForInternetConnection];
//    //    Reachability2 *reach = [Reachability2 reachabilityForInternetConnection];
//    NetworkStatus netStatus = [reach currentReachabilityStatus];
//    if (netStatus == NotReachable) {
//        NSLog(@"No internet connection!");
//        return false;
//    }
    return true;
}

+ (void)loopPop:(UIView *)view{
    
    float duration = 1;
    float delay = 0;
    
    view.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateKeyframesWithDuration:duration/3 delay:delay options:0 animations:^{
        // End
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
            // End
            view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
                // End
                view.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                [self loopPop:view];
            }];
        }];
    }];
}


@end
