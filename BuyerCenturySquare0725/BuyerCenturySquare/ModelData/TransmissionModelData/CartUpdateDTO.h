//
//  CartUpdateDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CartUpdateDTO : BasicDTO
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;

@property(nonatomic, strong)NSString* cartType;

/**
 *  Sku编码
 */
@property(nonatomic,copy)NSString *skuNo;

/**
 *  Sku名称
 */
@property(nonatomic,copy)NSString *skuName;

/**
 *  该商品所有sku数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *totalQuantityOnGoods;

/**
 *  新sku数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *NewQuantity;
/**
 *  spot现货;future期货
 */
@property(nonatomic,copy)NSString *type;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;
@end
