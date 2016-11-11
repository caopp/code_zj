//
//  OrderDeatiGoodsViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderGoodsItemDTO.h"

@interface OrderDeatiGoodsViewCell : UITableViewCell

//!图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImagView;

//!名称
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

//!价钱
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

//!商品件数
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;

//!"颜色"

@property (weak, nonatomic) IBOutlet UILabel *colorLeftLabel;

//!颜色
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

//!“尺码”
@property (weak, nonatomic) IBOutlet UILabel *sizeLeftLabel;

//!尺码
@property (weak, nonatomic) IBOutlet UIView *sizeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeHight;

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

//!查看的是零售订单
@property(nonatomic,assign)BOOL isFromRetail;

//! 商品信息的dto、isRetail：查看的是零售订单
-(void)configData:(orderGoodsItemDTO * )orderGoodsItemDTO isRetail:(BOOL)isRetail;


@end
