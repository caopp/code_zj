//
//  SaveGoodsRecommendModel.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SaveGoodsRecommendModel.h"

@implementation SaveGoodsRecommendModel

-(BOOL)getParameterIsLack
{
    if (self.goodsNum == nil  || self.goodsNos == nil || self.memberNos == nil ){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

@end
