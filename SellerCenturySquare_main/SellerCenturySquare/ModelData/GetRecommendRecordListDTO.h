//
//  GetRecommendRecordListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.31	推荐商品记录列表接口
#import "BasicDTO.h"

@interface GetRecommendRecordListDTO : BasicDTO

/**
 *  总记录数(类型 int)
 */
@property(nonatomic,strong)NSNumber *totalCount;

/**
 *  推荐商品记录列表(RecommendRecordDTO)
 */
@property(nonatomic,strong)NSMutableArray *recommendRecordDTOList;

@end
