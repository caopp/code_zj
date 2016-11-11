//
//  CartDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"
@interface CartGoodsDTO : BasicDTO
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
 *  购买数量(类型为int)
 */
@property(nonatomic,strong)NSNumber* quantity;
/**
 *  商品价格(动态的阶梯价格 double)
 */
@property(nonatomic,strong)NSNumber* price;
/**
 *  样板价(类型为 Double)
 */
@property(nonatomic,strong)NSNumber* samplePrice;
/**
 *  商品图片(窗口图的第1张)
 */
@property(nonatomic,copy)NSString* picUrl;
/**
 *  商品状态
 */
@property(nonatomic,copy)NSString* goodsStatus;
/**
 *  起批数量(类型为int)
 */
@property(nonatomic,strong)NSNumber* batchNumLimit;
/**
 *  0普通商品 , 1样板商品 2邮费专拍
 */
@property(nonatomic,copy)NSString* cartType;
/**
 *  商品sku列表
 */
@property(nonatomic,strong)NSMutableArray *skuDTOList;

/**
 *  阶梯价格列表
 */
@property(nonatomic,strong)NSMutableArray *stepPriceDTOList;

/**
 *  Step数组
 */
@property(nonatomic,strong)NSMutableArray *stepDTOList;



@end

@interface CartDTO : BasicDTO

/**
 *  商家编号
 */
@property(nonatomic,copy)NSString* merchantNo;
/**
 *  商家名称
 */
@property(nonatomic,copy)NSString* merchantName;
/**
 *  CartGoodsDTO 数组
 */
@property(nonatomic,strong)NSMutableArray *cartGoodsDTOList;

@end
