//
//  CartListDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/31/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CartListDTO.h"
#import "CSPCartSectionHeaderView.h"
#import "CartStatisticalListDTO.h"
#import "WholeSaleConditionDTO.h"

#pragma mark -
#pragma CartSku

@implementation CartSku

@end

#pragma mark -
#pragma CartStepPrice

@implementation CartStepPrice

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
            self.price = priceValue.doubleValue;
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
#pragma CartGoods

@implementation CartGoods

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
            self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
            self.merchantName = [dictInfo objectForKey:@"merchantName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
            self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
            self.goodsName = [dictInfo objectForKey:@"goodsName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
            self.color = [dictInfo objectForKey:@"color"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* quantityValue = [dictInfo objectForKey:@"quantity"];
            self.quantity = quantityValue.integerValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            NSNumber* priceValue = [dictInfo objectForKey:@"price"];
            self.price = priceValue.floatValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"samplePrice"]]) {
            NSNumber* samplePrice = [dictInfo objectForKey:@"samplePrice"];
            self.samplePrice = samplePrice.floatValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
            self.pictureUrl = [dictInfo objectForKey:@"picUrl"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsStatus"]]) {
            self.goodsStatus = [dictInfo objectForKey:@"goodsStatus"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
            NSNumber* batchNumLimitValue = [dictInfo objectForKey:@"batchNumLimit"];
            self.batchNumLimit = batchNumLimitValue.integerValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartType"]]) {
            self.cartType = [dictInfo objectForKey:@"cartType"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuList"]]) {
            
            self.skuList = [NSMutableArray array];
            
            NSArray* skuList = [dictInfo objectForKey:@"skuList"];
            for (NSDictionary* skuInfoDict in skuList) {
                NSNumber* spotQuantity  = skuInfoDict[@"spotQuantity"];
                NSNumber* futureQuantity = skuInfoDict[@"futureQuantity"];
                
                NSInteger totalnum = spotQuantity.integerValue +futureQuantity.integerValue;
                self.totalNumb =[NSString stringWithFormat:@"%lu",self.totalNumb.integerValue +totalnum];
                
                CartSku* skuInfo = [[CartSku alloc]initWithDictionary:skuInfoDict];
                
                [self.skuList addObject:skuInfo];
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stepPriceList"]]) {
            
            self.stepPriceList = [NSMutableArray array];
            NSArray* stepPriceList = [dictInfo objectForKey:@"stepPriceList"];
            for (NSDictionary* stepPriceInfoDict in stepPriceList) {
                CartStepPrice* stepPriceInfo = [[CartStepPrice alloc]initWithDictionary:stepPriceInfoDict];
                [self.stepPriceList addObject:stepPriceInfo];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (CartGoodsType)cartGoodsType {
    if ([self.cartType isEqualToString:@"0"]) {
        return CartGoodsTypeOfNormal;
    } else if ([self.cartType isEqualToString:@"1"]) {
        return CartGoodsTypeOfSample;
    } else {
        return CartGoodsTypeOfMail;
    }
}

- (BOOL)isValidCartGoods {
    if ([self isInvalidCartGoods] || [self isCartQuantityLessThanBatchNumLimit]) {
        return NO;
    }
    
    return YES;
}

//判断是否是有效商品
- (BOOL)isInvalidCartGoods {
    if (![self.goodsStatus isEqualToString:@"2"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isCartQuantityLessThanBatchNumLimit {
    if (self.cartQuantity < self.batchNumLimit) {
        return YES;
    }
    
    return NO;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
}

- (NSInteger)cartQuantity {
    if (self.skuList.count == 0) {
        return self.quantity;
    }
    
    NSInteger quantity = 0;
    for (DoubleSku* skuInfo in self.skuList) {
        quantity += skuInfo.spotValue;
        quantity += skuInfo.futureValue;
    }
    
    return quantity;
}

- (CGFloat)cartPrice {
    if (self.cartGoodsType == CartGoodsTypeOfMail) {
        return self.price;
    } else if (self.cartGoodsType == CartGoodsTypeOfSample) {
        return self.price;
    } else {
        
        return  self.price;
        
        NSInteger quantity = [self cartQuantity];
        for (CartStepPrice* stepPriceInfo in self.stepPriceList) {
            if ((stepPriceInfo.minNum <= quantity && stepPriceInfo.maxNum >= quantity) ||
                (stepPriceInfo.minNum <= quantity && stepPriceInfo.maxNum == 0)) {
                return stepPriceInfo.price;
            }
        }
        
        return self.price;
    }
}

- (NSInteger)totalQuantityForSelectedGoods {
    if (!self.selected || !self.isValidCartGoods) {
        return 0;
    }
    
    NSInteger totalQuantityOfSelected = 0;
    
    if (self.cartGoodsType == CartGoodsTypeOfNormal) {
        totalQuantityOfSelected += [self cartQuantity];
    } else if (self.cartGoodsType == CartGoodsTypeOfSample) {
        totalQuantityOfSelected += [self cartQuantity];
    } else {
        totalQuantityOfSelected += [self cartQuantity];
    }
    
    return totalQuantityOfSelected;
}

- (CGFloat)totalPriceForSelectedGoods {
    
    if (!self.selected || !self.isValidCartGoods) {
        return 0.0f;
    }
    
    if (self.cartGoodsType == CartGoodsTypeOfMail) {
        return 1.0f * [self cartQuantity];
    } else if (self.cartGoodsType == CartGoodsTypeOfSample) {
        return self.price;
    } else {
        
        return self.price * [self cartQuantity];

        NSInteger quantity = [self cartQuantity];
        for (CartStepPrice* stepPriceInfo in self.stepPriceList) {
            if ((stepPriceInfo.minNum <= quantity && stepPriceInfo.maxNum >= quantity) ||
                (stepPriceInfo.minNum <= quantity && stepPriceInfo.maxNum == 0)) {
                return stepPriceInfo.price * [self cartQuantity];
            }
        }
        
        return self.price * [self cartQuantity];
    }
}

- (NSInteger)totalQuantityExceptSku:(BasicSkuDTO*)sku {
    if (!self.isValidCartGoods) {
        return 0;
    }
    
    if (self.skuList.count == 0) {
        return self.quantity;
    }
    
    NSInteger quantity = 0;
    for (DoubleSku* skuInfo in self.skuList) {
        if (![sku.skuNo isEqualToString:skuInfo.skuNo]) {
            quantity += skuInfo.spotValue;
            quantity += skuInfo.futureValue;
        }
    }
    
    return quantity;
}

@end

#pragma mark -
#pragma CartMerchant

@implementation CartMerchant

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
            self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
            self.merchantName = [dictInfo objectForKey:@"merchantName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartGoodsList"]]) {
            self.goodsList = [NSMutableArray array];
            
            NSArray* goodsList = [dictInfo objectForKey:@"cartGoodsList"];
            for (NSDictionary* goodsInfoDict in goodsList) {
                CartGoods* goodsInfo = [[CartGoods alloc]initWithDictionary:goodsInfoDict];
                [self.goodsList addObject:goodsInfo];
            }
        }
        
        self.isSatisfy = YES;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (NSInteger)selectedGoodsAmount {
    NSInteger selectedAmount = 0;
    for (CartGoods* goodsInfo in self.goodsList) {
        if (goodsInfo.selected && goodsInfo.isValidCartGoods) {
            selectedAmount += 1;
        }
    }
    
    return selectedAmount;
}

- (CGFloat)totalPriceForSelectedGoods {
    CGFloat totalPriceOfAll = 0.0f;
    for (CartGoods* goodsInfo in self.goodsList) {
        totalPriceOfAll += goodsInfo.totalPriceForSelectedGoods;
    }
    
    return totalPriceOfAll;
}

- (NSInteger)totalQuantityForSelectedGoods {
    NSInteger totalQuantityOfSelected = 0;
    for (CartGoods* goodsInfo in self.goodsList) {
        totalQuantityOfSelected += goodsInfo.totalQuantityForSelectedGoods;
    }
    
    return totalQuantityOfSelected;
}

- (NSInteger)totalValidGoodsAmount {
    NSInteger totalAmount = 0;
    
    for (CartGoods* goodsInfo in self.goodsList) {
        if ([goodsInfo isValidCartGoods]) {
            totalAmount += 1;
        }
    }
    
    return totalAmount;
}

- (BOOL)isThereGoodsSelected {
    for (CartGoods* goodsInfo in self.goodsList) {
        if (goodsInfo.selected == YES && goodsInfo.isValidCartGoods) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isThereGoodsOptional {
    for (CartGoods* goodsInfo in self.goodsList) {
        if (goodsInfo.isValidCartGoods) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isAllGoodsSelected {

    if (self.selectedGoodsAmount == [self totalValidGoodsAmount]) {
        return YES;
    }
    return NO;
}

- (void)setCondition:(SaleMerchantCondition *)condition {
    _condition = condition;
    
    _isSatisfy = condition.isMerchantSatisfy;
}

@end

#pragma mark -
#pragma CartListDTO

@implementation CartListDTO

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"data"]]) {
            self.merchantList = [NSMutableArray array];
            
            NSArray* dataList = [dictInfo objectForKey:@"data"];
            for (NSDictionary* cartInfoDict in dataList) {
                CartMerchant* merchantInfo = [[CartMerchant alloc]initWithDictionary:cartInfoDict];
                [self.merchantList addObject:merchantInfo];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (CartGoods*)cartGoodsForIndexPath:(NSIndexPath*)indexPath {
    if (self.merchantList.count <= indexPath.section) {
        return nil;
    }
    
    CartMerchant* cartMerchantInfo = self.merchantList[indexPath.section];
    
    if (cartMerchantInfo.goodsList.count <= indexPath.row) {
        return nil;
    }
    
    CartGoods* cartGoodsInfo = cartMerchantInfo.goodsList[indexPath.row];
    
    return cartGoodsInfo;
}

- (NSInteger)totalGoodsAmount {
    
    NSInteger totalAmount = 0;
    
    for (CartMerchant* merchantInfo in self.merchantList) {
        for (CartGoods *cartGoods in merchantInfo.goodsList) {
            if ([cartGoods.goodsStatus isEqualToString:@"2"]) {
//                totalAmount += merchantInfo.goodsList.count;
//                totalAmount +=totalAmount;
                
                totalAmount++;
                
                
                
            }
        }
       
    }
    
    return totalAmount;
}

- (NSInteger)totalValidGoodsAmount {
    NSInteger totalAmount = 0;
    
    for (CartMerchant* merchantInfo in self.merchantList) {
        totalAmount += merchantInfo.totalValidGoodsAmount;
    }
    
    return totalAmount;
}

- (NSInteger)selectedGoodsAmount {
    NSInteger selectedAmount = 0;
    for (CartMerchant* merchantInfo in self.merchantList) {
        selectedAmount += merchantInfo.selectedGoodsAmount;
    }
    
    return selectedAmount;
}

- (BOOL)isAllGoodsSelected {
    if (self.totalValidGoodsAmount == self.selectedGoodsAmount) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)goodsAmountForSection:(NSInteger)section {
    if (section >= self.merchantList.count) {
        return 0;
    }
    
    CartMerchant* merchantInfo = self.merchantList[section];
    return merchantInfo.goodsList.count;
}

- (CGFloat)totalPriceForSelectedGoods {
    CGFloat totalPriceOfAll = 0.0f;
    for (CartMerchant* merchantInfo in self.merchantList) {
        totalPriceOfAll += merchantInfo.totalPriceForSelectedGoods;
    }
    
    return totalPriceOfAll;
}

- (NSInteger)totalQuantityForSelectedGoods {
    NSInteger totalQuantityOfSelected = 0;
    for (CartMerchant* merchantInfo in self.merchantList) {
        totalQuantityOfSelected += merchantInfo.totalQuantityForSelectedGoods;
    }
    
    return totalQuantityOfSelected;
}

- (NSArray*)selectedCartStatisticalListToCheckWholesaleCondition {
    
    CartStatisticalListDTO* cartStatisticalList = [[CartStatisticalListDTO alloc]init];
    
    for (CartMerchant* merchantInfo in self.merchantList) {
        if (merchantInfo.isThereGoodsSelected) {
            CartStatisticalMerchant* merchantStatistical = [[CartStatisticalMerchant alloc]initWithCartMerchantInfo:merchantInfo];
            [cartStatisticalList.merchantList addObject:merchantStatistical];
        }
    }
    
    return [cartStatisticalList converterToCartStatisticalDictionaryList];
}

- (void)updateMerchantsInfoByWholeSaleCondition:(WholeSaleConditionDTO*)wholeSaleCondition {
    for (CartMerchant* merchantInfo in self.merchantList) {
        merchantInfo.isSatisfy = YES;
    }
    
    for (SaleMerchantCondition* merchantCondition in wholeSaleCondition.merchantList) {
        for (CartMerchant* merchantInfo in self.merchantList) {
            if ([merchantCondition.merchantNo  isEqualToString:merchantInfo.merchantNo]) {
                merchantInfo.condition = merchantCondition;
                break;
            }
        }
    }
}

- (NSIndexSet*)changedSectionsIndexSet {
    NSMutableIndexSet* sections = [NSMutableIndexSet indexSet];
    for (int index = 0; index < self.merchantList.count; index++) {
        CartMerchant* merchantInfo = self.merchantList[index];
        if (!merchantInfo.isSatisfy) {
            [sections addIndex:index];
        }
    }
    
    return sections;
}


- (NSArray*)selectedGoodsDictionaryList {
    NSMutableArray* selectedGoods = [NSMutableArray array];
    
    for (CartMerchant* merchantInfo in self.merchantList) {
        for (CartGoods* goodsInfo in merchantInfo.goodsList) {
            
            if (goodsInfo.selected && goodsInfo.isValidCartGoods) {
                if (goodsInfo && goodsInfo.goodsNo && goodsInfo.cartType) {
                    //两个参数进行传递
                    NSDictionary* goodsDict = @{@"goodsNo": goodsInfo.goodsNo, @"cartType": goodsInfo.cartType};
                    
                    [selectedGoods addObject:goodsDict];
                }
            }
        }
    }
    
    return selectedGoods;
}


@end
