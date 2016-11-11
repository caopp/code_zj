//
//  CPSGoodsDetailsEditSkuView.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSGoodsDetailsEditSkuView.h"

@implementation CPSGoodsDetailsEditSkuView

- (void)awakeFromNib{
    
    //加边框
    self.skuNameLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.skuNameLabel.layer.borderWidth = 0.5f;
    
    //倒角
    self.skuNameLabel.layer.cornerRadius = 3;
}

@end
