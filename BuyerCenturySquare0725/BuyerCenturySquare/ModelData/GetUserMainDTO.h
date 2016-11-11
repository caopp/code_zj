//
//  GetUserMainDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"


@interface GetUserMainDTO : BasicDTO

/**
 *  待付款采购单数(类型 int)
 */
@property(nonatomic,strong)NSNumber *notPayOrderNum;

/**
 *  待发货采购单数(类型 int)
 */
@property(nonatomic,strong)NSNumber *unshippedNum;

/**
 *  待收货采购单数(类型 int)
 */
@property(nonatomic,strong)NSNumber *untakeOrderNum;

/**
 *  采购单总数(类型 int)
 */
@property(nonatomic,strong)NSNumber *orderNum;

/**
 *  站内信未读数(类型 int)
 */
@property(nonatomic,strong)NSNumber *noticeStationNum;
/**
 *  下载图片的商品数(类型 int)
 */
@property(nonatomic,strong)NSNumber *picNum;

/**
 *  补货商品数(类型 int)
 */
@property(nonatomic,strong)NSNumber *replenishNum;

/**
 *  订购过的商家数(类型 int)
 */
@property(nonatomic,strong)NSNumber *subscribeNum;

@end
