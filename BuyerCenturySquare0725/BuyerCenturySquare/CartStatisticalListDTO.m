//
//  CartStatisticalListDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/5/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CartStatisticalListDTO.h"
#import "CartListDTO.h"

@implementation CartStatisticalMerchant

- (id)initWithCartMerchantInfo:(CartMerchant*)merchantInfo {
    self = [super init];
    if (self) {
        self.merchantNo = merchantInfo.merchantNo;
        self.quantity = merchantInfo.totalQuantityForSelectedGoods;
        self.amount = merchantInfo.totalPriceForSelectedGoods;
    }

    return self;
}

@end

@implementation CartStatisticalListDTO

- (id)init {
    self = [super init];
    if (self) {
        self.merchantList = [NSMutableArray array];
    }

    return self;
}

- (NSArray*)converterToCartStatisticalDictionaryList {

    NSMutableArray* dictionaryList = [NSMutableArray array];
    
    for (CartStatisticalMerchant* merchantInfo in self.merchantList) {
        NSDictionary* merchantDictionary = [NSDictionary dictionaryWithObjectsAndKeys:merchantInfo.merchantNo, @"merchantNo", [NSNumber numberWithInteger:merchantInfo.quantity], @"quantity", [NSNumber numberWithFloat:merchantInfo.self.amount], @"amount", nil];
        [dictionaryList addObject:merchantDictionary];
    }

    return dictionaryList;
}

@end
