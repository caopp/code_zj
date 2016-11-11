//
//  BottomPaymentAccountsMessageCellTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
//待付款
#import "MyOrderParentTableViewCell.h"

#import "MyOrderParentTableViewCell.h"
@interface BottomPaymentAccountsMessageCellTableViewCell : MyOrderParentTableViewCell
//商品总件数
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumbLab;

@property (nonatomic, strong) GetOrderDTO *recordOrderDto;

@property (weak, nonatomic) IBOutlet UILabel *showTotalTypeLab;


/**
 *  商品实付/应付价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPayPrice;
//采购单总价
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLab;

//采购单状态
@property (weak, nonatomic) IBOutlet UILabel *OrderStateLab;

//修改采购单总价
@property (weak, nonatomic) IBOutlet UIButton *changeOrderTotalBtn;

- (IBAction)selectChangeOrderTotalBtn:(id)sender;

@end
