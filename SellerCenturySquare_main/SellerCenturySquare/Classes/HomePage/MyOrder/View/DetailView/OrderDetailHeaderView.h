//
//  OrderDetailHeaderView.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrderDetailDTO.h"//!采购单详情dto

@interface OrderDetailHeaderView : UIView

//!顶部的view
@property (weak, nonatomic) IBOutlet UIView *headerView;

//!顶部原型的view
@property (weak, nonatomic) IBOutlet UIView *whiteCircleView;

//!状态
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

//!订购的商品数量
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;

@property (weak, nonatomic) IBOutlet UIView *priceView;

//!应付、实付 文字
@property (weak, nonatomic) IBOutlet UILabel *payLeftLaebl;

//!应付价格、实付价格
@property (weak, nonatomic) IBOutlet UILabel *shouldPayPriceLabel;

//!运费
@property (weak, nonatomic) IBOutlet UILabel *carriageLabel;

//!期货单/现货单 label
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

//!期货单/现货单 label的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabelWidth;


//!采购单号
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;

//!采购单总价
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;

//!收货人
@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
//!电话号码
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

//!收货地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHight;

//!状态的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusWidth;


//!原交易金额、退款 所在的view高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldTradeAndRefundViewHight;


//!原交易金额(含运费)
@property (weak, nonatomic) IBOutlet UILabel *oldTradeAndCarriageLabel;

//!退款
@property (weak, nonatomic) IBOutlet UILabel *refundLabel;

//!顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHight;

//!客服按钮
@property (weak, nonatomic) IBOutlet UIButton *customBtn;

//!配送方式
@property (weak, nonatomic) IBOutlet UILabel *deliverWayLabel;


//!客服按钮
@property(nonatomic,copy)void(^customBtnClickBlock)();

//!是否是零售订单
@property(nonatomic,assign)BOOL isRetail;


//!批发订单详情的初始化方法
-(void)configData:(GetOrderDetailDTO * )detailDTO;

//!零售订单详情的初始化方法
-(void)configDataInRetail:(GetOrderDetailDTO *)detailDTO;



//!判断是否显示 原交易金额这一行
-(BOOL)showOldPayView:(GetOrderDetailDTO *)detailDTO;
    


@end
