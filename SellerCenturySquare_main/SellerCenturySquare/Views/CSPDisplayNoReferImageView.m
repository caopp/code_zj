//
//  CSPDisplayNoReferImageView.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPDisplayNoReferImageView.h"

@implementation CSPDisplayNoReferImageView

- (void)awakeFromNib{
    
    UILabel *label = (UILabel *)[self viewWithTag:101];
    
    label.textColor = HEX_COLOR(0x999999FF);
}

@end
