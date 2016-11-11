//
//  ReturnTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ReturnTableViewCell.h"

@implementation ReturnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.detailLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self.filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xc8c7cc alpha:1]];
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
