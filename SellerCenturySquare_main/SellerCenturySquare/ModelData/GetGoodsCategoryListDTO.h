//
//  GetGoodsCategoryListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

/****3.11	大B获取商品分类接口******/

#import "BasicDTO.h"

@interface GetGoodsCategoryListDTO : BasicDTO

/**
 *  返回商品分类列表信息(GoodsCategoryDTO)
 */
@property(nonatomic,strong)NSMutableArray *goodsCategoryDTOList;

@end
