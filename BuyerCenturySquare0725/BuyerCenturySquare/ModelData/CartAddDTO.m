//
//  CartAddDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CartAddDTO.h"
#import "ReplenishmentByMerchantDTO.h"
#import "GoodsInfoDetailsDTO.h"
#import "IMGoodsInfoDTO.h"

@implementation CartAddDTO

- (id)init{
    self = [super init];
    if (self) {
        self.skuDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

- (id)initWithReplenishmentItem:(ReplenishmentGoods*)replenishmentItem {
    
    self = [super init];
    if (self) {
        self.merchantNo = replenishmentItem.merchantNo;
        self.goodsNo = replenishmentItem.goodsNo;
        self.cartType = @"0";
        self.price = [NSNumber numberWithFloat:[replenishmentItem stepPriceForCurrentQuantity]];
        self.totalQuantity = [NSNumber numberWithInteger:replenishmentItem.totalQuantity];
        self.skuDTOList = replenishmentItem.skuDictionaryList;
    }

    return self;
}

- (id)initWithGoodInfoDetailsInfo:(GoodsInfoDetailsDTO *)goodInfoDetailsDTO {
    
    self = [super init];
    if (self) {
        self.merchantNo = goodInfoDetailsDTO.merchantNo;
        self.goodsNo = goodInfoDetailsDTO.goodsNo;
        self.cartType = @"0";
//        self.price = [NSNumber numberWithFloat:replenishmentItem.batchPrice];
//        self.totalQuantity = [NSNumber numberWithInteger:replenishmentItem.totalQuantity];
        self.skuDTOList = goodInfoDetailsDTO.skuDictionaryList;
    }
    
    return self;
}

- (id)initWithIMGoodsInfoDTO:(IMGoodsInfoDTO *)imGoodsInfoDTO {
    
    self = [super init];
    if (self) {
        
        self.merchantNo = imGoodsInfoDTO.merchantNo;
        self.goodsNo = imGoodsInfoDTO.goodsNo;
        self.cartType = imGoodsInfoDTO.cartType;
        self.price = imGoodsInfoDTO.stepPriceForCurrentQuantity;
        self.totalQuantity = [NSNumber numberWithInteger:imGoodsInfoDTO.gettotalQuantity];
        self.skuDTOList = imGoodsInfoDTO.skuDictionaryList;
    }
    
    return self;
}

- (id)initWithIMGoodsInfoDTO2Model:(IMGoodsInfoDTO *)imGoodsInfoDTO {
    
    self = [super init];
    if (self) {
        
        self.merchantNo = imGoodsInfoDTO.merchantNo;
        self.goodsNo = imGoodsInfoDTO.goodsNo;
        self.cartType = @"1";
        self.price = imGoodsInfoDTO.samplePrice;
        self.totalQuantity = [NSNumber numberWithInteger:1];
        
        self.skuDTOList = imGoodsInfoDTO.modelSkuDictionaryList;
    
    }
    
    return self;
}

-(BOOL)getParameterIsLack
{
    if ([self.merchantNo isEqualToString:@""]||[self.goodsNo isEqualToString:@""]||
        [self.cartType isEqualToString:@""]||[self.price doubleValue]== 0.0f||
        [self.totalQuantity intValue]== 0){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}


@end
