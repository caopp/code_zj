//
//  MyOrderViewController.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

@interface MyOrderViewController : BaseViewController
/**
 *  当前选中的状态 0.全部，1.待付款，2，待发货，3，待收货，4，交易完成，5，采购单取消，6，交易取消 7退换货
 */
@property (nonatomic ,assign) NSInteger currentOrderState;


@property (nonatomic ,assign) NSInteger channelType;

@end
