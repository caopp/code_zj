//
//  CSPCustomTextField.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPCustomTextField.h"

@implementation CSPCustomTextField

- (void)awakeFromNib{
    
    //加边框
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.layer.borderWidth = 0.5f;
    
    //倒角
    self.layer.cornerRadius = 3;
}

@end
