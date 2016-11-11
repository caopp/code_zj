//
//  CartListConfirmDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/4/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CartListConfirmDTO.h"


#pragma mark -
#pragma mark CartConfirmGoods

@implementation CartConfirmGoods

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
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
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
            self.pictureUrl = [dictInfo objectForKey:@"picUrl"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartType"]]) {
            self.cartType = [dictInfo objectForKey:@"cartType"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            NSNumber* priceValue = [dictInfo objectForKey:@"price"];
            self.price = priceValue.floatValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* quantityValue = [dictInfo objectForKey:@"quantity"];
            self.quantity = quantityValue.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sizes"]]) {
            NSString* skuString = [dictInfo objectForKey:@"sizes"];
            self.sizes = [skuString componentsSeparatedByString:@","];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (CartConfirmGoodsType)goodsType {
    if ([self.cartType isEqualToString:@"0"]) {
        return CartConfirmGoodsTypeOfNormal;
    } else if ([self.cartType isEqualToString:@"1"]) {
        return CartConfirmGoodsTypeOfSample;
    } else {
        return CartConfirmGoodsTypeOfMail;
    }
}

@end

#pragma mark -
#pragma mark CartConfirmMerchant

@implementation CartConfirmMerchant

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
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
            self.type = [dictInfo objectForKey:@"type"];
        }
//        orderTotalPrice
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderTotalPrice"]]) {
            self.orderTotalPrice = [dictInfo objectForKey:@"orderTotalPrice"];
        }
//        delieveryFee
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"delieveryFee"]]) {
            self.delieveryFee = [dictInfo objectForKey:@"delieveryFee"];
        }
        
//        totalQuantity
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalQuantity"]]) {
            self.totalQuantity = [dictInfo objectForKey:@"totalQuantity"];
        }
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsList"]]) {
            self.goodsList = [NSMutableArray array];
            
            NSArray* goodsListDict = [dictInfo objectForKey:@"goodsList"];
            for (NSDictionary* goodsInfoDict in goodsListDict) {
                CartConfirmGoods* goodsInfo = [[CartConfirmGoods alloc]initWithDictionary:goodsInfoDict];
                [self.goodsList addObject:goodsInfo];
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"delieveryList"]]) {
            self.delieveryListArr = [NSMutableArray array];
            NSArray *deliveryArr = dictInfo[@"delieveryList"];
            for (int i = 0; i<deliveryArr.count; i++) {
                NSDictionary *dict = deliveryArr[i];
                DelieveryListDTO *deliveryListDto = [[DelieveryListDTO alloc] init];
                deliveryListDto.merchantNo = self.merchantNo;
                deliveryListDto.type = self.type;
                [deliveryListDto setDictFrom:dict];
                [self.delieveryListArr addObject:deliveryListDto];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (CartConfirmGroupSkuType)groupSkuType {
    if ([self.type isEqualToString:@"spot"]) {
        return CartConfirmGroupSkuTypeOfSpot;
    } else {
        return CartConfirmGroupSkuTypeOfFuture;
    }
}

@end

@implementation DelieveryListDTO

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self && dictInfo) {
        @try {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"templateId"]]) {
                self.templateId = [dictInfo objectForKey:@"templateId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"templateName"]]) {
                self.templateName = [dictInfo objectForKey:@"templateName"];
            }

            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"delieveryFee"]]) {
                self.delieveryFee = [dictInfo objectForKey:@"delieveryFee"];
            }

            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isSeclect"]]) {
                self.isSeclect = [dictInfo objectForKey:@"isSeclect"];
            }
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

@end

#pragma mark -
#pragma mark CartListConfirmDTO

@implementation CartListConfirmDTO

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
            self.memberNo = [dictInfo objectForKey:@"memberNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalQuantity"]]) {
            NSNumber* totalQuantity = [dictInfo objectForKey:@"totalQuantity"];
            self.totalQuantity = totalQuantity.integerValue;
        }
        if ([self checkLegitimacyForData:dictInfo[@"totalPrice"]]) {
            self.totalPrice = dictInfo[@"totalPrice"];
            
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"totalDelieveryFee"]]) {
            self.totalDelieveryFee = dictInfo[@"totalDelieveryFee"];
        }
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantList"]]) {
            self.merchantList = [NSMutableArray array];
            
            NSArray* merchantListDict = [dictInfo objectForKey:@"merchantList"];
            for (NSDictionary* merchantInfoDict in merchantListDict) {
                CartConfirmMerchant* merchantInfo = [[CartConfirmMerchant alloc]initWithDictionary:merchantInfoDict];
                [self.merchantList addObject:merchantInfo];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
