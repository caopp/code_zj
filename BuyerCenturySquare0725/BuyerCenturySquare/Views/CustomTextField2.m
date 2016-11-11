//
//  CustomTextField2.m
//  BuyerCenturySquare
//
//  Created by Edwin on 15/10/9.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CustomTextField2.h"

@implementation CustomTextField2

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+bounds.size.width - 40, bounds.origin.y+7, 13, 13);
    return inset;
}


- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 0 );
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 0 );
}


-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y+8.5, bounds.size.width, bounds.size.height);//更好理解些
    return inset;
}

@end
