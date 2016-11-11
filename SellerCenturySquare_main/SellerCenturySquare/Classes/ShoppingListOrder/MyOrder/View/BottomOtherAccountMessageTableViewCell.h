//
//  BottomOtherAccountMessageTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

/**
 *  待收货，交易完成，采购单取消，交易完成
 */
@interface BottomOtherAccountMessageTableViewCell : MyOrderParentTableViewCell
/**
 *  商品所有数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumbLab;
/**
 *  商品实付/应付价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPayPrice;

//订单总价
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLab;
/**
 *  付款状态
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;

//! 显示订单类型：0 采购单总价 1，订单总价
@property (weak, nonatomic) IBOutlet UILabel *showTotalPriceTypeLab;

@end
