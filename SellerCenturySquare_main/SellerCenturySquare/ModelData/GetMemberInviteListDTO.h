//
//  GetMemberInviteListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.37	采购商-我邀请的会员的列表接口

#import "BasicDTO.h"

@interface GetMemberInviteListDTO : BasicDTO
/**
 *  总数量(类型 int)
 */
@property(nonatomic,strong)NSNumber *totalCount;
/**
 *  返回我邀请的会员的列表信息(MemberInviteDTO)
 */
@property(nonatomic,strong)NSMutableArray *memberInviteDTOList;
@end
