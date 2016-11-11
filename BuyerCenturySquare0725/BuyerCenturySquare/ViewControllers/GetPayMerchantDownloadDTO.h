//
//  GetPayMerchantDownloadDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

//3.25	付费下载
#import "BasicDTO.h"

@interface GetPayMerchantDownloadDTO : BasicDTO

/**
 *  会员等级(类型:int)
 */
@property(nonatomic,strong)NSNumber *level;
/**
 *  剩余下载次数(类型:int)
 */
@property(nonatomic,strong)NSNumber *downloadNum;
/**
 *  购买下载数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *buyDownloadQty;
/**
 *  购买下载权限的价格(类型:double)
 */
@property(nonatomic,strong)NSNumber *buyDownloadPrice;
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

/**
 *  已下载标识(1：已下载  0:未下载过)
 */
@property(nonatomic,copy)NSString *downloadFlag;

/**
 *  购买等级（无购买权限时该等级为最低有权限购买的等级）
 */
@property(nonatomic,strong)NSNumber *buyLevel;


@end
