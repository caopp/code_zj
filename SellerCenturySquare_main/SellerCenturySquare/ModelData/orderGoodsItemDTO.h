//
//  OrderItemDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface orderGoodsItemDTO : BasicDTO

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
 *  商品图片(窗口图的第1张)
 */
@property(nonatomic,copy)NSString *picUrl;
/**
 *  商品类型(0普通商品 , 1样板商品 2邮费专拍)
 */
@property(nonatomic,copy)NSString *cartType;
/**
 *  单价(类型:double)
 */
@property(nonatomic,strong)NSNumber *price;
/**
 *  该sku 购买数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *quantity;
/**
 *  尺码组合(尺码:M:3,L:1（sku合并：sku名称:数量，sku名称:数量）)
 */
@property(nonatomic,copy)NSString *sizes;

// yes:表示选中 no:未选中
@property (nonatomic ,copy) NSString *markStatus;

@end
