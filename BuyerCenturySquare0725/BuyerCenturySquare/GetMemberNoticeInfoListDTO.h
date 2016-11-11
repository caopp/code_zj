//
//  GetMemberNoticeInfoListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetMemberNoticeInfoListDTO : BasicDTO

/**
 *  返回站内信的列表信息(MemberNoticeInfoDTO)
 */
@property(nonatomic,strong)NSMutableArray *memberNoticeInfoDTOList;
@end
