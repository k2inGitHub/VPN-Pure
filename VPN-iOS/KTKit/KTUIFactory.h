//
//  KTUIFactory.h
//  TestDemo
//
//  Created by Yang Soong on 13-8-6.
//  Copyright (c) 2013年 K2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static inline CGPoint
CGPointMult(const CGPoint v, const float s)
{
    return CGPointMake(v.x * s, v.y * s);
}

static inline CGPoint
CGPointAdd(const CGPoint v, const CGPoint s)
{
    return CGPointMake(v.x + s.x, v.y + s.y);
}


@interface KTUIFactory : NSObject

//  自定义Button 
//  当frame的长宽都为0时Button的大小采用图片的默认大小
+ (UIButton *)customButtonWithImage:(NSString *)imageFile frame:(CGRect)frame title:(NSString *)title titleFont:(NSString *)titleFont titleColor:(UIColor *)titleColor titleSize:(CGFloat)titleSize tag:(int)tag;

//  自定义Label
//  方便显示文字
+ (UILabel *)customLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textFont:(NSString *)textFont textSize:(float)textSize textAlignment:(NSTextAlignment)textAlignment;

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(int)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION ;

+ (void)showTextFieldAlertViewWithTitle:(NSString *)title delegate:(id)delegate tag:(int)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (NSString *)stringForTableViewDotLine;


+ (NSString*)getPreferredLanguage;

///顺时针旋转view90度
+ (void)rotateView:(UIView *)view;

+ (void)rotateView:(UIView *)view rotation:(float)rotation;


+ (bool)network;


+ (void)loopPop:(UIView *)view;



@end
