//
//  IntegralDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "IntegralDTO.h"

@implementation IntegralDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"time"]]) {
                
                self.time = [dictInfo objectForKey:@"time"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"integralNum"]]) {
                
                self.integralNum = [dictInfo objectForKey:@"integralNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderId"]]) {
                
                self.orderId = [dictInfo objectForKey:@"orderId"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
                
                self.orderCode = [dictInfo objectForKey:@"orderCode"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
