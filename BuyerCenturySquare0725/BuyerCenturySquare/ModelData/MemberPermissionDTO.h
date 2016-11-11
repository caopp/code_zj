//
//  MemberPermissionDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MemberPermissionDTO : BasicDTO

/**
 *  等级1-6（类型 int）
 */
@property(nonatomic,strong)NSNumber *level;

/**
 *  小B会员上月消费金额等级下限（类型 double）
 */
@property(nonatomic,strong)NSNumber *amountLow;

/**
 *  小B会员上月消费金额等级上限（类型 double）
 */
@property(nonatomic,strong)NSNumber *amountUp;

/**
 *  等级预付货款（类型 double）
 */
@property(nonatomic,strong)NSNumber *advancePayment;

/**
 *  3日内商品详情阅读权限0：无；1：有
 */
@property(nonatomic,copy)NSString *goodsBrowse;

/**
 *  3日前商品详情阅读权限0：无；1：有
 */
@property(nonatomic,copy)NSString *goodsBrowse3;

/**
 *  5日前商品详情阅读权限0：无；1：有
 */
@property(nonatomic,copy)NSString *goodsBrowse5;

/**
 *  7日前商品详情阅读权限0：无；1：有
 */
@property(nonatomic,copy)NSString *goodsBrowse7;

/**
 *  10日前商品详情阅读权限0：无；1：有
 */
@property(nonatomic,copy)NSString *goodsBrowse10;

/**
 *  商品收藏权限0：无；1：有
 */
@property(nonatomic,copy)NSString *goodsCollectAuth;

/**
 *  窗口图片查看权限0：无；1：有
 */
@property(nonatomic,copy)NSString *windowPicViewAuth;

/**
 *  商品详情图片查看权限0：无；1：有
 */
@property(nonatomic,copy)NSString *detailPicViewAuth;

/**
 *  商品参考图查看权限0：无；1：有
 */
@property(nonatomic,copy)NSString *referPicViewAuth;

/**
 *  商品图片下载权限0：无；1：有
 */
@property(nonatomic,copy)NSString *downloadAuth;

/**
 *  免费下载商品数量
 */
@property(nonatomic,strong)NSNumber *freeDownloadQty;

/**
 *  购买商品下载数量
 */
@property(nonatomic,strong)NSNumber *buyDownloadQty;

/**
 *  购买商品下载数量的价格
 */
@property(nonatomic,strong)NSNumber *buyDownloadPrice;

/**
 *  商品内容分享权限0：无；1：有
 */
@property(nonatomic,copy)NSString *shareAuth;

/**
 *  优质供应商推荐0：无；1：有
 */
@property(nonatomic,copy)NSString *supplierRecommendAuth;

/**
 *  开店指导0：无；1：有
 */
@property(nonatomic,copy)NSString *openShopInstructionAuth;

/**
 *  买手推荐0：无；1：有
 */
@property(nonatomic,copy)NSString *buyersRecommendAuth;
/**
 *  虚拟商品编码
 */
@property(nonatomic,copy)NSString *goodsNo;
/**
 *  虚拟sku编码
 */
@property(nonatomic,copy)NSString *skuNo;

@end
