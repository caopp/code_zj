//
//  SeeEextGoodsDetailView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SeeEextGoodsDetailView.h"

@implementation SeeEextGoodsDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectCustomServiceBtn:(id)sender {
    if (self.blockSeeExitChangeDetail) {
        self.blockSeeExitChangeDetail(@"0");
    }
}

- (IBAction)selectSeeExitChangeDetailBtn:(id)sender {
    if (self.blockSeeExitChangeDetail) {
        self.blockSeeExitChangeDetail(@"1");
    }
}
@end
