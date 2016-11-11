//
//  GetPayMerchantOnsaleDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
//3.24	付费上架
#import "BasicDTO.h"

@interface GetPayMerchantOnsaleDTO : BasicDTO

/**
 *  会员等级(类型:int)
 */
@property(nonatomic,strong)NSNumber *level;
/**
 *  剩余上架商品数(类型:int)
 */
@property(nonatomic,strong)NSNumber *onSaleNum;
/**
 *  购买上架权限的价格(类型:double)
 */
@property(nonatomic,strong)NSNumber *paySalePrice;
/**
 *  权限标识
 */
@property(nonatomic,copy)NSString *authFlag;
/**
 *  虚拟商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  虚拟sku编码
 */
@property(nonatomic,copy)NSString *skuNo;

@end
