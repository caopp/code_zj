//
//  GetGoodsReplenishmentByMerchantDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-26.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetGoodsReplenishmentByMerchantDTO.h"

@implementation GetGoodsReplenishmentByMerchantDTO

- (id)init{
    self = [super init];
    if (self) {
        self.restockedDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsList"]]) {
                
                self.restockedDTOList = [dictInfo objectForKey:@"goodsList"];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
