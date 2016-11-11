//
//  GoodsCollectionByTimeDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/27/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "GoodsCollectionByTimeDTO.h"

@implementation CollectionGoods

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            
            return;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            NSNumber* idValue = [dictInfo objectForKey:@"id"];
            self.id = idValue.integerValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
            self.goodsName = [dictInfo objectForKey:@"goodsName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
            self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
            self.pictureUrl = [dictInfo objectForKey:@"picUrl"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
            self.color = [dictInfo objectForKey:@"color"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            NSNumber* price = [dictInfo objectForKey:@"price"];
            self.price = price.floatValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
            NSNumber* batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            self.batchNumLimit = batchNumLimit.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
            self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
            self.merchantName = [dictInfo objectForKey:@"merchantName"];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end

@implementation GoodsCollectionByTimeDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (!dictInfo) {
            
            return;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
            
            if ([[dictInfo objectForKey:@"list"]  isKindOfClass:[NSArray class]]) {
                self.goodsList = [NSMutableArray array];
                NSDictionary* goodsListDict = [dictInfo objectForKey:@"list"];
                for (NSDictionary* goodsInfoDict in goodsListDict) {
                    CollectionGoods* goodsInfo = [[CollectionGoods alloc]initWithDictionary:goodsInfoDict];
                    [self.goodsList addObject:goodsInfo];
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (NSMutableArray*)selectedGoodsList {
    NSMutableArray* selectedList = [NSMutableArray array];
    for (CollectionGoods* goodsInfo in self.goodsList) {
        if (goodsInfo.selected) {
            [selectedList addObject:goodsInfo];
        }
    }
    
    return selectedList;
}


@end
