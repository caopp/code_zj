//
//  BottomReceipAccountsMessageCellTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

@interface BottomReceipAccountsMessageCellTableViewCell : MyOrderParentTableViewCell
/**
 *  商品所有数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumbLab;
/**
 *  商品所有的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPriceLab;
/**
 *  取消采购单
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;
/**
 *  确认收货
 */
@property (weak, nonatomic) IBOutlet UIButton *confirmGoodsBtn;
/**
 *  付款状态
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;

/**
 *  点击取消采购单
 *
 *  @param sender
 */
- (IBAction)selectCancelOrderClickBtn:(id)sender;
/**
 *   点击确认收货
 *
 *  @param sender
 */
- (IBAction)selectconfirmGoodsClickBtn:(id)sender;

@end
