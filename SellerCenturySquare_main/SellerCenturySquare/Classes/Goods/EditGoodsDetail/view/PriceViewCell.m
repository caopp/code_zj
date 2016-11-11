//
//  PriceViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PriceViewCell.h"

@implementation PriceViewCell

- (void)awakeFromNib {
    // Initialization code

    [self.priceTitleLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    self.bottomFilterLabelHight.constant = 0.5;
    
    [self.bottomFilterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];

    
    [self.alertLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    
}

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO{

    
    self.sixPriceTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.price6];

    self.fivePriceTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.price5];
    
    self.fourPriceTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.price4];

    self.threePriceTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.price3];

    self.twoPriceTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.price2];

    self.onePriceTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.price1];



}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
