//
//  SkuDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SkuDTO.h"

@implementation SkuDTO

- (NSMutableDictionary* )getDictFrom:(SkuDTO *)skuDTO{
    @try {
        NSMutableDictionary *currentNSDictionary = [[NSMutableDictionary alloc] init];
        if (self && skuDTO) {
            
            if (skuDTO.goodsNo != nil) {
                
                [currentNSDictionary setObject:skuDTO.goodsNo forKey:K_SERVERDATA_ID];
            }
            
            if (skuDTO.price != nil) {
                
                [currentNSDictionary setObject:skuDTO.price forKey:K_SERVERDATA_PRICE];
            }
            
            if (skuDTO.merchantNo != nil) {
                
                [currentNSDictionary setObject:skuDTO.merchantNo forKey:K_SERVERDATA_MERCHANTNO];
            }
            
            if (skuDTO.skuNo != nil) {
                
                [currentNSDictionary setObject:skuDTO.skuNo forKey:K_SERVERDATA_SKUNO];
            }
            
            if (skuDTO.skuName != nil) {
                
                [currentNSDictionary setObject:skuDTO.skuName forKey:K_SERVERDATA_SKUNAME];
            }
            
            if (skuDTO.quantity != nil) {
                
                [currentNSDictionary setObject:skuDTO.quantity forKey:K_SERVERDATA_QUANTITY];
            }
            
            if (skuDTO.type != nil) {
                
                [currentNSDictionary setObject:skuDTO.type forKey:K_SERVERDATA_TYPE];
            }
            
            if (skuDTO.spotQuantity != nil) {
                
                [currentNSDictionary setObject:skuDTO.spotQuantity forKey:K_SERVERDATA_SPOTQUANTITY];
            }
            if (skuDTO.futureQuantity != nil) {
                
                [currentNSDictionary setObject:skuDTO.futureQuantity forKey:K_SERVERDATA_FUTUREQUANTITY];
            }
        }
        
        return currentNSDictionary;

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
                
                self.quantity = [dictInfo objectForKey:@"quantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.skuNo = [dictInfo objectForKey:@"skuNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuName"]]) {
                
                self.skuName = [dictInfo objectForKey:@"skuName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
  }
@end
