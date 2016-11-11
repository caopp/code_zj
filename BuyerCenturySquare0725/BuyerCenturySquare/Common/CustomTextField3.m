//
//  CustomTextField3.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CustomTextField3.h"

@implementation CustomTextField3
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+bounds.size.width-110, bounds.origin.y+7, 13, 13);
    return inset;
}


@end
