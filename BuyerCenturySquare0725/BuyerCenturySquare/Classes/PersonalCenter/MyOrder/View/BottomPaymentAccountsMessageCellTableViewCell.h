//
//  BottomPaymentAccountsMessageCellTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

#import "MyOrderParentTableViewCell.h"
@interface BottomPaymentAccountsMessageCellTableViewCell : MyOrderParentTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalNumbLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *OrderStateLab;
@property (weak, nonatomic) IBOutlet UIButton *orderCancelBtn;

@end
