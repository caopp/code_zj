//
//  CSPCustomSkuLabel.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPCustomSkuLabel.h"

@implementation CSPCustomSkuLabel

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //加边框
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        self.layer.borderWidth = 0.5f;
        
        //倒角
        self.layer.cornerRadius = 3;
        
        self.textColor = HEX_COLOR(0x999999FF);
        
        self.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
        
        self.textAlignment = NSTextAlignmentCenter;
        
        return self;
        
    }else{
        return nil;
    }
}

@end
