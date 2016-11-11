//
//  OrderListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface OrderListDTO : BasicDTO
/**
 *  总数量
 */
@property(nonatomic,strong)NSNumber *totalCount;

/**
 *  属性列表
 */
@property(nonatomic,strong)NSMutableArray *list;
@end
