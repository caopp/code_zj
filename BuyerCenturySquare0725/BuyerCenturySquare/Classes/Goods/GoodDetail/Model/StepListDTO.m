//
//  StepListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "StepListDTO.h"
@implementation StepListDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            
            self.price = [dictInfo objectForKey:@"price"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            
            self.Id = [dictInfo objectForKey:@"id"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"minNum"]]) {
            
            self.minNum = [dictInfo objectForKey:@"minNum"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"maxNum"]]) {
            
            self.maxNum = [dictInfo objectForKey:@"maxNum"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
            
            self.sort = [dictInfo objectForKey:@"sort"];
        }
    }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
