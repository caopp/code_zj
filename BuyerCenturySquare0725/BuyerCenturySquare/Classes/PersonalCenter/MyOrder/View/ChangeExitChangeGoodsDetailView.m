//
//  ChangeExitChangeGoodsDetailView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ChangeExitChangeGoodsDetailView.h"

@implementation ChangeExitChangeGoodsDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectChangeExitChangeBtn:(id)sender {
    
    if (self.blockChangeExitChangeGoodsDetailView) {
        self.blockChangeExitChangeGoodsDetailView();
    }
}
@end
