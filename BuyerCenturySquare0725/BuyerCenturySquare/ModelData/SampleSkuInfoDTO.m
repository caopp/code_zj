//
//  SampleSkuInfoDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SampleSkuInfoDTO.h"

@implementation SampleSkuInfoDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.skuNo = [dictInfo objectForKey:@"skuNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuStock"]]) {
                
                self.skuStock = [dictInfo objectForKey:@"skuStock"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
                
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


@end
