//
//  InMerchantGoodsView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "InMerchantGoodsView.h"

@implementation InMerchantGoodsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;

    self.goodsImageView.clipsToBounds = YES;

    

    
}

- (IBAction)selectBtnClick:(id)sender {
    
    
    if (self.selectBlock) {
        
        self.selectBlock();
        
    }
    
    
}





@end
