//
//  PayMulitiConfirmPayDTO.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PayMulitiConfirmPayDTO.h"

@implementation PayMulitiConfirmPayDTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (!dictInfo) {
            return;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tradeNo"]]) {

            self.tradeNo = [dictInfo objectForKey:@"tradeNo"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
            self.tradeNo = [dictInfo objectForKey:@"totalAmount"];
        }

    
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
