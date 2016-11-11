//
//  PayDetailHeaderView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
// !转账记录查询 页面 的顶部

#import <UIKit/UIKit.h>
#import "CreditTransferDTO.h"

@interface PayDetailHeaderView : UIView

//!“处理状态” 标题
@property (weak, nonatomic) IBOutlet UILabel *stautsTitleLabel;

//!处理状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//!提醒是否入账
@property (weak, nonatomic) IBOutlet UILabel *isInAccoutnLabel;

//!非实时提醒
@property (weak, nonatomic) IBOutlet UILabel *firstAlertLabel;

//!工作时间提醒
@property (weak, nonatomic) IBOutlet UILabel *secondAlertLabel;

//!分割线
@property (weak, nonatomic) IBOutlet UIView *filterView;

-(void)configInfo:(CreditTransferDTO *)transferDTO;

@end
