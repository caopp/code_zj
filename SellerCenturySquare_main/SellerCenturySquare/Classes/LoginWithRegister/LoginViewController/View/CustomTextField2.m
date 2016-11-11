//
//  CustomTextField2.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CustomTextField2.h"

@implementation CustomTextField2
-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+bounds.size.width-35, bounds.origin.y+7, 13, 13);
    return inset;
}




@end
