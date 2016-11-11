//
//  GoodsAboutTableViewCell.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsAboutTableViewCell.h"

@implementation GoodsAboutTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)refigDTO:(GoodsShareDTO *)dto{
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:dto.imgUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
    _goodsNameLabel.text = dto.goodsName;
    _goodsWillNoLabel.text  = [NSString stringWithFormat:@"货号：%@",dto.goodsWillNo];
    _goodsColorlabel.text = [NSString stringWithFormat:@"颜色：%@",dto.color];;
    NSString *strP = [NSString stringWithFormat:@"零售价：￥%@",dto.retailPrice];
   NSString * strDeduct =[dto.commPercent doubleValue]==0? @"提成：无":[NSString stringWithFormat:@"提成：%.2f%@",[dto.commPercent floatValue]*100,@"%"];
    
    _goodsPriceLabel.attributedText = [self createStringWithString:strP withRange:NSMakeRange(4, [strP length]-4)];
    _deductLabel.attributedText = [self createStringWithString:strDeduct withRange:NSMakeRange(3, [strDeduct length]-3)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
