//
//  CustomTextField4.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/1/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CustomTextField4.h"

@implementation CustomTextField4

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
//        self.deleteButton.hidden = YES;
        
    }
    return  self;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+bounds.size.width-40, bounds.origin.y+7, 13, 13);
    return inset;
}


- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 6 );
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 8 );
}


-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y+23, bounds.size.width, bounds.size.height);//更好理解些
    return inset;
}




@end
