//
//  StayDeliverBtnView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "StayDeliverBtnView.h"

@implementation StayDeliverBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)selelctConfirmationDeliveryBtn:(id)sender {

    if ([self.delegate respondsToSelector:@selector(StayDeliverConfirmation)]) {
        [self.delegate StayDeliverConfirmation];
    }
    
}
@end
