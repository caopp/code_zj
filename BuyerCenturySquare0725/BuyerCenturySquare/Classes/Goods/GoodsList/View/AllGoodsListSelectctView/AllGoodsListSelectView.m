//
//  AllGoodsListSelectView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AllGoodsListSelectView.h"

@implementation AllGoodsListSelectView



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //!设置字体颜色
    
    //!选中
    [self.allBtn setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateSelected];
    [self.canBrowserBtn setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateSelected];

    
    
    //!正常
    [self.allBtn setTitleColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1] forState:UIControlStateNormal];
    [self.canBrowserBtn setTitleColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1] forState:UIControlStateNormal];
    
    
}
//!全部
- (IBAction)allBtnClick:(id)sender {
    
    
    [self changeAllBtnSelected];
    
    if (self.allBtnClickBlock) {
        
        self.allBtnClickBlock();
        
    }
    
    
}
//!我的等级可看
- (IBAction)canBrowserBtnClick:(id)sender {
  
    [self changeCanBrowserBtnSelected];
    
    if (self.canBrowserBtnClickBlock) {
        
        self.canBrowserBtnClickBlock();
        
    }
    
    
}
//!选中“全部”
-(void)changeAllBtnSelected{

    self.allBtn.selected = YES;
    self.canBrowserBtn.selected = NO;
    

    [self.allBtn setBackgroundColor:[UIColor colorWithHexValue:0xffffff alpha:1]];
    [self.canBrowserBtn setBackgroundColor:[UIColor colorWithHexValue:0x333333 alpha:1]];
    
    
}
//!选中“我的等级可看”
-(void)changeCanBrowserBtnSelected{
    
    self.allBtn.selected = NO;
    self.canBrowserBtn.selected = YES;
    
    
    [self.allBtn setBackgroundColor:[UIColor colorWithHexValue:0x333333 alpha:1]];
    [self.canBrowserBtn setBackgroundColor:[UIColor colorWithHexValue:0xffffff alpha:1]];

    
}


@end
