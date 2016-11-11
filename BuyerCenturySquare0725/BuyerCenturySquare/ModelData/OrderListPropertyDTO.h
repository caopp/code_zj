//
//  OrderListPropertyDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface OrderListPropertyDTO : BasicDTO

/**
 *  采购单ID
 */
@property(nonatomic,strong)NSNumber *orderId;

/**
 *  采购单类型
 */
@property(nonatomic,strong)NSNumber *type;

/**
 *  商家编号
 */
@property(nonatomic,strong)NSNumber *merchantNo;

/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;

/**
 *  采购单价格
 */
@property(nonatomic,strong)NSNumber *totalAmoount;

/**
 *  物流费用
 */
@property(nonatomic,strong)NSNumber *dFee;

/**
 *  采购单状态
 */
@property(nonatomic,strong)NSNumber *status;

/**
 *  采购单商品总数量
 */
@property(nonatomic,strong)NSNumber *totalQty;

@end
