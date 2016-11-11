//
//  CSPConfirmOrderBaseTypeTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@class CartConfirmGoods;
@class OrderGoods;
@class OrderGoodsItem;

@interface CSPBaseOrderTableViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *smartImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *sampleColorLab;

//确认采购单
@property (nonatomic, weak) CartConfirmGoods* cartGoodsInfo;
//采购单列表
@property (nonatomic, weak) OrderGoods* orderGoodsInfo;
//采购单详情
@property (nonatomic, weak) OrderGoodsItem* orderGoodsItemInfo;

+ (CGFloat)cellHeightWithSizesCount:(NSInteger)sizesCount;

@end
