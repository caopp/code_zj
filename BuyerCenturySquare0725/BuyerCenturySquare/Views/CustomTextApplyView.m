//
//  CustomTextApplyView.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/5/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CustomTextApplyView.h"

@implementation CustomTextApplyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 15 , 0 );
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 15 , 0 );
}

@end
