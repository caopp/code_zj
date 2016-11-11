//
//  OrderGoodsListPropertyDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface OrderGoodsListPropertyDTO : BasicDTO
/**
 *  采购单号
 */
@property(nonatomic,strong)NSNumber *orderId;

/**
 *  尺码：M:1,XL:2
 */
@property(nonatomic,copy)NSString *skuAndQty;

/**
 *  商品显示名称
 */
@property(nonatomic,copy)NSString *displayName;

/**
 *  商品购买价格
 */
@property(nonatomic,strong)NSNumber *price;

/**
 *  购买该商品总数量
 */
@property(nonatomic,strong)NSNumber *totalQuantity;

/**
 *  采购单商品状态
 */
@property(nonatomic,strong)NSNumber *status;

/**
 *  商品类型
 */
@property(nonatomic,strong)NSNumber *type;

/**
 *  商品颜色
 */
@property(nonatomic,copy)NSString *color;

@end
