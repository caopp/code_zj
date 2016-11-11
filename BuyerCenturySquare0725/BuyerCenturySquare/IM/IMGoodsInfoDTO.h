//
//  IMGoodsInfoDTO.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartAddDTO.h"

@class ReplenishmentGoods;

@interface IMGoodsInfoDTO : NSObject

/**
 *  商家编码
 */
@property (nonatomic,copy) NSString *merchantNo;

/**
 *  商品编码
 */
@property (nonatomic,copy) NSString *goodsNo;
/**
 *  商品货号
 */
@property (nonatomic,copy) NSString *goodsWillNo;
/**
 *  商品类型: 0普通商品 , 1样板商品 2邮费专拍
 */
@property (nonatomic,copy) NSString *cartType;

/**
 *  单价格(类型:double)
 */
@property(nonatomic,strong) NSNumber *price;

/**
 *  总数量(类型:int)
 */
@property(nonatomic,strong) NSNumber *totalQuantity;

/**
 *  Sku数组
 */
@property(nonatomic,strong) NSMutableArray *skuList;


/**
 @property
 @brief  商家名称
 */
@property (nonatomic, copy) NSString * merchantName;

/**
 @property
 @brief sessionType 会话类型   0表示客服会话， 1表示询单会话
 */
@property (nonatomic, assign) int sessionType;

/**
 @property
 @brief 颜色
 */
@property (nonatomic, copy) NSString *goodColor;

/**
 @property
 @brief 图片
 */
@property (nonatomic, copy) NSString *goodPic;

/**
 @property
 @brief  发版结算:0  询单结算:1
 */
@property (nonatomic, assign) BOOL isBuyModel;

/**
 *  样板价格(类型:double)
 */
@property(nonatomic,strong)NSNumber *samplePrice;

/**
 *  样板skuNo
 */
@property(nonatomic, copy) NSString *sampleSkuNo;

/**
 *  阶梯价格
 */
@property(nonatomic,strong)NSMutableArray *stepPriceList;

/**
 * 起批件数
 */
@property (nonatomic, strong) NSNumber * batchNumLimit;

/**
 *  自身昵称
 */
@property(nonatomic, copy) NSString *fromName;
/*
 *shopLevel;    店内等级
 */
@property(nonatomic,copy) NSNumber * shopLevel;

- (id)initWithReplenishmentInfo:(ReplenishmentGoods*)replenishmentInfo;

//将IMGoodsInfoDTO转化成CartAddDTO
- (CartAddDTO *)transformToCartAddDTO;

//将IMGoodsInfoDTO转化成样板购买DTO
- (CartAddDTO *)transformToModelCartAddDTO;

- (NSMutableArray*)skuDictionaryList;

- (NSMutableArray*)modelSkuDictionaryList;

- (NSInteger)gettotalQuantity;

- (NSNumber *)stepPriceForCurrentQuantity;

@end
