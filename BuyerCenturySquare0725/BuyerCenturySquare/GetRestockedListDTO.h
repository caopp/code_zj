//
//  GetRestockedListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetRestockedListDTO : BasicDTO
/**
 *  获取商品补货列表信息(RestockedDTO)
 */
@property(nonatomic,strong)NSMutableArray *restockedDTOList;

@property(nonatomic,strong)NSMutableArray *goodsList;

@end
