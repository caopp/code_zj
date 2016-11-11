//
//  OtherViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OtherViewCell.h"

@implementation OtherViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.leftInfoLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    //!分割线
    self.bottomFilterLabelHight.constant = 0.5;
    [self.bottomFilterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
