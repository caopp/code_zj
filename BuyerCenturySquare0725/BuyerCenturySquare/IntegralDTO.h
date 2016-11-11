//
//  IntegralDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface IntegralDTO : BasicDTO

/**
 *  交易时间yyyy-MM-dd
 */
@property(nonatomic,copy)NSString* time;

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString* merchantNo;

/**
 *  商家名称
 */
@property(nonatomic,copy)NSString* merchantName;

/**
 *  积分数量(类型 double)
 */
@property(nonatomic,strong)NSNumber* integralNum;

/**
 *  采购单号(类型 int)
 */
@property(nonatomic,strong)NSNumber* orderId;
/**
 *  采购单编码
 */
@property(nonatomic,copy)NSString* orderCode;
@end
