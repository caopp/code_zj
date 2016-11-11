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
- (void)setOrderDetailMessageDto:(OrderDetailMesssageDTO *)orderDetailMessageDto
{
    [super setOrderDetailMessageDto:orderDetailMessageDto];
    
    if (orderDetailMessageDto) {
        
    
    [self.goodsPhotoImage sd_setImageWithURL:[NSURL URLWithString:orderDetailMessageDto.picUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
    self.goodsNameLab.text = orderDetailMessageDto.goodsName;
        
//        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

        
        NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",orderDetailMessageDto.price.doubleValue];
//        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

        [priceString appendAttributedString:priceValueString];
        self.goodsPriceLab.attributedText = priceString;
        
        
        
//    self.goodsPriceLab.text = [NSString stringWithFormat:@"%.2f",orderDetailMessageDto.price.doubleValue];
    self.goodsNumbLab.text = [NSString stringWithFormat:@"x%ld",(long)orderDetailMessageDto.quantity.integerValue];
        self.sampleColorLab.text = orderDetailMessageDto.color;
        
    }
}
- (void)setGoodsItemDto:(OrderGoodsItem *)goodsItemDto
{
    [super setGoodsItemDto:goodsItemDto];
    
    if (goodsItemDto) {
        
        
        [self.goodsPhotoImage sd_setImageWithURL:[NSURL URLWithString:goodsItemDto.picUrl] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
        self.goodsNameLab.text = goodsItemDto.goodsName;
        self.sampleColorLab.text = goodsItemDto.color;
//        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

        
        NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",goodsItemDto.price];
//        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        [priceString appendAttributedString:priceValueString];

        self.goodsPriceLab.attributedText = priceString;

//        self.goodsPriceLab.text = [NSString stringWithFormat:@"%.2f",goodsItemDto.price];
        self.goodsNumbLab.text = [NSString stringWithFormat:@"x%ld",(long)goodsItemDto.quantity];
    }
}

- (void)setHideLine:(NSString *)hideLine
{
    if (hideLine.length>0) {
        self.lineView.hidden = YES;
        
    }
}
@end
