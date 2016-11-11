//
//  CSPOrderInfoTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
@interface CSPOrderInfoTableViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *waitPaymentNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *waitPaymentButton;

@property (weak, nonatomic) IBOutlet UILabel *waitDeliverGoodsNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *waitDeliverGoodsButton;

@property (weak, nonatomic) IBOutlet UILabel *waitGoodsReceiptNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *waitGoodsReceiptButton;

@property (weak, nonatomic) IBOutlet UILabel *allOrderNumLabel;


//货单状态（现/期）
@property (weak, nonatomic) IBOutlet UILabel *goodsTypeLabel;
//付款状态
@property (weak, nonatomic) IBOutlet UILabel *tradingStateLabel;

//商品总数量
@property (weak, nonatomic) IBOutlet UILabel *totalGoodsNumLabel;
@property (nonatomic, strong) NSString *totalGoodsNumText;

//采购单总价格
@property (weak, nonatomic) IBOutlet UILabel *TotalOrderPriceLabel;
@property (nonatomic ,strong) NSString *totalOrderPriceText;

//应付金额
@property (weak, nonatomic) IBOutlet UILabel *shouldPayLabel;
@property (nonatomic ,strong) NSString *shouldPayText;

//修改金额
@property (weak, nonatomic) IBOutlet UILabel *tipModifyOrTakePhoneLabel;

//修改按钮
@property (weak, nonatomic) IBOutlet UIButton *modifyOrTakePhoneButton;
/**
 *  点击修改或者录入快递单发货
 */
@property (nonatomic,copy)void (^modifyOrTakePhoneButtonBlock)();
/**
 *  修改按钮的
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modifyOrTakePhoneButtonWitdh;

//修改按钮的点击事件
- (IBAction)modifyOrTakePhoneButtonClick:(id)sender;


/**
 *  拍摄快递单发货
 */

@property (nonatomic,copy)void (^selectshootCouriersingleDeliveryBtnBlock)();

@property (weak, nonatomic) IBOutlet UIButton *shootCouriersingleDeliveryBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shootCouriersingleDeliveryBtnWitdh;
- (IBAction)selectshootCouriersingleDeliveryBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *tagliaLabel;

//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *swearImageView;

//商品名称
@property (weak, nonatomic) IBOutlet UILabel *swearTitleLabel;
@property (nonatomic ,strong) NSString *swearTitleText;

//颜色
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (nonatomic ,strong) NSString *colorText;

//商品单价
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) NSString *priceText;

//商品数量
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic ,strong)NSString *amountText;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *sizeLabels;
- (void)changeView;
- (void)normalView;

@end
