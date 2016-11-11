//
//  GetMemberBlackListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.38	采购商-黑名单列表接口

#import "BasicDTO.h"

@interface GetMemberBlackListDTO : BasicDTO
/**
 *  总数量(类型 int)
 */
@property(nonatomic,strong)NSNumber *totalCount;
/**
 *  返回黑名单列表信息(MemberBlackDTO)
 */
@property(nonatomic,strong)NSMutableArray *memberBlackDTOList;
@end
