//
//  OrderAddDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface OrderAddDTO : BasicDTO

/**
 *交易总金额(类型为Double)
 */
@property(nonatomic,strong)NSNumber* totalAmount;
/**
 *交易单号
 */
@property(nonatomic,copy)NSString* tradeNo;

@end
