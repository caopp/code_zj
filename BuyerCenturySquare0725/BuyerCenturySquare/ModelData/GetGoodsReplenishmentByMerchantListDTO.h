//
//  GetGoodsReplenishmentByMerchantListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-26.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"


@interface GetGoodsReplenishmentByMerchantListDTO : BasicDTO

/**
 *  获取商品补货列表信息(按商家时间倒序取)
 */
@property(nonatomic,strong)NSMutableArray *getGoodsReplenishmentByMerchantDTOList;

@property(nonatomic, strong)NSMutableArray* merchantList;

@end
