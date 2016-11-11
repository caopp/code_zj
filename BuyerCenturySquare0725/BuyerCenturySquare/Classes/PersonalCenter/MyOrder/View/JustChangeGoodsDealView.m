//
//  JustChangeGoodsDealView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "JustChangeGoodsDealView.h"

@implementation JustChangeGoodsDealView



- (IBAction)selectCustomerServiceBtn:(id)sender {
    if (self.blockJustChangeGoodsDealView) {
        self.blockJustChangeGoodsDealView(0);
    }
}
- (IBAction)selectExitMoneyBtn:(id)sender {
    if (self.blockJustChangeGoodsDealView) {
        self.blockJustChangeGoodsDealView(1);
    }
}

- (IBAction)selectMakeSureAcceptBtn:(id)sender {
    if (self.blockJustChangeGoodsDealView) {
        self.blockJustChangeGoodsDealView(2);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
