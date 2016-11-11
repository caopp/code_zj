//
//  wholesaleConditionDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "WholeSaleConditionDTO.h"

@implementation SaleMerchantCondition

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isSatisfy"]]) {
            self.isSatisfy = [dictInfo objectForKey:@"isSatisfy"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
            self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumFlag"]]) {
            self.batchNumFlag = [dictInfo objectForKey:@"batchNumFlag"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
            if ([[dictInfo objectForKey:@"batchNumLimit"] isKindOfClass:[NSString class]]) {
                self.batchNumLimit = 0;
            } else {
                NSNumber* batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
                self.batchNumLimit = batchNumLimit.integerValue;
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchAmountFlag"]]) {
            self.batchAmountFlag = [dictInfo objectForKey:@"batchAmountFlag"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchAmountLimit"]]) {
            if ([[dictInfo objectForKey:@"batchAmountLimit"] isKindOfClass:[NSString class]]) {
                self.batchAmountLimit = 0.0;
            } else {
                NSNumber* batchAmountLimit = [dictInfo objectForKey:@"batchAmountLimit"];
                self.batchAmountLimit = batchAmountLimit.floatValue;
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (BOOL)isMerchantSatisfy {
    if ([self.isSatisfy isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

@end

@implementation WholeSaleConditionDTO

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"data"]]) {
            self.merchantList = [NSMutableArray array];
            
            NSArray* merchantDictList = [dictInfo objectForKey:@"data"];
            for (NSDictionary* merchantInfoDict in merchantDictList) {
                SaleMerchantCondition* merchantCondition = [[SaleMerchantCondition alloc]initWithDictionary:merchantInfoDict];
                [self.merchantList addObject:merchantCondition];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (BOOL)isAllMerchantsSatisfy {
    for (SaleMerchantCondition* merchantConditon in self.merchantList) {
        if ([merchantConditon isMerchantSatisfy]) {
            continue;
        } else {
            return NO;
        }
    }
    
    return YES;
}

@end
