//
//  WaitPaymentBtnView.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/4/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WaitPaymentBtnView.h"

@implementation WaitPaymentBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectCancelOrderBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(waitPaymentConfirm)]) {
        [self.delegate waitPaymentCancelOrder];
    }
    ;
}


- (IBAction)selectPaymentBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(waitPaymentConfirm)]) {
        [self.delegate waitPaymentConfirm];
        
    }
}

- (IBAction)selectCustomServerBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(waitPaymentCustomService)]) {
        [self.delegate waitPaymentCustomService];
        
    }
}
@end
