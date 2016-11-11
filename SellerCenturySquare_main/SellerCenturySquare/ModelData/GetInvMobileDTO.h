//
//  GetInvMobileDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetInvMobileDTO : BasicDTO

/**
 *  是否能够邀请
 */
@property(nonatomic,copy)NSString *invOpt;
/**
 *  联系手机号码
 */
@property(nonatomic,copy)NSString *memberAccount;

@end
