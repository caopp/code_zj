//
//  GetMerchantIntegralLogDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMerchantIntegralLogDTO.h"

@implementation GetMerchantIntegralLogDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"time"]]) {
                
                self.time = [dictInfo objectForKey:@"time"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"integralNum"]]) {
                
                self.integralNum = [dictInfo objectForKey:@"integralNum"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
