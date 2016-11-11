//
//  PayDownloadDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface PayDownloadDTO : BasicDTO
/**
 *  会员等级(类型 int)
 */
@property(nonatomic,strong)NSNumber *level;

/**
 *  剩余下载次数(类型 int)
 */
@property(nonatomic,strong)NSNumber *downloadNum;

/**
 *  购买下载数量(类型 int)（-1为无权限）
 */
@property(nonatomic,strong)NSNumber *buyDownloadQty;

/**
 *  购买下载权限的价格(类型 double)
 */
@property(nonatomic,strong)NSNumber *buyDownloadPrice;

/**
 *  权限标识
 */
@property(nonatomic,copy)NSString *authFlag;
/**
 *  goodsNo
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  skuNo
 */
@property(nonatomic,copy)NSString *skuNo;

//已下载标识 1:已下载 0:未下载过
@property(nonatomic,copy)NSString *downloadFlag;

//购买等级（无购买权限时该等级为最低有权限购买的等级 1-6 ）
@property(nonatomic,strong)NSNumber*buyLevel;

@end
