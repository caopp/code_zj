//
//  MerchantLeftSlideCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MerchantLeftSlideCell.h"

@implementation MerchantLeftSlideCell

- (void)awakeFromNib {
    // Initialization code
    
    

    [self.leftFilterLabel setBackgroundColor:[UIColor colorWithHexValue:0x673ab7 alpha:1]];
    
    [self.rightFilterLabel setBackgroundColor:[UIColor colorWithHexValue:0x3d3d3d alpha:1]];
    
    [self.classNameLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1    ]];
    
    //!未选中的背景(是cell点击起来瞬间的颜色)
    self.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
