//
//  ShopGoodsDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ShopGoodsDTO : BasicDTO
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;
/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  商品价格(double 类型)
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  图片路径
 */
@property(nonatomic,copy)NSString *imgUrl;
/**
 *  第一次上架时间yyyy-MM-dd
 */
@property(nonatomic,copy)NSString *firstOnsaleTime;
/**
 *  起批数量(int 类型)
 */
@property(nonatomic,strong)NSNumber *batchNumLimit;
/**
 *  第三方货号
 */
@property(nonatomic,copy)NSString *goodsWillNo;
/**
 *  商品等级(int 类型)
 */
@property(nonatomic,strong)NSNumber *readLevel;

/**
 *  0普通商品、1邮费专拍
 */
@property(nonatomic,copy)NSString *goodsType;
/**
 *  天数(int 类型)
 */
@property(nonatomic,strong)NSNumber *dayNum;

/**
 *  颜色
 */
@property(nonatomic,copy)NSString *goodsColor;

@property(nonatomic,copy)NSString *searchGoodNo;

@end
