//
//  WindowXibView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WindowXibView.h"

@implementation WindowXibView

-(void)awakeFromNib
{
    [self.setLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    self.lineLabel.backgroundColor = [UIColor colorWithHex:0xc8c7cc alpha:1];

}

@end
