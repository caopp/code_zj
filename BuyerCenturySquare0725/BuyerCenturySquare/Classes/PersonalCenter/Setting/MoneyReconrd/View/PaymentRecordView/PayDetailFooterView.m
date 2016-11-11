//
//  PayDetailFooterView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PayDetailFooterView.h"

@implementation PayDetailFooterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self.filterView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    [self.detailOneLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self.detailSecondLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];

}


@end
