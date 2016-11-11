//
//  MyOrderDetailViewController.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^blockDetailRequest)();

@interface MyOrderDetailViewController : BaseViewController

@property (nonatomic ,strong) NSString *orderCode;

//采购单状态0-采购单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
@property (nonatomic ,assign) NSInteger orderState;

//确认收货，取消订单， 付款 刷新数据
@property (nonatomic ,copy) blockDetailRequest blockdetail;

//是否是从聊天进来
@property (nonatomic ,assign) BOOL isChat;

@property (nonatomic,copy)void (^blockMyOrderDetailChatMessage)(NSDictionary *dict);


@end
