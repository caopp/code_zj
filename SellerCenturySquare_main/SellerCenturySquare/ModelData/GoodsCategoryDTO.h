//
//  GoodsCategoryDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GoodsCategoryDTO : BasicDTO

/**
 *  类别ID
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
 *  分类结构体编码
 */
@property(nonatomic,copy)NSString *structureNo;
/**
 *  分类结构体名称
 */
@property(nonatomic,copy)NSString *structureName;
/**
 *  级别
 */
@property(nonatomic,copy)NSString *level;
/**
 *  父ID
 */
@property(nonatomic,copy)NSString *parentId;
/**
 *  排序(Int 类型)
 */
@property(nonatomic,strong)NSNumber *sort;

@end
