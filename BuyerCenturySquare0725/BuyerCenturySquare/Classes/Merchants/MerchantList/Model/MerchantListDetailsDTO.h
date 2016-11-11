//
//  MerchantListDetailsDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
// !商品列表  详情

#import "BasicDTO.h"

@interface MerchantListDetailsDTO : BasicDTO
/**
 *  id,类型为int
 */
@property(nonatomic,strong)NSNumber *id;

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;

/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;

/**
 *  商家图片路径
 */
@property(nonatomic,copy)NSString *pictureUrl;

/**
 *  商家类别名称
 */
@property(nonatomic,copy)NSString *categoryName;

/**
 *  商品数量,类型为int
 */
@property(nonatomic,strong)NSNumber *goodsNum;

/**
 *  营业状态(0:营业 1:歇业)
 */
@property(nonatomic,copy)NSString *operateStatus;

/**
 *  歇业开始时间（yyyy-MM-dd mm:hh:ss）
 */
@property(nonatomic,copy)NSString *closeStartTime;

/**
 *  歇业结束时间
 */
@property(nonatomic,copy)NSString *closeEndTime;

/**
 *  0:黑名单 1正常
 */
@property(nonatomic,copy)NSString *blacklistFlag;

/**
 *  0正常、1推荐、2上新
 */
@property(nonatomic,copy)NSString *flag;

/**
 *  档口号
 */
@property(nonatomic,copy)NSString *stallNo;

/**
 *  商家状态 (0:开启 1:关闭)
 */
@property(nonatomic,copy)NSString *merchantStatus;

/**
 *  是否收藏：0是，1否
 */
@property(nonatomic,copy)NSString *isFavorite;




@end
