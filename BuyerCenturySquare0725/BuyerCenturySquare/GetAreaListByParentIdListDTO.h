//
//  GetAreaListByParentIdListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetAreaListByParentIdListDTO : BasicDTO

/**
 *  总数量(类型为int)
 */
@property(nonatomic,strong)NSNumber* totalCount;
/**
 *  获取生成采购单列表信息(GetAreaListByParentIdDTO)
 */
@property(nonatomic,strong)NSMutableArray *getAreaListByParentIdDTOList;

@end
