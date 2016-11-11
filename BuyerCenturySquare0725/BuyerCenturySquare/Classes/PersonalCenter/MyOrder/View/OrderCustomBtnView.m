//
//  OrderCustomBtnView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/6/3.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderCustomBtnView.h"

@implementation OrderCustomBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectCustomBtn:(id)sender {
    if (self.blockOrderCustomBtnView) {
        self.blockOrderCustomBtnView();
    }
}

- (IBAction)selectlateCustomBtn:(id)sender {
    if (self.blockOrderCustomBtnView) {
        self.blockOrderCustomBtnView();
    }
}
@end
