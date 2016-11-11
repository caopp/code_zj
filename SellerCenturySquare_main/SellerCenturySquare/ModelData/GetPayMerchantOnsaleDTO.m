//
//  GetPayMerchantOnsaleDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetPayMerchantOnsaleDTO.h"

@implementation GetPayMerchantOnsaleDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"level"]]) {
                
                self.level = [dictInfo objectForKey:@"level"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"onSaleNum"]]) {
                
                self.onSaleNum = [dictInfo objectForKey:@"onSaleNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"paySalePrice"]]) {
                
                self.paySalePrice = [dictInfo objectForKey:@"paySalePrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"authFlag"]]) {
                
                self.authFlag = [dictInfo objectForKey:@"authFlag"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.skuNo = [dictInfo objectForKey:@"skuNo"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end
