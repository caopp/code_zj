//
//  CSPOrderDetailsBottomView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface CSPOrderDetailsBottomView : CSPBaseCustomView

@property (weak, nonatomic) IBOutlet UIView *tipBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIButton *takephoneButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelDeliverGoodsButton;

@property (weak, nonatomic) IBOutlet UIButton *takephoneDeliverGoodsButton;


/**
 *  传值
 */

//取消交易
@property (nonatomic,copy)void (^cancelDeliverGoodsButtonBlock)();
//拍照发货
@property (nonatomic,copy)void (^takephoneDeliverGoodsButtonBlock)();
//修改采购单价格
@property (nonatomic ,copy)void (^changeOrderTotalPrice)();



- (IBAction)takephoneButtonClick:(id)sender;

- (IBAction)cancelButtonClick:(id)sender;

//取消交易
- (IBAction)cancelDeliverGoodsButtonClick:(id)sender;

//拍照发货
- (IBAction)takephoneDeliverGoodsButtonClick:(id)sender;

- (IBAction)cancelTradingClick:(id)sender;
@end
