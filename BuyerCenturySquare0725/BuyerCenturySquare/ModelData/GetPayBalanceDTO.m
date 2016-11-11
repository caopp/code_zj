//
//  GetPayBalanceDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetPayBalanceDTO.h"

@implementation GetPayBalanceDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"availableAmount"]]) {
                
                self.availableAmount = [dictInfo objectForKey:@"availableAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"freezeAmount"]]) {
                
                self.freezeAmount = [dictInfo objectForKey:@"freezeAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                
                self.totalAmount = dictInfo[@"totalAmount"];
                
                
//                NSNumber* price = [dictInfo objectForKey:@"price"];
//                self.price = price.floatValue;

                
            }
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
   }
@end
