//
//  VPNSelectServerController.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/28.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VPNSelectServerCompletionBlock) (NSInteger selectIdx);

@interface VPNSelectServerController : UITableViewController

@property (nonatomic, copy, nullable) VPNSelectServerCompletionBlock OnSelectComplete;

@property (nonatomic, assign) NSInteger currentIdx;

@end
