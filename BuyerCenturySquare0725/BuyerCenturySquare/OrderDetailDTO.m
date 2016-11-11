//
//  OrderDetailDTO.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "OrderDetailDTO.h"
#import "OrderDeliveryDTO.h"


#pragma mark -
#pragma mark OrderDelivery

@implementation OrderDelivery

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
            self.orderCode = [dictInfo objectForKey:@"orderCode"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"deliveryReceiptImage"]]) {
            self.picUrl = [dictInfo objectForKey:@"deliveryReceiptImage"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createTime"]]) {
            self.createTime = [dictInfo objectForKey:@"createTime"];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end

#pragma mark -
#pragma mark OrderGoodsItem

@implementation OrderGoodsItem

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
            self.picUrl = [dictInfo objectForKey:@"picUrl"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cartType"]]) {
            self.cartType = [dictInfo objectForKey:@"cartType"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            NSNumber* price = [dictInfo objectForKey:@"price"];
            self.price = price.doubleValue;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* quantity = [dictInfo objectForKey:@"quantity"];
            self.quantity = quantity.integerValue;
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
#pragma mark OrderDetailDTO

@implementation OrderDetailDTO

- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (!dictInfo) {
            return;
        }
        self.mailTimesArr = [NSMutableArray array];
        self.mailEndTimesArr = [NSMutableArray array];
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"addressId"]]) {
            self.addressId = [dictInfo objectForKey:@"addressId"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"consigneeName"]]) {
            self.consigneeName = [dictInfo objectForKey:@"consigneeName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"consigneePhone"]]) {
            self.consigneePhone = [dictInfo objectForKey:@"consigneePhone"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"provinceName"]]) {
            self.provinceName = [dictInfo objectForKey:@"provinceName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cityNo"]]) {
            self.cityNo = [dictInfo objectForKey:@"cityNo"];
  
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cityName"]]) {
            self.cityName = [dictInfo objectForKey:@"cityName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"countyName"]]) {
            self.countyName = [dictInfo objectForKey:@"countyName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"detailAddress"]]) {
            self.detailAddress = [dictInfo objectForKey:@"detailAddress"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"paidTotalAmount"]]) {
            
            NSNumber * paidTotalAmountNmb= dictInfo[@"paidTotalAmount"];
            self.paidTotalAmount = paidTotalAmountNmb.doubleValue;
            
            

        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
            self.orderCode = [dictInfo objectForKey:@"orderCode"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"status"]]) {
            NSNumber* status = [dictInfo objectForKey:@"status"];
            self.status = status.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
            NSNumber* type = [dictInfo objectForKey:@"type"];
            self.type = type.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* quantity = [dictInfo objectForKey:@"quantity"];
            self.quantity = quantity.integerValue;
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"freightTemplateName"]]) {
            self.freightTemplateName = dictInfo[@"freightTemplateName"];
        }

        if ([self checkLegitimacyForData:dictInfo[@"dFee"]]) {
            self.dFee = dictInfo[@"dFee"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"oldPaidTotalAmount"]]) {
            self.oldPaidTotalAmount = dictInfo[@"oldPaidTotalAmount"];
        }
        
        
//        oldPaidTotalAmount
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"originalTotalAmount"]]) {
            NSNumber* originalTotalAmount = [dictInfo objectForKey:@"originalTotalAmount"];
            self.originalTotalAmount = originalTotalAmount.doubleValue;
            
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
            self.memberNo = [dictInfo objectForKey:@"memberNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
            self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
            self.merchantName = [dictInfo objectForKey:@"merchantName"];
        }
        
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundStatus"]]) {
            self.refundStatus = [dictInfo objectForKey:@"refundStatus"];
        }
        
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"confirmRemainingTime"]]) {
            self.confirmRemainingTime = [dictInfo objectForKey:@"confirmRemainingTime"];
            if (![self.confirmRemainingTime isEqualToString:@""]&&self.confirmRemainingTime) {
                NSNumber *numberStatus = [dictInfo objectForKey:@"refundStatus"];
                
                if (![numberStatus isEqual:@""]|| [numberStatus isKindOfClass:[NSNumber class]]) {
                    
                }else
                {
                [self.mailTimesArr addObject:[NSString stringWithFormat:@"自动确定收货时间: %@",self.confirmRemainingTime]];
                }
            }
            
        }

        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createTime"]]) {
            self.createTime = [dictInfo objectForKey:@"createTime"];
            if (![self.createTime isEqualToString:@""]&&self.createTime) {
                [self.mailTimesArr addObject:[NSString stringWithFormat:@"下单时间: %@",self.createTime]];

            }
        }

        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"paymentTime"]]) {
            
            self.paymentTime = [dictInfo objectForKey:@"paymentTime"];
            
            
            if (![self.paymentTime isEqualToString:@""]&&self.paymentTime) {
                [self.mailTimesArr addObject:[NSString stringWithFormat:@"付款时间: %@",self.paymentTime]];

               }
            
            
        }
        
        
        if ([self checkLegitimacyForData:dictInfo[@"orderDelivery"]]) {
            self.orderDelivery = [NSMutableArray array];
            NSArray *arr = dictInfo[@"orderDelivery"];
            
            
            
            
            if (arr.count >0) {
                
                for (int i = 0; i<arr.count; i++) {
                    NSDictionary *deliberyDict = arr[i];
                    OrderDeliveryDTO *order = [[OrderDeliveryDTO alloc] init];
                    [order setDictFrom:deliberyDict];
                    [self.orderDelivery addObject:order];
                    if (i == 0) {
                        
                        if (![order.createTime isEqualToString:@""]&&order.createTime) {
                            [self.mailTimesArr addObject:[NSString stringWithFormat:@"发货时间: %@",order.createTime]];

                        }
        
                    }
                }
            }
            
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"deliveryTime"]]) {
            self.deliveryTime = [dictInfo objectForKey:@"deliveryTime"];

            if (![self.deliveryTime isEqualToString:@""]&&self.deliveryTime) {
//            [self.mailTimesArr addObject:self.deliveryTime];
//            [self.mailTimesArr addObject:[NSString stringWithFormat:@"发货时间: %@",self.deliveryTime]];

               }
        }
        
        //        退换货申请时间
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundCreateTime"]]) {
            self.refundCreateTime =[NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"refundCreateTime"]];
            if (![self.refundCreateTime isEqualToString:@""]&&self.refundCreateTime) {
                
                [self.mailEndTimesArr addObject:[NSString stringWithFormat:@"退/换货申请时间: %@",self.refundCreateTime]];
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundDealTime"]]) {
            self.refundDealTime =[NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"refundDealTime"]];
            if (![self.refundDealTime isEqualToString:@""]&&self.refundDealTime) {
                [self.mailEndTimesArr addObject:[NSString stringWithFormat:@"处理完成时间: %@",self.refundDealTime]];
            }
        }
        

        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCancelTime"]]) {
            self.orderCancelTime = [dictInfo objectForKey:@"orderCancelTime"];
               self.orderCancelTime = [dictInfo objectForKey:@"orderCancelTime"];
            if (![self.orderCancelTime isEqualToString:@""]&&self.orderCancelTime) {
            [self.mailEndTimesArr addObject:[NSString stringWithFormat:@"采购单取消时间: %@",self.orderCancelTime]];

               }

        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"dealCancelTime"]]) {
            self.dealCancelTime = dictInfo[@"dealCancelTime"];
               self.createTime = [dictInfo objectForKey:@"createTime"];     if (![self.dealCancelTime isEqualToString:@""]&&self.dealCancelTime) {
            [self.mailEndTimesArr addObject:[NSString stringWithFormat:@"交易取消时间: %@",self.dealCancelTime]];
               }
        }
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"receiveTime"]]) {
            
            

            self.receiveTime = [dictInfo objectForKey:@"receiveTime"];
            if (![self.receiveTime isEqualToString:@""]&&self.receiveTime) {
                
                
                NSNumber *numberStatus = [dictInfo objectForKey:@"refundStatus"];
                //换货处理完成 这里处理完成时间=收货时间
                if (numberStatus.integerValue == 5) {
//                    [self.mailEndTimesArr addObject:[NSString stringWithFormat:@"处理完成时间: %@",self.receiveTime]];
                    
                }else{
                [self.mailEndTimesArr addObject:[NSString stringWithFormat:@"收货时间: %@",self.receiveTime]];
                    }
                }
            }
        
        

        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
            NSNumber* totalAmount = [dictInfo objectForKey:@"totalAmount"];
            self.totalAmount = totalAmount.doubleValue;
        }
        
               if ([self checkLegitimacyForData:[dictInfo objectForKey:@"balanceQuantity"]]) {
            self.balanceQuantity = [[dictInfo objectForKey:@"balanceQuantity"] integerValue];
            
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderDelivery"]]) {
            NSMutableArray* orderDeliveryList = [dictInfo objectForKey:@"orderDelivery"];
            self.orderDeliveryList = [NSMutableArray array];
            
            for (NSDictionary* orderDeliveryDict in orderDeliveryList) {
                OrderDelivery* orderDeliveryInfo = [[OrderDelivery alloc]initWithDictionary:orderDeliveryDict];
                [self.orderDeliveryList addObject:orderDeliveryInfo];
            }
        }
        

        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderGoodsItems"]]) {
            NSMutableArray* goodsList = [dictInfo objectForKey:@"orderGoodsItems"];
            self.goodsList = [NSMutableArray array];
            for (NSDictionary* goodsItemDict in goodsList) {
                OrderGoodsItem* goodsItemInfo = [[OrderGoodsItem alloc]initWithDictionary:goodsItemDict];
                [self.goodsList addObject:goodsItemInfo];
            }
        }
        
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundNo"]]) {
            self.refundNo = [dictInfo objectForKey:@"refundNo"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundFee"]]) {
            self.refundFee = [dictInfo objectForKey:@"refundFee"];
        }
        
        
 
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundCreateTime"]]) {
            self.refundCreateTime = [dictInfo objectForKey:@"refundCreateTime"];
        }
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundDealTime"]]) {
            self.refundDealTime = [dictInfo objectForKey:@"refundDealTime"];
        }        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSString*)convertOrderStatusToString {
    NSString* orderStatus = nil;
    
    switch (self.status) {
        case 0:
            orderStatus = @"采购单取消";
            break;
        case 1:
            orderStatus = @"待付款";
            break;
        case 2:
            orderStatus = @"待发货";
            break;
        case 3:
            orderStatus = @"待收货";
            break;
        case 4:
            orderStatus = @"交易取消";
            break;
        case 5:
            orderStatus = @"交易完成";
            break;
        default:
            break;
    }
    
    return orderStatus;
}

- (NSArray*)deliveryStatusTimeList {
    NSMutableArray* statusTimeList = [NSMutableArray array];
    
    
    if (self.confirmRemainingTime  && self.confirmRemainingTime.length > 0) {
        
        [statusTimeList addObject:[NSString stringWithFormat:@"自动确定收货时间:  还剩%@", self.confirmRemainingTime]];
 
    }
    if (self.createTime && self.createTime.length > 0) {
        [statusTimeList addObject:[NSString stringWithFormat:@"下单时间: %@", self.createTime]];
    }
    
    if (self.paymentTime && self.paymentTime.length > 0) {
        [statusTimeList addObject:[NSString stringWithFormat:@"付款时间: %@", self.paymentTime]];
    }
    
    if (self.deliveryTime && self.deliveryTime.length > 0) {
        [statusTimeList addObject:[NSString stringWithFormat:@"发货时间: %@", self.deliveryTime]];
    }
    
    if (self.receiveTime && self.receiveTime.length > 0) {
        [statusTimeList addObject:[NSString stringWithFormat:@"收货时间: %@", self.receiveTime]];
    }
    
    if (self.dealCancelTime && self.dealCancelTime.length > 0) {
        [statusTimeList addObject:[NSString stringWithFormat:@"交易取消时间: %@", self.dealCancelTime]];
    }
    
    if (self.orderCancelTime && self.orderCancelTime.length > 0) {
        [statusTimeList addObject:[NSString stringWithFormat:@"采购单取消时间: %@", self.orderCancelTime]];
    }
    
    return statusTimeList;
}

- (CSPOrderMode)convertOrderStatusToValue {
    CSPOrderMode orderMode = CSPOrderModeToPay;
    switch (self.status) {
        case 0:
            orderMode = CSPOrderModeOrderCanceled;
            break;
        case 1:
            orderMode = CSPOrderModeToPay;
            break;
        case 2:
            orderMode = CSPOrderModeToDispatch;
            break;
        case 3:
            orderMode = CSPOrderModeToTakeDelivery;
            break;
        case 4:
            orderMode = CSPOrderModeDealCanceled;
            break;
        case 5:
            orderMode = CSPOrderModeDealCompleted;
            break;
        default:
            break;
    }
    return orderMode;
}

- (NSString*)addressDescription {
    NSMutableString* addressString = [NSMutableString string];
    
    if (self.provinceName) {
        [addressString appendString:self.provinceName];
    }
    if (self.cityName) {
        [addressString appendString:self.cityName];
    }
    if (self.countyName) {
        [addressString appendString:self.countyName];
    }
    
    if (self.detailAddress) {
        [addressString appendString:self.detailAddress];
    }
    
    return addressString;
}


@end
