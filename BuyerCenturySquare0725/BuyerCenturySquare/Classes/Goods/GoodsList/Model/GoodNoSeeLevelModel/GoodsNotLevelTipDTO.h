//
//  GoodsNotLevelTipDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  等级提示dto

#import "BasicDTO.h"

@interface GoodsNotLevelTipDTO : BasicDTO

/**
 *  查看商品详情需要的等级数(类型：int)
 */
@property(nonatomic,strong)NSNumber *readLevel;

/**
 *  小B当前等级（对于该大B的等级）(类型：int)
 */
@property(nonatomic,strong)NSNumber *currentLevel;

/**
 *  差的积分数量(类型：double) （为负数时，表明积分已达到）
 */
@property(nonatomic,strong)NSNumber *integralNum;

@end
