//
//  SingleCounterSku.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/28/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "SingleSku.h"

@implementation SingleSku

- (void)setDictFrom:(NSDictionary *)dictInfo {
    [super setDictFrom:dictInfo];

    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"value"]]) {

        NSNumber* value = [dictInfo objectForKey:@"value"];
        self.value = value.integerValue;
    }
}

@end
