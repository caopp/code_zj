//
//  GetNoticeStationListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

//3.17	大B站内信列表
//返回大B站内信信息json数据，如有异常就返回值无此项
#import "BasicDTO.h"

@interface GetNoticeStationListDTO : BasicDTO
/**
 *  总数量
 */
@property(nonatomic,copy)NSString *totalCount;
/**
 *  返回站内信列表信息(NoticeStationDTO)
 */
@property(nonatomic,strong)NSMutableArray *noticeStationDTOList;

@end
