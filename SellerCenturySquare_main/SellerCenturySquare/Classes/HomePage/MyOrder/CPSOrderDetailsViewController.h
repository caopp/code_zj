//
//  CPSOrderDetailsViewController.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"

/*
 0-订单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
 */

typedef NS_ENUM(NSInteger, OrderStatus) {
    OrderStatusCancelOrder = 0,
    OrderStatusWaitPay,
    OrderStatusWaitDeliverGoods,
    OrderStatusAlreadyShipped,
    OrderStatusTransactionCancel,
    OrderStatusTransactionComplete
};
@protocol CPSOrderDetailsDelegate <NSObject>

/**
 *  修改成功以后 刷洗我的订单列表数据
 *
 *  @param name photo:(拍照) price:(修改价格)
 */
- (void)orderDetailsChangeRequestDataName:(NSString *)name;


@end

@interface CPSOrderDetailsViewController : BaseViewController
//修改完成 或者拍照发货成功以后 需要刷新列表
@property (nonatomic ,assign) id<CPSOrderDetailsDelegate>delegate;

@property(nonatomic,copy)NSString *orderCode;

@property(nonatomic,copy)NSString *goodsNo;

@property(nonatomic,assign)OrderStatus orderStatus;


@end
