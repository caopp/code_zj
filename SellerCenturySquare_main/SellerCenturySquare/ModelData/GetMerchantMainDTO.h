//
//  GetMerchantMainDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.5	大B商家中心主页接口

#import "BasicDTO.h"

@interface GetMerchantMainDTO : BasicDTO

/**
 *  待付款采购单数(类型:int)
 */
@property(nonatomic,strong)NSNumber *notPayOrderNum;
/**
 *  待发货采购单数(类型:int)
 */
@property(nonatomic,strong)NSNumber *unshippedNum;
/**
 *  待收货采购单数(类型:int)
 */
@property(nonatomic,strong)NSNumber *untakeOrderNum;
/**
 *  退换货数量
 */
@property (nonatomic ,strong) NSNumber *refundOrderNum;

/**
 *  采购单总数(类型:int)
 */
@property(nonatomic,strong)NSNumber *orderNum;
/**
 *  站内信未读数(类型:int)
 */
@property(nonatomic,strong)NSNumber *noticeStationNum;
/**
 *  下载图片的商品数(类型:int)
 */
@property(nonatomic,strong)NSNumber *picNum;
/**
 *  新发布未上架商品未读数(类型:int)
 */
@property(nonatomic,strong)NSNumber *unReadGoodsNum;

/**
 *采购单未读数量
 */

@property(nonatomic,strong)NSNumber *unReadOrderNum;

/**
 *  上架数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *onSaleNum;
/**
 *  新发布数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *sendNum;
/**
 *  下架数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *offSaleNum;
/**
 *  总数(类型:int)
 */
@property(nonatomic,strong)NSNumber *goodsTotalCount;

//小B 总数量
@property (nonatomic ,strong) NSNumber *xbGoodsTotalCount;

//小C 总数量
@property (nonatomic ,strong) NSNumber *xcGoodsTotalCount;


//!待付款订单数-C端
@property(nonatomic ,strong) NSNumber *notPayCOrderNum;
//! 待发货订单数-C端
@property(nonatomic ,strong) NSNumber *unshippedCNum;
//!待收货订单数-C端
@property(nonatomic ,strong) NSNumber *untakeOrderCNum;
//!退换货数量-C端
@property(nonatomic ,strong) NSNumber *refundOrderCNum;
//0 批发 1零售
@property (nonatomic ,strong) NSNumber *channelType;




+ (instancetype)sharedInstance;
@end
