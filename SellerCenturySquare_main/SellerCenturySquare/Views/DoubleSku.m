//
//  DoubleCounterSku.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "DoubleSku.h"

@implementation DoubleSku

- (void)setDictFrom:(NSDictionary *)dictInfo {
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

@end
