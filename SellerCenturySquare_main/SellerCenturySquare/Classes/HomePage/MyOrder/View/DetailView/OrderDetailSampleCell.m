//
//  OrderDetailSampleCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/5/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderDetailSampleCell.h"

@implementation OrderDetailSampleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.sampleLabel.layer.borderColor = [UIColor colorWithHex:0x000000].CGColor;
    self.sampleLabel.layer.borderWidth = 0.5;
    self.sampleLabel.layer.masksToBounds = YES;
    self.sampleLabel.layer.cornerRadius = 2;
    
    //!分割线
    [self.filterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configData:(orderGoodsItemDTO * )orderGoodsItemDTO{

    //!商品图片
    [self.sampleImageView sd_setImageWithURL:[NSURL URLWithString:orderGoodsItemDTO.picUrl] placeholderImage:[UIImage imageNamed:@"post_placeholder"]];
    
    //!商品名称
    self.sampleNameLabel.text = orderGoodsItemDTO.goodsName;

    //!颜色
    self.colorLabel.text =  orderGoodsItemDTO.color;
    
    
    
    //!价钱
    NSMutableAttributedString * priceFirstStr = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:
                                                 @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                   NSFontAttributeName:[UIFont systemFontOfSize:9]}];
    
    NSMutableAttributedString * priceSecondStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",[orderGoodsItemDTO.price floatValue]] attributes:
                                                  @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                    NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [priceFirstStr appendAttributedString:priceSecondStr];
    self.priceLabel.attributedText = priceFirstStr;
    
    //!商品件数
    NSMutableAttributedString * goodNumFirstStr = [[NSMutableAttributedString alloc]initWithString:@"x" attributes:
                                                   @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                     NSFontAttributeName:[UIFont systemFontOfSize:9]}];
    
    NSMutableAttributedString * goodNumSecondStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",orderGoodsItemDTO.quantity] attributes:
                                                    @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                      NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [goodNumFirstStr appendAttributedString:goodNumSecondStr];
    self.numLabel.attributedText = goodNumFirstStr;

    


}
@end
