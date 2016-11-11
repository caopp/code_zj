//
//  CenterSampleShopMessageCellTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CenterSampleShopMessageCellTableViewCell.h"

@implementation CenterSampleShopMessageCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.sampleLab.layer.borderColor = [UIColor blackColor].CGColor;
    self.sampleLab.layer.borderWidth = 0.5f;
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
        self.goodsNameLab.text = [NSString stringWithFormat:@"%@",goodsItemDto.goodsName];
        
        self.goodsPriceLab.text = [NSString stringWithFormat:@"¥%.2f",goodsItemDto.price.doubleValue];
        
        self.goodsQuantityLab.text = [NSString stringWithFormat:@"x%ld",(long)goodsItemDto.quantity.integerValue];
        self.sampleColorLab.text = [NSString stringWithFormat:@"颜色：%@",goodsItemDto.color];
        [self.goodsPhotoImage  sd_setImageWithURL:[NSURL URLWithString:goodsItemDto.picUrl] placeholderImage:nil];
    }
}
@end
