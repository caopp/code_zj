//
//  OrderAddDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "OrderAddDTO.h"

@implementation OrderAddDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tradeNo"]]) {
                
                self.tradeNo = [dictInfo objectForKey:@"tradeNo"];
            }
        }
    }
    @catch (NSException *exception) {
        
        
    }
    @finally {
        
    }
}
@end
