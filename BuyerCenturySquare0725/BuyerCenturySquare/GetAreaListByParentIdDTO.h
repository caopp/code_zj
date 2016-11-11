//
//  GetAreaListByParentIdDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetAreaListByParentIdDTO : BasicDTO

/**
 *  id(类型为int)
 */
@property(nonatomic,strong)NSNumber* Id;
/**
 *  父级ID(类型为int)
 */
@property(nonatomic,strong)NSNumber* parentId;
/**
 *  地区名称
 */
@property(nonatomic,copy)NSString* name;
/**
 *  排序(类型为int)
 */
@property(nonatomic,strong)NSNumber* sort;
/**
 *  级别类型2省份、3市区、4区县
 */
@property(nonatomic,copy)NSString* type;
@end
