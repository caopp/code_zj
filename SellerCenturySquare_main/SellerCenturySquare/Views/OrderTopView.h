//
//  OrderTopView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

@interface OrderTopView : CSPBaseCustomView

@property (weak, nonatomic) IBOutlet UILabel *nameWithPhoneNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *waitPaymentNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *waitPaymentButton;

@property (weak, nonatomic) IBOutlet UILabel *waitDeliverGoodsNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *waitDeliverGoodsButton;

@property (weak, nonatomic) IBOutlet UILabel *waitGoodsReceiptNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *waitGoodsReceiptButton;

@property (weak, nonatomic) IBOutlet UIButton *allOrderNumButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;




@property (nonatomic,copy)void (^waitPaymentButtonBlock)();

@property (nonatomic,copy)void (^waitDeliverGoodsButtonBlock)();

@property (nonatomic,copy)void (^waitGoodsReceiptButtonBlock)();

@property (nonatomic,copy)void (^contactCustomerServiceBlock)();
@property (nonatomic,copy)void (^allOrderButtonBlock)();

- (void)setAllOrderAmount:(NSInteger)orderAmount;

- (IBAction)waitPaymentButtonClick:(id)sender;

- (IBAction)waitDeliverGoodsButtonClick:(id)sender;

- (IBAction)waitGoodsReceiptButtonClick:(id)sender;

- (IBAction)contactCustomerServiceClick:(id)sender;
@end
