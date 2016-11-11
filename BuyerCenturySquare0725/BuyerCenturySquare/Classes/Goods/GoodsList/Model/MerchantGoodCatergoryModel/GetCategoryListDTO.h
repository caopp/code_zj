//
//  GetCategoryListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetCategoryListDTO : BasicDTO

/**
 *  商品分类列表
 */
@property(nonatomic,strong)NSMutableArray *getCategoryDTOList;

@end
