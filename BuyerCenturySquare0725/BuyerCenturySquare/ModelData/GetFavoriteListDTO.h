//
//  GetFavoriteListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MerchantInfoDTO : BasicDTO

@property (nonatomic, strong)NSString* merchantName;
@property (nonatomic, strong)NSMutableArray* goodsList;

@end

@interface GetFavoriteListDTO : BasicDTO

/**
 *  总条数 类型为int
 */
@property(nonatomic,strong)NSNumber *totalCount;
/**
 * MerchantDTO对象
 */
@property(nonatomic,strong)NSMutableArray *list;


@end
