//
//  CommodityClassificationDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  商品分类dto

#import "BasicDTO.h"

@interface CommodityClassificationDTO : BasicDTO

@property(nonatomic,strong)NSNumber *id;

/**
 *  类别编号(类型：int)
 */
@property(nonatomic,copy)NSString *categoryNo;

/**
 *  类别名称
 */
@property(nonatomic,copy)NSString *categoryName;

/**
 *  级别
 */
@property(nonatomic,copy)NSString *level;

/**
 *  结构体名称，上级名称组合
 */
@property(nonatomic,copy)NSString *structureName;

/**
 *  结构体编码，上级编码组合
 */
@property(nonatomic,copy)NSString *structureNo;

/**
 *  排序(类型：int)
 */
@property(nonatomic,strong)NSNumber *sort;

/**
 *  父级ID(类型：int)
 */
@property(nonatomic,strong)NSNumber *parentId;

@end
