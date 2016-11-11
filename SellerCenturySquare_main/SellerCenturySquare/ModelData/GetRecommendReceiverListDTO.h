//
//  GetRecommendReceiverListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.34	推荐商品收件人列表接口

#import "BasicDTO.h"

@interface GetRecommendReceiverListDTO : BasicDTO

/**
 *  总记录数(类型 int)
 */
@property(nonatomic,strong)NSNumber *totalCount;
/**
 *  推荐商品收件人列表接口列表(RecommendReceiverDTO)
 */
@property(nonatomic,strong)NSMutableArray *recommendReceiverDTOList;
@end
