//
//  StatisticsGetIntegralListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "StatisticsGetIntegralListDTO.h"

@implementation StatisticsGetIntegralListDTO


-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"time"]]) {
                
                self.time = [dictInfo objectForKey:@"time"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderNo"]]) {
                
                self.orderNo = [dictInfo objectForKey:@"orderNo"];
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
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
