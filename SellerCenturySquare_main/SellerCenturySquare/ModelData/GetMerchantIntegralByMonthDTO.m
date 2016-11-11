//
//  GetMerchantIntegralByMonthDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMerchantIntegralByMonthDTO.h"

@implementation GetMerchantIntegralByMonthDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"time"]]) {
                
                self.time = [dictInfo objectForKey:@"time"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]) {
                
                self.memberName = [dictInfo objectForKey:@"memberName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"integralNum"]]) {
                
                NSString *integralStr = [NSString stringWithFormat:@"%@",[dictInfo objectForKey:@"integralNum"]] ;
                
                self.integralNum = [NSNumber numberWithInteger:[integralStr integerValue]];
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
