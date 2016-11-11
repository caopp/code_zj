//
//  AddShippingAddressView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AddShippingAddressView.h"

@implementation AddShippingAddressView
- (instancetype)init{
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 200, 60);
        self.labelName = label;
        label.text = @"请添加收货地址";
        [self addSubview:label];
        label.center = self.center;
        
        
    }
    return self;
}


@end
