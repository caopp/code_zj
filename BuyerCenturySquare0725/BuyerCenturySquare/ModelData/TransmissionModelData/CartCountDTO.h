//
//  CartCountDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CartCountDTO : BasicDTO

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;

/**
 *  购买数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *quantity;

/**
 *  购买金额(类型:double)
 */
@property(nonatomic,strong)NSNumber *amount;

- (NSMutableDictionary* )getDictFrom:(CartCountDTO *)cartCountDTO;
@end
