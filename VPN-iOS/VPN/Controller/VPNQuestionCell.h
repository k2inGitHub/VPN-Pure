//
//  VPNQuestionCell.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/29.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPNQuestionCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segment;

@end
