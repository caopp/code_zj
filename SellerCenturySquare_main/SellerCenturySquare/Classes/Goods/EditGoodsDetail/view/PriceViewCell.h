//
//  PriceViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//  !价格cell

#import <UIKit/UIKit.h>
#import "GetGoodsInfoListDTO.h"

@interface PriceViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;


@property (weak, nonatomic) IBOutlet UITextField *sixPriceTextField;


@property (weak, nonatomic) IBOutlet UITextField *fivePriceTextField;


@property (weak, nonatomic) IBOutlet UITextField *fourPriceTextField;

@property (weak, nonatomic) IBOutlet UITextField *threePriceTextField;

@property (weak, nonatomic) IBOutlet UITextField *twoPriceTextField;

@property (weak, nonatomic) IBOutlet UITextField *onePriceTextField;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *bottomFilterLabel;

//!分割线高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFilterLabelHight;

//!提示信息
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO;


@end
