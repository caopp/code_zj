//
//  GetPayBalanceDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetPayBalanceDTO : BasicDTO

/**
 *  可用余额(类型为Double)
 */
@property(nonatomic,strong)NSNumber* availableAmount;
/**
 *  被冻结的额度(类型为Double)
 */
@property(nonatomic,strong)NSNumber* freezeAmount;
/**
 *  小B会员编号
 */
@property(nonatomic,copy)NSString* memberNo;
/**
 *  总共的余额(类型为Double,含冻结额度)
 */
//@property(nonatomic,strong)NSNumber* totalAmount;
@property(nonatomic,strong)NSNumber * totalAmount;


@end
