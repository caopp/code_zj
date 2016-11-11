//
//  GetCategoryDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetCategoryDTO : BasicDTO

/**
 *  id(类型 int)
 */
@property(nonatomic,strong)NSNumber *Id;

/**
 *  类别编号
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
 *  排序(类型 int)
 */
@property(nonatomic,strong)NSNumber *sort;
/**
 *  父ID(类型 int)
 */
@property(nonatomic,copy)NSString *parentId;
@end
