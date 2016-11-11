//
//  WriteExpressNoViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WriteExpressNoViewCell.h"

@implementation WriteExpressNoViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [self.contentView setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
    
    
    self.expressNoTextFiled.layer.borderColor = [[UIColor colorWithHex:0xe2e2e2 alpha:1] CGColor];
    self.expressNoTextFiled.layer.borderWidth = 1.0f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
