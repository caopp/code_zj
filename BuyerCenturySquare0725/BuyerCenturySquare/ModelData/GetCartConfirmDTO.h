//
//  GetCartConfirmDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GoodsDTO : BasicDTO
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;
/**
 *  商品颜色
 */
@property(nonatomic,copy)NSString *color;

/**
 *  商品图片
 */
@property(nonatomic,copy)NSString *picUrl;
/**
 *  商品类型(0普通商品、1邮费专拍)
 */
@property(nonatomic,copy)NSString *goodsType;
/**
 *  样板价(类型:double)
 */
@property(nonatomic,strong)NSNumber *samplePrice;
/**
 *  是否样板(0是样板，1不是)
 */
@property(nonatomic,copy)NSString *isSample;
/**
 *  价格(类型:double)
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  总数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *quantity;
/**
 * 尺码组合(尺码:M:3,L:1（sku合并：sku名称:数量，sku名称:数量）)
 */
@property(nonatomic,copy)NSString *sizes;

@end

@interface MerchantDTO : BasicDTO
/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;
/**
 *  类型(spot-现货 ;future-期货)
 */
@property(nonatomic,copy)NSString *type;

@property(nonatomic,strong)NSMutableArray *goodsDTOList;

@end

@interface GetCartConfirmDTO : BasicDTO
/**
 * ( 采购单总价 )含运费(类型:Double)
 */
@property(nonatomic,strong)NSNumber *totalPrice;
/**
 * 采购单总数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *totalQuantity;

/**
 *  商家list
 */
@property(nonatomic,strong)NSMutableArray *merchantDTOList;

@end
