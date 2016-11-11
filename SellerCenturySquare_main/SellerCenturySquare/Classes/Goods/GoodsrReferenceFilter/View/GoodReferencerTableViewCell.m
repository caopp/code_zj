//
//  GoodReferencerTableViewCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodReferencerTableViewCell.h"

@implementation GoodReferencerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picNumLabel.layer.cornerRadius = 8;
    self.picNumLabel.layer.masksToBounds = YES;
    self.picNumLabel.backgroundColor = [UIColor redColor];
    [self.picNumLabel setTextColor:[UIColor whiteColor]];
    self.picNumLabel.font = [UIFont systemFontOfSize:10];
    
    //商品名称
    [self.goodsNameLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    //状态
    [self.goodsStatusLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    //货号
    [self.goodsWillNoLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    //商品颜色
    [self.colorLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    //价格
    [self.priceLabel setTextColor:[UIColor colorWithHex:0xfd4f57 alpha:1]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
