//
//  GetShopGoodsListDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

//3.12	商品列表（店铺展示）接口
#import "BasicDTO.h"

@interface GetShopGoodsListDTO : BasicDTO

/**
 *  营业状态(0:营业1:歇业)
 */
@property(nonatomic,copy)NSString *operateStatus;
/**
 * 歇业结束时间
 */
@property(nonatomic,copy)NSString *closeEndTime;
/**
 * 歇业开始时间
 */
@property(nonatomic,copy)NSString *closeStartTime;
/**
 *  总条(类型:int)
 */
@property(nonatomic,strong)NSNumber *totalCount;

/**
 *  返回大B商品列表(ShopGoodsDTO)
 */
@property(nonatomic,strong)NSMutableArray *ShopGoodsDTOList;

@end
