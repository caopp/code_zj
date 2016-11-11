//
//  CustomPTextView.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/4/5.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CustomPTextView.h"

@implementation CustomPTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 60 , 0 );
}
-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 60 , 0 );
}


@end
