//
//  GetBoughtListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetBoughtListDTO : BasicDTO

@property(nonatomic, strong)NSNumber* totalCount;
/**
 *  获取商品补货列表信息包含BoughtDTO对象
 */
@property(nonatomic,strong)NSMutableArray *boughtDTOList;

@end
