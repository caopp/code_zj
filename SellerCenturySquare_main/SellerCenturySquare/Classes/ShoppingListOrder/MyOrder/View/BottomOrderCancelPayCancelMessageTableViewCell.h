//
//  BottomOrderCancelPayCancelMessageTableViewCell.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/7/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MyOrderParentTableViewCell.h"

@interface BottomOrderCancelPayCancelMessageTableViewCell : MyOrderParentTableViewCell
/**
 *  商品所有数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumbLab;
/**
 *  商品实付/应付价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPayPrice;

/**
 *  付款状态
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;


@end
