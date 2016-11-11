//
//  GetGoodsFeeInfoDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-12.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetGoodsFeeInfoDTO.h"

@implementation GetGoodsFeeInfoDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imgUrl"]]) {
                
                self.imgUrl = [dictInfo objectForKey:@"imgUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"details"]]) {
                
                self.details = [dictInfo objectForKey:@"details"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"detailUrl"]]) {
                
                self.detailUrl = [dictInfo objectForKey:@"detailUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuList"]]) {
                
                self.skuList = [dictInfo objectForKey:@"skuList"];
            }
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
