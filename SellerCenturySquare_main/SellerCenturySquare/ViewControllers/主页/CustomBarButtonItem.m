//
//  CustomBarButtonItem.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/25/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CustomBarButtonItem.h"

@implementation CustomBarButtonItem

-(void)awakeFromNib
{
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]};
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.tintColor = HEX_COLOR(0x999999FF);
}

@end
