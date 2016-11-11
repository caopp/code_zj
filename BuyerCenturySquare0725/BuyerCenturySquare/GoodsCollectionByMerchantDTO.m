//
//  GoodsCollectionByMerchantDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/27/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "GoodsCollectionByMerchantDTO.h"
#import "GoodsCollectionByTimeDTO.h"

@implementation CollectionMerchant

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            
            return;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
            self.merchantName = [dictInfo objectForKey:@"merchantName"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
            self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsList"]]) {
            NSArray* goodsListDict = [dictInfo objectForKey:@"goodsList"];
            self.goodsList = [NSMutableArray array];
            
            for (NSDictionary* goodsInfoDict in goodsListDict) {
                CollectionGoods* goodsInfo = [[CollectionGoods alloc]initWithDictionary:goodsInfoDict];
                
                goodsInfo.merchantNo = self.merchantNo;
                goodsInfo.merchantName = self.merchantName;
                
                [self.goodsList addObject:goodsInfo];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end

@implementation GoodsCollectionByMerchantDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (!dictInfo) {
            
            return;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
            
            if ([[dictInfo objectForKey:@"list"]  isKindOfClass:[NSArray class]]) {
                self.merchantList = [NSMutableArray array];
                
                NSDictionary* merchantListDict = [dictInfo objectForKey:@"list"];
                for (NSDictionary* merchantInfoDict in merchantListDict) {
                    CollectionMerchant* merchantInfo = [[CollectionMerchant alloc]initWithDictionary:merchantInfoDict];
                    [self.merchantList addObject:merchantInfo];
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end
