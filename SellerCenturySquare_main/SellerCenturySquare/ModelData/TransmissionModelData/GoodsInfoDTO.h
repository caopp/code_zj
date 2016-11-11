//
//  GoodsInfoDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface StepDTO : BasicDTO

/**
 *  阶梯价格数组(类型:double)
 */
@property(nonatomic,strong)NSNumber* price;

/**
 *  商品编码
 */
@property(nonatomic,copy)NSString* goodsNo;

/**
 *  阶梯价ID(类型:int)
 */
@property(nonatomic,strong)NSNumber* Id;
/**
 * 最小数量
 */
@property(nonatomic,strong)NSNumber* minNum;
/**
 * 最大数量
 */
@property(nonatomic,strong)NSNumber* maxNum;
/**
 * 排序
 */
@property(nonatomic,strong)NSNumber* sort;
- (NSMutableDictionary* )getDictFrom:(StepDTO *)stepDTO;

@end

@interface PicDTO : BasicDTO

/**
 *  图片路径
 */
@property(nonatomic,copy)NSString* picUrl;

/**
 *  图片名称
 */
@property(nonatomic,copy)NSString* picName;
/**
 *  图片类型
 */
@property(nonatomic,copy)NSString* picType;
/**
 * 排序
 */
@property(nonatomic,strong)NSNumber* sort;
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString* goodsNo;
/*
*审核状态：0：待审核 1：审核通过 2：审核不通过
 */
@property(nonatomic,copy)NSString *picStatus;

@end

@interface SkuDTO : BasicDTO

/**
 *  sku编码
 */
@property(nonatomic,copy)NSString* skuNo;
/**
 * ID(类型:int)
 */
@property(nonatomic,strong)NSNumber* Id;
/**
 *  sky名称
 */
@property(nonatomic,copy)NSString* skuName;
/**
 * 库存(类型:int)
 */
@property(nonatomic,strong)NSNumber* skuStock;
/**
 *  排序
 */
@property(nonatomic,copy)NSString* sort;

/**
 *  是否有货(1:有货0:无货)
 */
@property(nonatomic,copy)NSString* showStockFlag;

- (NSMutableDictionary* )getDictFrom:(SkuDTO *)skuDTO;
@end




