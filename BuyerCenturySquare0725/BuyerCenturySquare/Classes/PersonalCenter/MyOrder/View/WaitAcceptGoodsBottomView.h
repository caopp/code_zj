//
//  WaitAcceptGoodsBottomView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitAcceptGoodsBottomView : UIView
//type 0 客服 1退换货 2 确认收货
@property (nonatomic ,copy)void (^blockWaitAcceptGoods)(NSInteger type);
//客服
@property (weak, nonatomic) IBOutlet UIButton *customerServiceBtn;
//退换货
@property (weak, nonatomic) IBOutlet UIButton *exitMoneyBtn;
//确认收货
@property (weak, nonatomic) IBOutlet UIButton *makeSureAcceptBtn;

- (IBAction)selectExitMoneyBtn:(id)sender;

- (IBAction)selectCustomerServiceBtn:(id)sender;
- (IBAction)selectMakeSureAcceptBtn:(id)sender;

@end
