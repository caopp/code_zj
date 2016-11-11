//
//  GetOrderDetailDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetOrderDetailDTO.h"

@implementation GetOrderDetailDTO
- (id)init{
    self = [super init];
    if (self) {
        self.orderGoodsItemsList = [[NSMutableArray alloc]init];
        self.orderDeliveryList = [[NSMutableArray alloc] init];
        
        return self;
    }else{
        return nil;
    }
}

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"addressId"]]) {
                
                self.addressId = [dictInfo objectForKey:@"addressId"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"consigneeName"]]) {
                
                self.consigneeName = [dictInfo objectForKey:@"consigneeName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"consigneePhone"]]) {
                
                self.consigneePhone = [dictInfo objectForKey:@"consigneePhone"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"provinceNo"]]) {
                
                self.provinceNo = [dictInfo objectForKey:@"provinceNo"];
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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"countyNo"]]) {
                
                self.countyNo = [dictInfo objectForKey:@"countyNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"countyName"]]) {
                
                self.countyName = [dictInfo objectForKey:@"countyName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"detailAddress"]]) {
                
                self.detailAddress = [dictInfo objectForKey:@"detailAddress"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
                
                self.orderCode = [dictInfo objectForKey:@"orderCode"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"status"]]) {
                
                self.status = [dictInfo objectForKey:@"status"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
                
                self.quantity = [dictInfo objectForKey:@"quantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"originalTotalAmount"]]) {
                
                self.originalTotalAmount = [dictInfo objectForKey:@"originalTotalAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createTime"]]) {
                
                self.createTime = [dictInfo objectForKey:@"createTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"paymentTime"]]) {
                
                self.paymentTime = [dictInfo objectForKey:@"paymentTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"deliveryTime"]]) {
                
                self.deliveryTime = [dictInfo objectForKey:@"deliveryTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"receiveTime"]]) {
                
                self.receiveTime = [dictInfo objectForKey:@"receiveTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCancelTime"]]) {
                
                self.orderCancelTime = [dictInfo objectForKey:@"orderCancelTime"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"dealCancelTime"]]) {
                
                self.dealCancelTime = [dictInfo objectForKey:@"dealCancelTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"confirmRemainingTime"]]) {
                
                self.confirmRemainingTime = [dictInfo objectForKey:@"confirmRemainingTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"balanceQuantity"]]) {
                
                self.balanceQuantity = [dictInfo objectForKey:@"balanceQuantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderDeliveryList"]]) {
                
                self.orderDeliveryList = [dictInfo objectForKey:@"orderDeliveryList"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderGoodsItems"]]) {
                
                self.orderGoodsItemsList = [dictInfo objectForKey:@"orderGoodsItems"];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
