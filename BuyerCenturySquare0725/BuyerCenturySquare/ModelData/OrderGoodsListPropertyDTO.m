//
//  OrderGoodsListPropertyDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "OrderGoodsListPropertyDTO.h"

@implementation OrderGoodsListPropertyDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderId"]]) {
                
                self.orderId = [dictInfo objectForKey:@"orderId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuAndQty"]]) {
                
                self.skuAndQty = [dictInfo objectForKey:@"skuAndQty"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"displayName"]]) {
                
                self.displayName = [dictInfo objectForKey:@"displayName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalQuantity"]]) {
                
                self.totalQuantity = [dictInfo objectForKey:@"totalQuantity"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"status"]]) {
                
                self.status = [dictInfo objectForKey:@"status"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
