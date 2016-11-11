//
//  SkuListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SkuListDTO.h"

@implementation SkuListDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.skuNo = [dictInfo objectForKey:@"skuNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id = [dictInfo objectForKey:@"id"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuName"]]) {
                
                self.skuName = [dictInfo objectForKey:@"skuName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuStock"]]) {
                
                self.skuStock = [dictInfo objectForKey:@"skuStock"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"preFlag"]]) {
                
                self.preFlag = [dictInfo objectForKey:@"preFlag"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"showStockFlag"]]) {
                
                self.showStockFlag = [dictInfo objectForKey:@"showStockFlag"];
            }
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
