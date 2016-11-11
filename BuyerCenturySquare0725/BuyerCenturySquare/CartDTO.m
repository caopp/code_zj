//
//  CartDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CartDTO.h"

@implementation CartGoodsDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
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
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
                
                self.quantity = [dictInfo objectForKey:@"quantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"samplePrice"]]) {
                
                self.samplePrice = [dictInfo objectForKey:@"samplePrice"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsStatus"]]) {
                
                self.goodsStatus = [dictInfo objectForKey:@"goodsStatus"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartType"]]) {
                
                self.cartType = [dictInfo objectForKey:@"cartType"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuList"]]) {
                
                self.skuDTOList = [dictInfo objectForKey:@"skuList"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stepPriceList"]]) {
                
                self.stepPriceDTOList = [dictInfo objectForKey:@"stepPriceList"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
  }


@end

@implementation CartDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartGoodsList"]]) {
                
                self.cartGoodsDTOList = [dictInfo objectForKey:@"cartGoodsList"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    }

@end
