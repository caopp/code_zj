//
//  WaitPaymentBottomView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WaitPaymentBottomView.h"

@implementation WaitPaymentBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    self.exitMoneyBtnWidth.constant =  [[UIScreen mainScreen] bounds].size.width/2;
    
}

//退款
- (IBAction)selecTexitMoneyBtn:(id)sender {
    if (self.blockExitMoney) {
        self.blockExitMoney(1);
        
    }
}

//客服
- (IBAction)selectCustomerServiceBtn:(id)sender {
    if (self.blockExitMoney) {
        self.blockExitMoney(0);
    }
}
@end
