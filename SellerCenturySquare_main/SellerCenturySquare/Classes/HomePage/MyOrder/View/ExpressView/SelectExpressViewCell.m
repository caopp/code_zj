//
//  SelectExpressViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SelectExpressViewCell.h"

@implementation SelectExpressViewCell

- (void)awakeFromNib {
    
    // Initialization code

    [self.filterLabel setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];

    self.expressNameLabel.text = @"";
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
