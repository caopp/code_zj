//
//  GoodHeaderTableViewCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodHeaderTableViewCell.h"

@implementation GoodHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
  
    
    //分割线
//    [self.lineView setBackgroundColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    //零售价
    [self.retailPriceLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
    
    //名称
    [self.goodsNameLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
     //商品货号
    [self.goodsWillNoLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
    //货物颜色
    [self.colorLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
    //货物状态
    [self.goodsStatusLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
    //价格
    [self.priceLabel setTextColor:[UIColor colorWithHex:0xfd4f57 alpha:1]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
