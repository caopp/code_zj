//
//  MerchantGetBoughtListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MerchantGetBoughtListDTO : BasicDTO

/**
 *  总数量
 */
@property(nonatomic,strong)NSNumber *totalCount;

/**
 *  list中包含BoughtDTO对象
 */
//@property(nonatomic,strong)NSMutableArray *list;

@property(nonatomic, strong)NSMutableArray *merchantList;
@end
