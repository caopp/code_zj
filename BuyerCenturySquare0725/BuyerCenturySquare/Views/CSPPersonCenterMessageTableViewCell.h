//
//  CSPPersonCenterMessageTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 15/12/7.
//  Copyright © 2015年 pactera. All rights reserved.
//  消息中心cell

#import <UIKit/UIKit.h>
#import "BadgeImageView.h"

@interface CSPPersonCenterMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BadgeImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
