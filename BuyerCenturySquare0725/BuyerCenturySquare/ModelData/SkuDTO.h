//
//  SkuDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface SkuDTO : BasicDTO
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  单价格(类型:double)
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  Sku编码
 */
@property(nonatomic,copy)NSString *skuNo;
/**
 *  Sku名称
 */
@property(nonatomic,copy)NSString *skuName;

/**
 *  spot现货;future期货
 */
@property(nonatomic,copy)NSString *type;
/**
 *  数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *quantity;
/**
 *  现货数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *spotQuantity;
/**
 *  期货数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *futureQuantity;


- (NSMutableDictionary* )getDictFrom:(SkuDTO *)skuDTO;

@end

