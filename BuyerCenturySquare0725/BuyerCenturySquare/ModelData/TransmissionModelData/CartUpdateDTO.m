//
//  CartUpdateDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CartUpdateDTO.h"

@implementation CartUpdateDTO

-(BOOL)getParameterIsLack
{
    if (self.goodsNo == nil || self.skuNo == nil || self.skuName == nil || [self.totalQuantityOnGoods intValue] == 0){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

@end
