//
//  IMGoodsInfoDTO.m
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "IMGoodsInfoDTO.h"
#import "ReplenishmentByMerchantDTO.h"
#import "DoubleSku.h"
#import "StepListDTO.h"

@implementation IMGoodsInfoDTO

- (void)dealloc {

    self.merchantName = nil;
    self.sessionType = 0;
    self.goodColor = nil;
    self.goodPic = nil;
    self.isBuyModel = NO;
    self.samplePrice = nil;
    self.batchNumLimit = nil;
}

- (id)initWithReplenishmentInfo:(ReplenishmentGoods *)replenishmentInfo {
    
    self = [super init];
    if (self) {
        self.merchantNo = replenishmentInfo.merchantNo;
        
        self.goodsNo = replenishmentInfo.goodsNo;
        
        self.cartType = @"0";
        
        self.price = [NSNumber numberWithFloat:[replenishmentInfo stepPriceForCurrentQuantity]];
        
        self.totalQuantity = [NSNumber numberWithInteger:[replenishmentInfo totalQuantity]];
        
        self.skuList = [replenishmentInfo doubleSkuList];
        
        self.merchantName = replenishmentInfo.merchantName;
        self.sessionType = 1;
        self.goodColor = replenishmentInfo.color;
        self.batchNumLimit = [NSNumber numberWithInteger:replenishmentInfo.batchNumLimit];
        self.goodPic = replenishmentInfo.pictureUrl;
        self.isBuyModel = NO;
        self.goodsWillNo = [NSString stringWithFormat:@"%@",replenishmentInfo.goodsWillNo];
        
        self.stepPriceList = replenishmentInfo.stepPriceDTOList;
    }

    return self;
}

- (CartAddDTO *)transformToCartAddDTO {
    
    return [[CartAddDTO alloc] initWithIMGoodsInfoDTO:self];
}

- (CartAddDTO *)transformToModelCartAddDTO {
    
    return [[CartAddDTO alloc] initWithIMGoodsInfoDTO2Model:self];
}

- (NSMutableArray*)skuDictionaryList {
    NSMutableArray* skuDictList = [NSMutableArray array];
    
    for (DoubleSku * skuInfo in self.skuList) {
        if (skuInfo.spotValue > 0 || skuInfo.futureValue > 0) {
            NSMutableDictionary* skuDictionary = [NSMutableDictionary dictionary];
            [skuDictionary setObject:skuInfo.skuNo forKey:@"skuNo"];
            [skuDictionary setObject:skuInfo.skuName forKey:@"skuName"];
            [skuDictionary setObject:[NSNumber numberWithInteger:skuInfo.spotValue] forKey:@"spotQuantity"];
            [skuDictionary setObject:[NSNumber numberWithInteger:skuInfo.futureValue] forKey:@"futureQuantity"];
            
            [skuDictList addObject:skuDictionary];
        }
    }
    
    return skuDictList;
}

- (NSMutableArray*)modelSkuDictionaryList {
    
    NSMutableArray* skuDictList = [NSMutableArray array];
    
    NSMutableDictionary* skuDictionary = [NSMutableDictionary dictionary];
    
    [skuDictionary setObject:self.sampleSkuNo forKey:@"skuNo"];
    
    [skuDictionary setObject:@"购买样板" forKey:@"skuName"];
    [skuDictionary setObject:[NSNumber numberWithInteger:1] forKey:@"spotQuantity"];
    [skuDictionary setObject:[NSNumber numberWithInteger:0] forKey:@"futureQuantity"];
            
    [skuDictList addObject:skuDictionary];
    
    return skuDictList;
}

- (NSInteger)gettotalQuantity {
    
    NSInteger sumQuantity = 0;
    
    for (DoubleSku * skuInfo in self.skuList) {
        sumQuantity += skuInfo.spotValue;
        sumQuantity += skuInfo.futureValue;
    }
    
    return sumQuantity;
}

- (NSNumber *)stepPriceForCurrentQuantity {
    
    NSInteger quantity = [self gettotalQuantity];
    
    for (StepListDTO* stepPriceInfo in self.stepPriceList) {
        
         NSString *maxStr = [NSString stringWithFormat:@"%@",stepPriceInfo.maxNum];
        
        if (([stepPriceInfo.minNum integerValue] <= quantity && [stepPriceInfo.maxNum integerValue] >= quantity) ||
            ([stepPriceInfo.minNum integerValue] <= quantity && [maxStr isEqualToString:@""])) {
            return stepPriceInfo.price;
        }
    }
    
    return self.price;
}

@end
