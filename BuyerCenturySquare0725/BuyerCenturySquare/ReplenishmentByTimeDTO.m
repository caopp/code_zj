//
//  ReplenishmentByTimeDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "ReplenishmentByTimeDTO.h"
#import "ReplenishmentByMerchantDTO.h"
#import "CartAddDTO.h"

@implementation ReplenishmentByTimeDTO

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"data"]]) {
            NSDictionary* goodsListDict = [dictInfo objectForKey:@"data"];
            
            self.goodsList = [NSMutableArray array];
            
            for (NSDictionary* goodsInfoDict in goodsListDict) {
                ReplenishmentGoods* goodsInfo = [[ReplenishmentGoods alloc]initWithDictionary:goodsInfoDict];
                [self.goodsList addObject:goodsInfo];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSArray*)goodsListForAddingCart {
    NSMutableArray* cartAddingList = [NSMutableArray array];
    for (ReplenishmentGoods* goodsInfo in self.goodsList) {
        if (goodsInfo.selected && goodsInfo.totalQuantity > 0) {
            CartAddDTO* cartAddDTO = [[CartAddDTO alloc]initWithReplenishmentItem:goodsInfo];
            [cartAddingList addObject:cartAddDTO];
        }
    }

    return cartAddingList;
}

@end
