//
//  CartConfirmDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CartConfirmDTO : BasicDTO

/**
 *  商品编码
 */
@property(nonatomic,copy)NSString* goodsNo;

/**
 *  商品名称
 */
@property(nonatomic,copy)NSString* goodsName;

/**
 *  Sku编码
 */
@property(nonatomic,copy)NSString* skuNo;

/**
 *  Sku名称（尺码）
 */
@property(nonatomic,copy)NSString* skuName;

/**
 *  商品颜色
 */
@property(nonatomic,copy)NSString* color;

/**
 *  起批数量(类型为int)
 */
@property(nonatomic,strong)NSNumber* batchNumLimit;
/**
 *  列表小图
 */
@property(nonatomic,copy)NSString* picUrl;

/**
 * 数量(类型为int)
 */
@property(nonatomic,strong)NSNumber* quantity;
/**
 *价格(类型为double)
 */
@property(nonatomic,strong)NSNumber* price;

/**
 *  阶梯价格数组,包含了StepListDTO对象
 */
@property(nonatomic,strong)NSMutableArray *stepList;

@end
