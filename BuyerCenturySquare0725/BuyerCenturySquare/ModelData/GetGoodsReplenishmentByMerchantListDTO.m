//
//  GetGoodsReplenishmentByMerchantListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-26.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetGoodsReplenishmentByMerchantListDTO.h"


@implementation GetGoodsReplenishmentByMerchantListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.getGoodsReplenishmentByMerchantDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:dictInfo[K_SERVERDATA_DATA]]) {
                
                self.getGoodsReplenishmentByMerchantDTOList = dictInfo[K_SERVERDATA_DATA];
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
