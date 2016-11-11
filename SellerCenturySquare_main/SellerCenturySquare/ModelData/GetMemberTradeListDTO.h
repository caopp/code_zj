//
//  GetMemberTradeListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.36	采购商-有交易的会员的列表接口

#import "BasicDTO.h"

@interface GetMemberTradeListDTO : BasicDTO

/**
 *  总记录数(类型 int)
 */
@property(nonatomic,strong)NSNumber *totalCount;
/**
 *  采购商小B列表(MemberTradeDTO)
 */
@property(nonatomic,strong)NSMutableArray *memberTradeDTOList;

@end
