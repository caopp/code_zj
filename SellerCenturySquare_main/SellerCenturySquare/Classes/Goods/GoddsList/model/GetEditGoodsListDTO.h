//
//  GetEditGoodsListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

//3.13	商品列表（可编辑）接口
//返回大B商品列表json数据，如有异常就返回值无此项
#import "BasicDTO.h"

@interface GetEditGoodsListDTO : BasicDTO

/**
 *  总条(类型:int)
 */
@property(nonatomic,strong)NSNumber *totalCount;

/**
 *  返回大B商品列表(EditGoodsDTO)
 */
@property(nonatomic,strong)NSMutableArray *EditGoodsDTOList;

@end
