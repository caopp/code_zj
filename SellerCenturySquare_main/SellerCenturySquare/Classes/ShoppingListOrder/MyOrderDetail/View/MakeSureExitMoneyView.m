//
//  MakeSureExitMoneyView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/27.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MakeSureExitMoneyView.h"

@implementation MakeSureExitMoneyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectMakeSureExitMoneyBtn:(id)sender {
    
    if (self.blockMakeSureExitMoneyView) {
        self.blockMakeSureExitMoneyView();
        
    }
}
@end
