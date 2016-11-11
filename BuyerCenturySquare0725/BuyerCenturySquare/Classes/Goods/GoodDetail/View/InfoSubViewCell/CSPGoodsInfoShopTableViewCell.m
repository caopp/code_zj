//
//  CSPGoodsInfoShopTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoShopTableViewCell.h"

@implementation CSPGoodsInfoShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
   
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = _shopL.frame;
    rect.size.width = self.frame.size.width-80;
   
    _shopL.frame = rect;
    if (_msg.length ) {
        _centerY.constant = -9;
    }else{
        _centerY.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShopName:(NSMutableAttributedString *)shopName{
    _shopL.attributedText = shopName;
}

@end
