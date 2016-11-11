//
//  PayDetailHeaderView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PayDetailHeaderView.h"

@implementation PayDetailHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //!改变颜色
    [self.stautsTitleLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    [self.statusLabel setTextColor:[UIColor colorWithHexValue:0x673ab7 alpha:1]];
    
    [self.isInAccoutnLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    
    [self.firstAlertLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];

    [self.secondAlertLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];

    
    [self.filterView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];

    //!先隐藏状态 具体描述
    self.isInAccoutnLabel.hidden = YES;
    [self.statusLabel setText:@""];
    [self.isInAccoutnLabel setText:@""];
    
    
}
-(void)configInfo:(CreditTransferDTO *)transferDTO{

    //!状态 0待审核，1暂未到账，2通过，3未通过
    NSString *statues = transferDTO.auditStatus;
    if ([statues isEqualToString:@"0"]) {//!没有提示
        
        [self.statusLabel setText:@"待核帐"];
        
        self.isInAccoutnLabel.hidden = YES;

        
    }else if ([statues isEqualToString:@"1"]){
        
        [self.statusLabel setText:@"暂未到账"];
        
        self.isInAccoutnLabel.hidden = NO;
        [self.isInAccoutnLabel setText:@"请耐心等待，稍后平台会再次查询您的转账信息！"];
        
    }else if ([statues isEqualToString:@"2"]){//!没有提示
        
        [self.statusLabel setText:@"审核通过"];
        self.isInAccoutnLabel.hidden = YES;

        
    }else if ([statues isEqualToString:@"3"]){
        
        [self.statusLabel setText:@"未通过"];
        self.isInAccoutnLabel.hidden = NO;
        [self.isInAccoutnLabel setText:@"本次审核时间内，未查询到入账记录，如确定已出账，请再次提交。"];
        
        
    }else{
    
        [self.statusLabel setText:@"已删除"];
        self.isInAccoutnLabel.hidden = NO;
    
    }

    
    
    

}


@end
