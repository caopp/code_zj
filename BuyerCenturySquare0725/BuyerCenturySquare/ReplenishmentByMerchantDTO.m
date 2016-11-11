//
//  ReplenishmentByMerchantDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "ReplenishmentByMerchantDTO.h"
#import "CSPReplenishmentSectionHeaderView.h"
#import "CartAddDTO.h"
#import "DoubleSku.h"
#import "StepListDTO.h"

#pragma mark -
#pragma ReplenishmentSku

@implementation ReplenishmentSku

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
            self.skuNo = [dictInfo objectForKey:@"skuNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuName"]]) {
            self.skuName = [dictInfo objectForKey:@"skuName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
            self.sort = [[dictInfo objectForKey:@"sort"] integerValue];
        }
        
        self.value = 0;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end

#pragma mark -
#pragma ReplenishmentStepPrice

@implementation ReplenishmentStepPrice

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            NSNumber* idValue = [dictInfo objectForKey:@"id"];
            self.id = idValue.integerValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            NSNumber* priceValue = [dictInfo objectForKey:@"price"];
            self.price = priceValue.floatValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"minNum"]]) {
            NSNumber* minNumber = [dictInfo objectForKey:@"minNum"];
            self.minNum = minNumber.integerValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"maxNum"]]) {
            NSNumber* maxNumber = [dictInfo objectForKey:@"maxNum"];
            self.maxNum = maxNumber.integerValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
            NSNumber* sort = [dictInfo objectForKey:@"sort"];
            self.sort = sort.integerValue;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end

#pragma mark -
#pragma ReplenishmentGoods

@implementation ReplenishmentGoods


- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsWillNo"]]) {
                self.goodsWillNo = dictInfo[@"goodsWillNo"];
                
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                self.color = [dictInfo objectForKey:@"color"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                self.pictureUrl = [dictInfo objectForKey:@"picUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                NSNumber* batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
                self.batchNumLimit = batchNumLimit.integerValue;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchPrice"]]) {
                NSNumber* batchPrice = [dictInfo objectForKey:@"batchPrice"];
                self.batchPrice = batchPrice.floatValue;
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuList"]]) {
                NSDictionary* skuList = [dictInfo objectForKey:@"skuList"];
                self.skuList = [NSMutableArray array];
                for (NSDictionary* skuInfoDict in skuList) {
                    ReplenishmentSku* skuInfo = [[ReplenishmentSku alloc]initWithDictionary:skuInfoDict];
                    [self.skuList addObject:skuInfo];
                }
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stepPriceList"]]) {
                
                self.stepPriceList = [NSMutableArray array];
                NSArray* stepPriceList = [dictInfo objectForKey:@"stepPriceList"];
                for (NSDictionary* stepPriceInfoDict in stepPriceList) {
                    ReplenishmentStepPrice* stepPriceInfo = [[ReplenishmentStepPrice alloc]initWithDictionary:stepPriceInfoDict];
                    [self.stepPriceList addObject:stepPriceInfo];
                }
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSInteger)totalQuantity {
    
    NSInteger sumQuantity = 0;
    
    for (ReplenishmentSku* skuInfo in self.skuList) {
        sumQuantity += skuInfo.value;
    }
    
    return sumQuantity;
}

- (NSMutableArray*)skuDictionaryList {
    @try {
        NSMutableArray* skuDictList = [NSMutableArray array];
        
        for (ReplenishmentSku* skuInfo in self.skuList) {
            if (skuInfo.value > 0) {
                NSMutableDictionary* skuDictionary = [NSMutableDictionary dictionary];
                [skuDictionary setObject:skuInfo.skuNo forKey:@"skuNo"];
                [skuDictionary setObject:skuInfo.skuName forKey:@"skuName"];
                [skuDictionary setObject:[NSNumber numberWithInteger:skuInfo.value] forKey:@"spotQuantity"];
                [skuDictionary setObject:@0 forKey:@"futureQuantity"];
                
                [skuDictList addObject:skuDictionary];
            }
        }
        
        return skuDictList;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSInteger)totalQuantityExceptSku:(ReplenishmentSku*)skuInfo {
    NSInteger sumQuantity = 0;
    
    for (ReplenishmentSku* skuInfoForList in self.skuList) {
        if (![skuInfo.skuNo isEqualToString:skuInfoForList.skuNo]) {
            sumQuantity += skuInfoForList.value;
        }
    }
    
    return sumQuantity;
}

- (CGFloat)stepPriceForCurrentQuantity {
    NSInteger quantity = [self totalQuantity];
    NSInteger recordNumber;
    for (ReplenishmentStepPrice* stepPriceInfo in self.stepPriceList) {
        if (stepPriceInfo.minNum <= quantity && stepPriceInfo.maxNum >= quantity) {
            recordNumber  = quantity;
            return stepPriceInfo.price;
        }else if (stepPriceInfo.maxNum == 0&&quantity<recordNumber&&stepPriceInfo.minNum <= quantity)
        {
            return stepPriceInfo.price;
        }
    }
    
    return self.batchPrice;
}

- (NSMutableArray*)doubleSkuList {
    
    
    NSMutableArray* convertSkuList = [NSMutableArray array];
    
    for (ReplenishmentSku* skuInfo in self.skuList) {
        
        DoubleSku* newSku = [[DoubleSku alloc]initWithSingleSku:skuInfo];
        
        [convertSkuList addObject:newSku];
    }
    
    return convertSkuList;
}

- (NSMutableArray*)stepPriceDTOList {
    NSMutableArray* convertStepPriceList = [NSMutableArray array];
    for (ReplenishmentStepPrice* stepPrice in self.stepPriceList) {
        StepListDTO* stepPriceDTO = [[StepListDTO alloc]init];
        stepPriceDTO.Id = [NSNumber numberWithInteger:stepPrice.id];
        stepPriceDTO.price = [NSNumber numberWithFloat:stepPrice.price];
        stepPriceDTO.minNum = [NSNumber numberWithInteger:stepPrice.minNum];
        stepPriceDTO.maxNum = [NSNumber numberWithInteger:stepPrice.maxNum];
        stepPriceDTO.sort = [NSNumber numberWithInteger:stepPrice.sort];
        [convertStepPriceList addObject:stepPriceDTO];
    }

    return convertStepPriceList;
}


@end

#pragma mark -
#pragma ReplenishmentMerchant

@implementation ReplenishmentMerchant


- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsList"]]) {
                NSDictionary* goodsList = [dictInfo objectForKey:@"goodsList"];
                self.goodsList = [NSMutableArray array];
                for (NSDictionary* goodsInfoDict in goodsList) {
                    ReplenishmentGoods* goodsInfo = [[ReplenishmentGoods alloc]initWithDictionary:goodsInfoDict];
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

- (void)selectAllGoodsOfCurrentMerchant:(BOOL)select {
   
    
    for (ReplenishmentGoods* goodsInfo in self.goodsList) {
        goodsInfo.selected = select;
    }
    
    
}

- (NSInteger)selectedGoodsAmount {
    NSInteger selectedAmount = 0;
    for (ReplenishmentGoods* goodsInfo in self.goodsList) {
        selectedAmount += goodsInfo.selected ? 1 : 0;
    }
    
    return selectedAmount;
}

- (BOOL)isAllGoodsSelected {
    if (self.selectedGoodsAmount == self.goodsList.count) {
        return YES;
    }
    
    return NO;
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

#pragma mark -
#pragma ReplenishmentByMerchantDTO

@implementation ReplenishmentByMerchantDTO

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"data"]]) {
                
                NSDictionary* dataDict = [dictInfo objectForKey:@"data"];
                
                self.merchantList = [NSMutableArray array];
                for (NSDictionary* merchantDict in dataDict) {
                    ReplenishmentMerchant* merchant = [[ReplenishmentMerchant alloc]initWithDictionary:merchantDict];
                    [self.merchantList addObject:merchant];
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (NSArray*)goodsListForAddingCart {
    
    NSMutableArray* totalList = [NSMutableArray array];
    
    for (ReplenishmentMerchant* merchantInfo in self.merchantList) {
        
        [totalList addObjectsFromArray:[merchantInfo goodsListForAddingCart]];
    }
    
    return totalList;
}

@end
