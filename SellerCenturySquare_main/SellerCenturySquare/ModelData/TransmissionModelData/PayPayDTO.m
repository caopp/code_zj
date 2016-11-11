//
//  PayPayDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "PayPayDTO.h"

@implementation PayPayDTO
-(BOOL)getParameterIsLack
{
    if (self.tradeNo == nil) {
        return YES;
    }
    
    if ([self.useBalance isEqualToString:@"0"] && self.balanceAmount == nil) {
        return YES;
    }
    
    if (self.password == nil) {
        
        self.password = @"";
    }
    if (self.payMethod == nil) {
        
        self.payMethod = @"";
    }
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}



@end
