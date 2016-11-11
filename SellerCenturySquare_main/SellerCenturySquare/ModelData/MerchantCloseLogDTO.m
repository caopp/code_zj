//
//  MerchantCloseLogDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MerchantCloseLogDTO.h"

@implementation MerchantCloseLogDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id = [dictInfo objectForKey:@"id"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeStartTime"]]) {
                
                self.closeStartTime = [dictInfo objectForKey:@"closeStartTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeEndTime"]]) {
                
                self.closeEndTime = [dictInfo objectForKey:@"closeEndTime"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
