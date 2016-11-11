//
//  GetIntegralByMonthListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetIntegralByMonthListDTO : BasicDTO

/**
 *  获取按月查询小B消费积分列表信息(IntegralByMonthDTO)
 */
@property(nonatomic,strong)NSMutableArray *integralByMonthDTOList;
@end
