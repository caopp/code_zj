//
//  MemberBlackDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MemberBlackDTO : BasicDTO
/**
 *  小B编码
 */
@property(nonatomic,copy)NSString *memberNo;
/**
 *  小B名称
 */
@property(nonatomic,copy)NSString *memberName;
/**
 *  小B帐号
 */
@property(nonatomic,copy)NSString *mobileAccount;

@end
