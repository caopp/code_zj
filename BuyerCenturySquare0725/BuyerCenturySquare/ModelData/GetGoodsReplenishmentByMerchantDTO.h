//
//  GetGoodsReplenishmentByMerchantDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-26.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetGoodsReplenishmentByMerchantDTO : BasicDTO

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString* merchantNo;
/**
 *  商家名称
 */
@property(nonatomic,copy)NSString* merchantName;
/**
 *  获取商品补货列表信息(RestockedDTO)
 */
@property(nonatomic,strong)NSMutableArray *restockedDTOList;

@end
