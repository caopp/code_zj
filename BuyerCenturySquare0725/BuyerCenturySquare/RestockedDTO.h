//
//  RestockedDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface RestockedDTO : BasicDTO
/**
 *  商家编码
 */
@property(nonatomic,copy)NSString* merchantNo;
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString* goodsNo;
/**
 *  商品名称
 */
@property(nonatomic,copy)NSString* goodsName;
/**
 *  商品颜色
 */
@property(nonatomic,copy)NSString* color;
/**
 *  商品图片
 */
@property(nonatomic,copy)NSString* picUrl;
/**
 * 起批数量(类型 int)
 */
@property(nonatomic,strong)NSNumber* batchNumLimit;
/**
 * 起批单价(类型 double)
 */
@property(nonatomic,strong)NSNumber* batchPrice;
/**
 *  Sku列表  SkuListDTO
 */
@property(nonatomic,strong)NSMutableArray *skuListDTOList;

@property(nonatomic,strong)NSMutableArray* skuList;
@end
