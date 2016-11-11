//
//  PaymentRecordHeaderView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PaymentRecordHeaderView.h"

@implementation PaymentRecordHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    //!改变颜色：
    [self.payTitleLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    [self.grayView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    self.accountBtn.layer.masksToBounds = YES;
    self.accountBtn.layer.cornerRadius = 2;
    
    
}
//!充值
- (IBAction)accountBtnClick:(id)sender {
    
    if (self.accountBtnClickBlock) {
        
        self.accountBtnClickBlock();
        
    }
    
    
}


@end
