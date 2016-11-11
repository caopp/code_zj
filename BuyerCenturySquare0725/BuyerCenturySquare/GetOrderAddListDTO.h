//
//  GetOrderAddListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetOrderAddListDTO : BasicDTO

/**
 *  获取生成采购单列表信息(OrderAddDTO)
 */
@property(nonatomic,strong)NSMutableArray *orderAddDTOList;
@end
