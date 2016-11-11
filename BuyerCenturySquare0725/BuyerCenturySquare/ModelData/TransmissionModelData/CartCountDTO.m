//
//  CartCountDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-24.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CartCountDTO.h"

@implementation CartCountDTO

- (NSMutableDictionary* )getDictFrom:(CartCountDTO *)cartCountDTO{
    
    NSMutableDictionary *currentNSDictionary = [[NSMutableDictionary alloc] init];
    if (self && cartCountDTO) {
        
        if ([cartCountDTO.merchantNo isEqualToString:@""] == NO &&  [cartCountDTO.quantity intValue] == 0 &&  [cartCountDTO.amount doubleValue] == 0.0f) {
            
            return nil;
        }
        [currentNSDictionary setObject:cartCountDTO.merchantNo forKey:@"merchantNo"];
        [currentNSDictionary setObject:cartCountDTO.quantity forKey:@"quantity"];
        [currentNSDictionary setObject:cartCountDTO.amount forKey:@"amount"];
    
    }
    
    return currentNSDictionary;
}

@end
