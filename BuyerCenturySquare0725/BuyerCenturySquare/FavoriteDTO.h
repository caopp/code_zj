//
//  FavoriteDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface FavoriteDTO : BasicDTO

/**
 *  商品编码
 */
@property(nonatomic,copy) NSString* goodsNo;
/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;

/**
 *  商品窗口图路径（小图）
 */
@property(nonatomic,copy)NSString *picUrl;

/**
 *  商品价格(类型为double)
 */
@property(nonatomic,strong)NSNumber *price;

/**
 *  起批数量(类型为int)
 */
@property(nonatomic,strong)NSNumber *batchNumLimit;

@property(nonatomic,copy)NSString *color;

@property(nonatomic,copy)NSString *merchantName;

@property(nonatomic,copy)NSString *merchantNo;

@end
