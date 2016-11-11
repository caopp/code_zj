//
//  IntegralByMonthDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface IntegralByMonthDTO : BasicDTO

/**
 *  年月
 */
@property(nonatomic,copy)NSString* time;

/**
 *  积分数量
 */
@property(nonatomic,copy)NSNumber* integralNum;

@end
