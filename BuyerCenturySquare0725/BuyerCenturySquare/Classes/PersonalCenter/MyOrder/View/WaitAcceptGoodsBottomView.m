//
//  WaitAcceptGoodsBottomView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WaitAcceptGoodsBottomView.h"

@implementation WaitAcceptGoodsBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)selectCustomerServiceBtn:(id)sender {
    if (self.blockWaitAcceptGoods) {
        self.blockWaitAcceptGoods(0);
    }
}
- (IBAction)selectExitMoneyBtn:(id)sender {
    if (self.blockWaitAcceptGoods) {
        self.blockWaitAcceptGoods(1);
    }
}

- (IBAction)selectMakeSureAcceptBtn:(id)sender {
    if (self.blockWaitAcceptGoods) {
        self.blockWaitAcceptGoods(2);
    }
}
@end
