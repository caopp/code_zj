//
//  CSPSkuView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPSkuView.h"

@implementation CSPSkuView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    _isSelected = !_isSelected;
    
    if (_isSelected) {
        
        self.backgroundColor = HEX_COLOR(0x000000FF);
        
        self.goodsStateLabel.text = @"有货";
        
    }else{
        
        self.backgroundColor = HEX_COLOR(0xe2e2e2FF);
        
        self.goodsStateLabel.text = @"无货";
    }
    
    self.selectedBlock(_isSelected);
}

@end
