//
//  MerchantListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
// !商家列表 包含了所有的商家列表

#import "BasicDTO.h"

@interface MerchantListDTO : BasicDTO
/**
 *  总数量
 */
@property(nonatomic,strong)NSNumber *totalCount;

/**
 *  数组,包含了MerchantListDetailsDTO对象
 */
//@property(nonatomic,strong)NSMutableArray *merchantListDetailsDTOList;

@property (nonatomic, strong)NSMutableArray* merchantList;


@end
