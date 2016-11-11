//
//  StatisticsGetIntegralListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface StatisticsGetIntegralListDTO : BasicDTO
/**
 *  交易时间yyyy-MM-dd
 */
@property(nonatomic,copy)NSString *time;

/**
 *  采购单编码
 */
@property(nonatomic,copy)NSString *orderNo;

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;

/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;

/**
 *  积分数量
 */
@property(nonatomic,strong)NSNumber *integralNum;

/**
 *  采购单号
 */
@property(nonatomic,strong)NSNumber *orderId;
@end
