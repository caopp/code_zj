//
//  GetCartWholesaleConditionDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetCartWholesaleConditionDTO : BasicDTO

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  是否满足条件(0满足;1未满足)
 */
@property(nonatomic,copy)NSString *isSatisfy;
/**
 *  起批数量限制开启状态(0:开启 1:关闭)
 */
@property(nonatomic,copy)NSString *batchNumFlag;
/**
 *  起批数量(int)
 */
@property(nonatomic,strong)NSNumber *batchNumLimit;

/**
 *  起批金额限制开启状态(0:开启 1:关闭)
 */
@property(nonatomic,copy)NSString *batchAmountFlag;
/**
 *  起批金额(double)
 */
@property(nonatomic,strong)NSNumber *batchAmountLimit;

@end
