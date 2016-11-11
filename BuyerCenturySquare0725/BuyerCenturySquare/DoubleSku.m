//
//  DoubleCounterSku.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "DoubleSku.h"
#import "SingleSku.h"

@implementation DoubleSku

- (id)initWithSingleSku:(SingleSku *)singleSku {
    @try {
        self = [super init];
        
        if (self) {
            self.skuNo = singleSku.skuNo;
            self.skuName = singleSku.skuName;
            self.spotValue = singleSku.value;
        }
        
        return self;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
   
}

- (void)setDictFrom:(NSDictionary *)dictInfo {
    
    @try {
        [super setDictFrom:dictInfo];
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"spotQuantity"]]) {
            
            NSNumber* spotValue = [dictInfo objectForKey:@"spotQuantity"];
            self.spotValue = spotValue.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"futureQuantity"]]) {
            
            NSNumber* futureValue = [dictInfo objectForKey:@"futureQuantity"];
            self.futureValue = futureValue.integerValue;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
