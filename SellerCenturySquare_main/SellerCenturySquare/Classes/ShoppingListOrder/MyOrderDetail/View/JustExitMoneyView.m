//
//  JustExitMoneyView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "JustExitMoneyView.h"

@implementation JustExitMoneyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectPhotoSendGoodsBtn:(id)sender {
    
    if (self.blockJustExitMoneyView) {
        self.blockJustExitMoneyView(@"0");
    }
}

- (IBAction)selectEntryExpressSingleBtn:(id)sender {
    if (self.blockJustExitMoneyView) {
        self.blockJustExitMoneyView(@"1");
    }
}

- (IBAction)selectMakeSureExitMoneyBtn:(id)sender {
    if (self.blockJustExitMoneyView) {
        self.blockJustExitMoneyView(@"2");
        
    }
}
@end
