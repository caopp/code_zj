//
//  BankRecordCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BankRecordCell.h"

@implementation BankRecordCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.statusLabel setTextColor:[UIColor colorWithHexValue:0x673ab7 alpha:1]];
    
    [self.fromLabel setTextColor:[UIColor colorWithHexValue:0xcfcfcf alpha:1]];
    
    [self.timeLabel setTextColor:[UIColor colorWithHexValue:0xcfcfcf alpha:1]];
    
    [self.moneyLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self.filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
}


-(void)configInfo:(CreditTransferDTO *)infoDTO{

    //!说明
    [self.typeLabel setText:infoDTO.subject];
    
    //!状态 0待核帐，1暂未到账，2通过，3未通过
    self.statusLabel.hidden = NO;
    
    NSString *statues = infoDTO.auditStatus;
    if ([statues isEqualToString:@"0"]) {
        
        [self.statusLabel setText:@"待核帐"];
        
    }else if ([statues isEqualToString:@"1"]){
    
        [self.statusLabel setText:@"暂未到账"];

    }else if ([statues isEqualToString:@"2"]){
    
        [self.statusLabel setText:@"通过"];

        self.statusLabel.hidden = YES;
        [self.moneyLabel setTextColor:[UIColor colorWithHexValue:0x673ab7 alpha:1]];
        
    }else if ([statues isEqualToString:@"3"]){
    
        [self.statusLabel setText:@"未通过"];

    }else{
    
        [self.statusLabel setText:@"已删除"];

    }
    
    //!金额
    [self.moneyLabel setText:[NSString stringWithFormat:@"+￥%.2f",infoDTO.amount]];
    
    //!支付方式
    [self.fromLabel setText:infoDTO.paymethod];
    
    //!时间
    [self.timeLabel setText:infoDTO.createDate];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
