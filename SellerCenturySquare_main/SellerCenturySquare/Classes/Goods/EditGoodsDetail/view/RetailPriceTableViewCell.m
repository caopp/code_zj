//
//  RetailPriceTableViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "RetailPriceTableViewCell.h"

@implementation RetailPriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.retailPriceTitleLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];

    
}

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO{

    
    [self.retailPriceTextField setText:[NSString stringWithFormat:@"%@",goodsInfoDTO.retailPrice]];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
