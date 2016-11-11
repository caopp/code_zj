//
//  CenterPostageShopMessageTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CenterPostageShopMessageTableViewCell.h"

@implementation CenterPostageShopMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHideLine:(NSString *)hideLine
{
    if (hideLine.length>0) {
        self.lineView.hidden = YES;
    }
}

- (void)setGoodsItemDto:(orderGoodsItemDTO *)goodsItemDto
{
    [super setGoodsItemDto:goodsItemDto];
    if (goodsItemDto) {
        self.goodsNameLab.text = goodsItemDto.goodsName;
        self.goodsPriceLab.text = [NSString stringWithFormat:@"￥%.2f",goodsItemDto.price.doubleValue];
        self.goodsNumbLab.text = [NSString stringWithFormat:@"x%ld",(long)goodsItemDto.quantity.integerValue];
        
        [self.goodsPhotoImage  sd_setImageWithURL:[NSURL URLWithString:goodsItemDto.picUrl] placeholderImage:nil];
    }
}

@end