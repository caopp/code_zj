//
//  SearchView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    // Drawing code
    [self.leftLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.searchViewTapBlock) {
        
        self.searchViewTapBlock();
        
    }


}


@end
