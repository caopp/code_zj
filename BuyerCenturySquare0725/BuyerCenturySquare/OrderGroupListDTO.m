//
//  OrderListDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "OrderGroupListDTO.h"

#pragma mark -
#pragma mark OrderGoods

@implementation OrderGoods

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartType"]]) {
            self.cartType = [dictInfo objectForKey:@"cartType"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
            self.color = [dictInfo objectForKey:@"color"];
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
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            NSNumber* price = [dictInfo objectForKey:@"price"];
            self.price =  price.floatValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* quantity = [dictInfo objectForKey:@"quantity"];
            self.quantity =  quantity.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sizes"]]) {
            NSString* sizes = [dictInfo objectForKey:@"sizes"];
            self.sizes = [sizes componentsSeparatedByString:@","];
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

@end

#pragma mark -
#pragma mark OrderGroup

@implementation OrderGroup

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"addressId"]]) {
            NSNumber* addressId = [dictInfo objectForKey:@"addressId"];
            self.addressId =  addressId.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]) {
            self.memberName = [dictInfo objectForKey:@"memberName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
            self.memberNo = [dictInfo objectForKey:@"memberNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberPhone"]]) {
            self.memberPhone = [dictInfo objectForKey:@"memberPhone"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
            self.merchantName = [dictInfo objectForKey:@"merchantName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
            self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"nickName"]]) {
            self.nickName = [dictInfo objectForKey:@"nickName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
            self.orderCode = [dictInfo objectForKey:@"orderCode"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"originalTotalAmount"]]) {
            NSNumber* originalTotalAmount = [dictInfo objectForKey:@"originalTotalAmount"];
            self.originalTotalAmount =  originalTotalAmount.floatValue;
        }
        if ([self checkLegitimacyForData:dictInfo[@"paidTotalAmount"]]) {
            NSNumber *paidTotalAmountNmb = dictInfo[@"paidTotalAmount"];
            self.paidTotalAmount = paidTotalAmountNmb.floatValue;
            
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* quantity = [dictInfo objectForKey:@"quantity"];
            self.quantity =  quantity.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* status = [dictInfo objectForKey:@"status"];
            self.status =  status.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
            NSNumber* totalAmount = [dictInfo objectForKey:@"totalAmount"];
            self.totalAmount =  totalAmount.floatValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
            NSNumber* type = [dictInfo objectForKey:@"type"];
            self.type =  type.integerValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"balanceQuantity"]]) {
            NSNumber *balanceQuantity = [dictInfo objectForKey:@"balanceQuantity"];
            self.balanceQuantity = balanceQuantity.integerValue;
            
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderGoodsItems"]]) {
            self.goodsList = [NSMutableArray array];
            
            NSArray* goodsItemDictList = [dictInfo objectForKey:@"orderGoodsItems"];
            for (NSDictionary* goodsItemDict in goodsItemDictList) {
                OrderGoods* orderGoodsInfo = [[OrderGoods alloc]initWithDictionary:goodsItemDict];
                [self.goodsList addObject:orderGoodsInfo];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (CSPOrderMode)orderMode {
    CSPOrderMode orderModeForGroup = CSPOrderModeAll;
    switch (self.status) {
        case 0:
            orderModeForGroup = CSPOrderModeOrderCanceled;
            break;
        case 1:
            orderModeForGroup = CSPOrderModeToPay;
            break;
        case 2:
            orderModeForGroup = CSPOrderModeToDispatch;
            break;
        case 3:
            orderModeForGroup = CSPOrderModeToTakeDelivery;
            break;
        case 4:
            orderModeForGroup = CSPOrderModeDealCanceled;
            break;
        case 5:
            orderModeForGroup = CSPOrderModeDealCompleted;
            break;
        default:
            break;
    }
    
    return orderModeForGroup;
}

@end

#pragma mark -
#pragma mark OrderGroupListDTO

@implementation OrderGroupListDTO


- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderList"]]) {
            self.groupList = [NSMutableArray array];
            
            NSArray* groupDictList = [dictInfo objectForKey:@"orderList"];
            for (NSDictionary* groupInfoDict in groupDictList) {
                OrderGroup* orderGroupInfo = [[OrderGroup alloc]initWithDictionary:groupInfoDict];
                [self.groupList addObject:orderGroupInfo];
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
            NSNumber* totalCount = [dictInfo objectForKey:@"totalCount"];
            self.totalCount = totalCount.integerValue;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (void)removeOrderGroup:(OrderGroup *)orderGroup {
    for (OrderGroup* orderGroupInfo in self.groupList) {
        if ([orderGroupInfo.orderCode isEqualToString:orderGroup.orderCode]) {
            [self.groupList removeObject:orderGroupInfo];
            break;
        }
    }
}

- (BOOL)isLoadedAll {
    
    BOOL result = NO;
    
    if (self.totalCount <= self.groupList.count) {
        result = YES;
    }
    
    return result;
}

- (NSInteger)nextPage {
    return self.groupList.count / pageSize + 1;
}

@end
