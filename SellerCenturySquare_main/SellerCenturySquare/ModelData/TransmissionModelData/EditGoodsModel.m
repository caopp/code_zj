//
//  EditGoodsModel.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "EditGoodsModel.h"

@implementation EditGoodsModel

-(BOOL)getParameterIsLack
{
    if (self.goodsStatus == nil){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

@end
