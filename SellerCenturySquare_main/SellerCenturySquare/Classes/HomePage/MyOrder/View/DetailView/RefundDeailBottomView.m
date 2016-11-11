//
//  RefundDeailBottomView.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/5/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "RefundDeailBottomView.h"

@implementation RefundDeailBottomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self setBackgroundColor:[UIColor colorWithHex:0x1a1a1a]];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //!查看退换货详情
    if (self.toSeeRefundDeatilBlock) {
        
        self.toSeeRefundDeatilBlock();
    }
    
    
    
}



@end
