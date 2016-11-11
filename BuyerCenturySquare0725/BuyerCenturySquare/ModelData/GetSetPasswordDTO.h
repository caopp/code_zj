//
//  GetSetPasswordDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetSetPasswordDTO : BasicDTO

/**
 *  会员编码
 */
@property(nonatomic,copy)NSString *tokenId;

/**
 *  小B编码
 */
@property(nonatomic,copy)NSString *memberNo;

@end
