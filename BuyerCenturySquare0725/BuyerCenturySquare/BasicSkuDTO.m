//
//  BasicSkuDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/27/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicSkuDTO.h"

@implementation BasicSkuDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.skuNo = [dictInfo objectForKey:@"skuNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuName"]]) {
                
                self.skuName = [dictInfo objectForKey:@"skuName"];
                
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                NSNumber* sort = [dictInfo objectForKey:@"sort"];
                self.sort = sort.integerValue;
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
