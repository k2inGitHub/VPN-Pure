//
//  UINavigationController+KeyboardDismiss.m
//  colorful
//
//  Created by SongYang on 14-2-26.
//
//

#import "UINavigationController+KeyboardDismiss.h"

@implementation UINavigationController (KeyboardDismiss)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    if (COMP_LANDSCAPE) {
//        return UIInterfaceOrientationIsLandscape( interfaceOrientation );
//    } else {
        return UIInterfaceOrientationIsPortrait( interfaceOrientation );
//    }
}

- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
//    if (COMP_LANDSCAPE) {
//        return UIInterfaceOrientationMaskLandscape;
//    } else {
        return UIInterfaceOrientationMaskPortrait;
//    }
#endif
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
