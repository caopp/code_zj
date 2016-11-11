//
//  StepListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  !阶梯价格

#import "BasicDTO.h"

@interface StepListDTO : BasicDTO
/**
 *  价格,类型double
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  id,类型为int
 */
@property(nonatomic,strong)NSNumber *Id;
/**
 *  最小数量,类型为int
 */
@property(nonatomic,strong)NSNumber *minNum;

/**
 *  最大数量,类型为int
 */
@property(nonatomic,strong)NSNumber *maxNum;

/**
 *  排序，类型为int
 */
@property(nonatomic,strong)NSNumber *sort;

@end
