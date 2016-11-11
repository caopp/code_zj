//
//  CommodityListPropertyDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface CommodityListPropertyDTO : BasicDTO
/**
 *  商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;

/**
 *  商品名称
 */
@property(nonatomic,copy)NSString *goodsName;

/**
 *  商品价格
 */
@property(nonatomic,strong)NSNumber *price;

/**
 *  图片路径
 */
@property(nonatomic,copy)NSString *imgUrl;

/**
 *  发布时间yyyy-MM-dd HH:mm:ss
 */
@property(nonatomic,copy)NSString *sendTime;

/**
 *  第一次上架时间
 */
@property(nonatomic,copy)NSString *firstOnsaleTime;

/**
 *  备注
 */
@property(nonatomic,copy)NSString *remark;

/**
 *  起批数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *batchNumLimit;

/**
 *  商品等级(类型:int)
 */
@property(nonatomic,strong)NSNumber *readLevel;

/**
 *  权限标识(0:无 1:有)
 */
@property(nonatomic,copy)NSString *authFlag;

/**
 *  商品类型0普通商品、1邮费专拍
 */
@property(nonatomic,copy)NSString *goodsType;
@end
