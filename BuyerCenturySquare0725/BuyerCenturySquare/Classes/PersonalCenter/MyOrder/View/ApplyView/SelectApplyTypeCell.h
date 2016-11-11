//
//  SelectApplyTypeCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
// !选择退换货类型的cell

#import <UIKit/UIKit.h>
#import "OrderDetailDTO.h"//!订单的dto

@interface SelectApplyTypeCell : UITableViewCell

//!退货退款
@property (weak, nonatomic) IBOutlet UIButton *returnAndRefundBtn;

@property (weak, nonatomic) IBOutlet UILabel *returnAndRefundLabel;

@property (weak, nonatomic) IBOutlet UILabel *returnAndRefundFilterLabel;

//!仅退款
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;

@property (weak, nonatomic) IBOutlet UILabel *refundLabel;

@property (weak, nonatomic) IBOutlet UILabel *refundFilterLabel;

//!换货
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;

@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;

//!设置选择申请类型的颜色
-(void)setLeftTextColor:(NSString *)type;

//!返回选择的类型
@property(nonatomic,copy) void(^changeSelectType)(NSString *);


//!订单信息的dto
@property (weak, nonatomic) OrderDetailDTO* orderDetailInfo;



@end
