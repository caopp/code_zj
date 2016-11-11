//
//  SkuListDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface SkuListDTO : BasicDTO
/**
 *  Sku编码
 */
@property(nonatomic,copy)NSString *skuNo;

/**
 *  id,类型为int
 */
@property(nonatomic,strong)NSNumber *Id;

/**
 *  Sku名称
 */
@property(nonatomic,copy)NSString *skuName;

/**
 *  库存,类型为int
 */
@property(nonatomic,strong)NSNumber *skuStock;

/**
 *  排序号
 */
@property(nonatomic,copy)NSString *sort;

/**
 *  预售标记1可预售2不可预售
 */
@property(nonatomic,copy)NSString *preFlag;

/**
 *  是否显示有货(1:有货 0:无货)
 */
@property(nonatomic,copy)NSString *showStockFlag;

/**
 *  保存用户选取数量,类型为int
 */
@property(nonatomic,strong)NSNumber *quantity;

@end
