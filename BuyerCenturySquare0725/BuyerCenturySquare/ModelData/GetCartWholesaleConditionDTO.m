//
//  GetCartWholesaleConditionDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetCartWholesaleConditionDTO.h"

@implementation GetCartWholesaleConditionDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isSatisfy"]]) {
                
                self.isSatisfy = [dictInfo objectForKey:@"isSatisfy"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumFlag"]]) {
                
                self.batchNumFlag = [dictInfo objectForKey:@"batchNumFlag"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchAmountFlag"]]) {
                
                self.batchAmountFlag = [dictInfo objectForKey:@"batchAmountFlag"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchAmountLimit"]]) {
                
                self.batchAmountLimit = [dictInfo objectForKey:@"batchAmountLimit"];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
