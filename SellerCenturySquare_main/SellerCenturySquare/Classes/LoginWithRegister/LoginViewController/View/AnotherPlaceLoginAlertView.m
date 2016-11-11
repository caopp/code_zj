//
//  AnotherPlaceLoginAlertView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AnotherPlaceLoginAlertView.h"

@implementation AnotherPlaceLoginAlertView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.alertCenterView.layer.cornerRadius = 5;
    self.alertCenterView.layer.masksToBounds = YES;
    
    
}


- (IBAction)loginBtnClick:(id)sender {
    
    
    [self removeFromSuperview];
    
    if (self.reloginBtnBlock) {
        
        self.reloginBtnBlock();
    }
    
    
}


@end
