//
//  GetMerchantIntegralByMonthDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetMerchantIntegralByMonthDTO : BasicDTO

/**
 *  交易时间yyyy-MM-dd
 */
@property(nonatomic,copy)NSString* time;

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString* memberNo;

/**
 *  商家名称
 */
@property(nonatomic,copy)NSString* memberName;

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
