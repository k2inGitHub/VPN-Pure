//
//  UINavigationController+KeyboardDismiss.h
//  colorful
//
//  Created by SongYang on 14-2-26.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (KeyboardDismiss)

-(BOOL)disablesAutomaticKeyboardDismissal;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (NSUInteger) supportedInterfaceOrientations;

- (BOOL) shouldAutorotate;

@end
