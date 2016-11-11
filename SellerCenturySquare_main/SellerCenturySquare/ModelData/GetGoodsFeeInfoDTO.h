//
//  GetGoodsFeeInfoDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-12.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetGoodsFeeInfoDTO : BasicDTO

/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;

/**
 *  价格(类型 Double)
 */
@property(nonatomic,strong)NSNumber *price;

/**
 *  列表图
 */
@property(nonatomic,copy)NSString *imgUrl;

/**
 *  商品详情
 */
@property(nonatomic,strong)NSString *details;
/**
 *  详情图
 */
@property(nonatomic,strong)NSString *detailUrl;

/**
 *  sku列表值,包含了SkuListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *skuList;

@end
