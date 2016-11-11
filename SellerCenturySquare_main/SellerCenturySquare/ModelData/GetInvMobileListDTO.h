//
//  GetInvMobileListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetInvMobileListDTO : BasicDTO

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger banInviteCount;

//手机联系号码是能接受邀请的DTO
@property(nonatomic,strong)NSMutableArray *getInvMobileDTOList;

// !不能接受邀请的
@property(nonatomic,strong)NSMutableArray *banInviteDTOList;


@end
