//
//  orderGoodsItemDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "OrderGoodsItemDTO.h"

@implementation OrderGoodsItemDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartType"]]) {
                
                self.cartType = [dictInfo objectForKey:@"cartType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
                
                self.quantity = [dictInfo objectForKey:@"quantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sizes"]]) {
                
                self.sizes = [dictInfo objectForKey:@"sizes"];
            }
            
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
