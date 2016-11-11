//
//  ChangeExitGoodsAndCancelView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ChangeExitGoodsAndCancelView.h"

@implementation ChangeExitGoodsAndCancelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectCancelExitChangeBtn:(id)sender {
    
    if (self.blockChangeExitGoodsAndCancelView) {
        self.blockChangeExitGoodsAndCancelView(@"0");
    }
}

- (IBAction)selectChangeExitChangeBtn:(id)sender {
    if (self.blockChangeExitGoodsAndCancelView) {
        self.blockChangeExitGoodsAndCancelView (@"1");
    }
}
@end
