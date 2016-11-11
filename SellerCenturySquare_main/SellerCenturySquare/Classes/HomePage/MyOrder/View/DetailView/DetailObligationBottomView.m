//
//  DetailObligationBottomView.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "DetailObligationBottomView.h"

@implementation DetailObligationBottomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    [self setBackgroundColor:[UIColor colorWithHex:0x1a1a1a]];

}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //!修改价钱
    if (self.changePriceBlock) {
        
        self.changePriceBlock();
    }
    
    
    
}

@end
