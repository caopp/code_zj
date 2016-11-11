//
//  GetMemberInfoListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetMemberInfoListDTO : BasicDTO

/**
 *  获取查看个人资料列表信息(MemberInfoDTO)
 */
@property(nonatomic,strong)NSMutableArray *MemberInfoDTOList;

@end
