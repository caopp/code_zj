//
//  CustomBarButtonItem.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/25/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CustomBarButtonItem.h"

@implementation CustomBarButtonItem

- (id)init
{
    self = [super init];
    if (self) {
        

        [self awakeFromNib];
        
    }
    return self;
}

-(void)awakeFromNib
{
    
    
    
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]};
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
//    self.tintColor = HEX_COLOR(0xffffff);
    
//    !不用这个的话，右按钮颜色会变成蓝色
    self.tintColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    
}

@end
