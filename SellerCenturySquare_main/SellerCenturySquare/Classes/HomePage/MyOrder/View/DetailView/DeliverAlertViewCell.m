//
//  DeliverAlertViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "DeliverAlertViewCell.h"

@implementation DeliverAlertViewCell

- (void)awakeFromNib {
    // Initialization code

    [self.alertLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
