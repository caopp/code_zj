//
//  PaymentRecordHeaderView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentRecordHeaderView : UIView

//!预付货款余额
@property (weak, nonatomic) IBOutlet UILabel *payTitleLabel;

//!钱数
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

//!底部灰色view
@property (weak, nonatomic) IBOutlet UIView *grayView;

//!充值按钮
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;

//!充值
@property(nonatomic,copy) void (^accountBtnClickBlock)();


@end
