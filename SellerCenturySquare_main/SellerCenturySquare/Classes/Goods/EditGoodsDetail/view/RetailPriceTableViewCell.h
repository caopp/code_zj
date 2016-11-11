//
//  RetailPriceTableViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//!零售价格

#import <UIKit/UIKit.h>
#import "GetGoodsInfoListDTO.h"

@interface RetailPriceTableViewCell : UITableViewCell
{
    
    GetGoodsInfoListDTO * _goodsInfoDTO;
    
}

@property (weak, nonatomic) IBOutlet UILabel *retailPriceTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *retailPriceTextField;

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO;


@end
