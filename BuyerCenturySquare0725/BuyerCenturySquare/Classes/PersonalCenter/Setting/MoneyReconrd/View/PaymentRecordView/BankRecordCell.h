//
//  BankRecordCell.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
// !银行卡转账充值记录

#import <UIKit/UIKit.h>
#import "CreditTransferDTO.h"

@interface BankRecordCell : UITableViewCell

//!记录类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

//!待审核 等状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//!价钱
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

//!银行转账
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

//!时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;


-(void)configInfo:(CreditTransferDTO *)infoDTO;

@end
