//
//  CustomTextLocationField.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CustomTextLocationField.h"

@implementation CustomTextLocationField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 30 , 0 );
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 30 , 0 );
}


-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y+8.5, bounds.size.width, bounds.size.height);//更好理解些
    return inset;
}

@end
