//
//  MerchantPermissionDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MerchantPermissionDTO : BasicDTO
/**
 *  等级(类型：int)
 */
@property(nonatomic,copy)NSString *level;
/**
 *  店铺置顶
 */
@property(nonatomic,copy)NSString *shopTopFlag;
/**
 *  采购商分级
 */
@property(nonatomic,copy)NSString *customerMgtAuth;
/**
 *  采购商黑名单
 */
@property(nonatomic,copy)NSString *blackList;
/**
 *  图片免费下载(类型：int)
 */
@property(nonatomic,strong)NSNumber *giveDownloadQty;
/**
 * 购买下载数量(类型：int)
 */
@property(nonatomic,strong)NSNumber *buyDownloadQty;
/**
 *  购买下载权限的价格(类型：int)
 */
@property(nonatomic,strong)NSNumber *buyDownloadPrice;
/**
 *  限制采购商下载
 */
@property(nonatomic,copy)NSString *downloadAuthXb;
/**
 *  每月免费上架(类型：int)
 */
@property(nonatomic,copy)NSString *freeSaleQty;
/**
 *  额外付费上架(类型：int)
 */
@property(nonatomic,strong)NSNumber *paySalePrice;
/**
 *  起始积分(类型：double)
 */
@property(nonatomic,strong)NSNumber *startAmount;
/**
 *  结束积分(类型：double)
 */
@property(nonatomic,strong)NSNumber *endAmount;
/**
 *  等级提醒
 */
@property(nonatomic,copy)NSString *warnTip;
@end
