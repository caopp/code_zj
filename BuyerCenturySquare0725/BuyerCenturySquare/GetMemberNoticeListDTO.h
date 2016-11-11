//
//  GetMemberNoticeListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetMemberNoticeListDTO : BasicDTO

/**
 *  总条数 (类型为int)
 */
@property(nonatomic,strong)NSNumber* totalCount;

/**
 *  站内信的列表信息包含MemberNoticeDTO对象
 */
@property(nonatomic,strong)NSMutableArray *memberNoticeDTOlist;

@end
