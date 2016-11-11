//
//  OrderListPropertyDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "OrderListPropertyDTO.h"

@implementation OrderListPropertyDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderId"]]) {
                
                self.orderId = [dictInfo objectForKey:@"orderId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmoount"]]) {
                
                self.totalAmoount = [dictInfo objectForKey:@"totalAmoount"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"dFee"]]) {
                
                self.dFee = [dictInfo objectForKey:@"dFee"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"status"]]) {
                
                self.status = [dictInfo objectForKey:@"status"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalQty"]]) {
                
                self.totalQty = [dictInfo objectForKey:@"totalQty"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
