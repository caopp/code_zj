//
//  MakeSureExitMoneyAndChangeGoodsView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MakeSureExitMoneyAndChangeGoodsView.h"

@implementation MakeSureExitMoneyAndChangeGoodsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectMakeSureExitMoneyChangeGoodsBtn:(id)sender {
    
    if (self.blockMakeSureExitMoneyAndChangeGoodsView) {
        self.blockMakeSureExitMoneyAndChangeGoodsView();
    }
}
@end
