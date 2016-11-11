//
//  GetMerchantNotAuthTipDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.26	无权限提示接口
#import "BasicDTO.h"

@interface GetMerchantNotAuthTipDTO : BasicDTO
/**
 *  需要的等级数(类型:int)
 */
@property(nonatomic,strong)NSNumber *readLevel;
/**
 *  大B当前等级(类型:int)
 */
@property(nonatomic,strong)NSNumber *currentLevel;
/**
 *  差的积分数量(类型:double)
 */
@property(nonatomic,strong)NSNumber *integralNum;
/**
 *  是否有权限(类型:bool)
 */
@property(nonatomic,assign)BOOL hasAuth;

@end
