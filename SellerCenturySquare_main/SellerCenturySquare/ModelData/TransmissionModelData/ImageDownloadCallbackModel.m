//
//  ImageDownloadCallbackModel.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ImageDownloadCallbackModel.h"

@implementation ImageDownloadCallbackModel

-(BOOL)getParameterIsLack
{
    if (self.goodsNo == nil || self.picType == nil){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

@end
