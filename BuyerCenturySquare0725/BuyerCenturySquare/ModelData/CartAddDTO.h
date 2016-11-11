//
//  CartAddDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@class ReplenishmentGoods;
@class GoodsInfoDetailsDTO;
@class IMGoodsInfoDTO;

@interface CartAddDTO : BasicDTO

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  商品类型: 0普通商品 , 1样板商品 2邮费专拍
 */
@property(nonatomic,copy)NSString *cartType;
/**
 *  单价格(类型:double)
 */
@property(nonatomic,strong)NSNumber *price;

/**
 *  总数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *totalQuantity;

/**
 *  Sku数组
 */
@property(nonatomic,strong)NSMutableArray *skuDTOList;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;

- (id)initWithReplenishmentItem:(ReplenishmentGoods*)replenishmentItem;

- (id)initWithGoodInfoDetailsInfo:(GoodsInfoDetailsDTO *)goodInfoDetailsDTO;

//普通商品加入采购车
- (id)initWithIMGoodsInfoDTO:(IMGoodsInfoDTO *)imGoodsInfoDTO;

//样板商品加入采购车
- (id)initWithIMGoodsInfoDTO2Model:(IMGoodsInfoDTO *)imGoodsInfoDTO;

@end
