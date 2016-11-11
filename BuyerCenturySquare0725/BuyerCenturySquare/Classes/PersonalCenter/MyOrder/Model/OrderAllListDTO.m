//
//  OrderAllListDTO.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderAllListDTO.h"

@implementation OrderAllListDTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
   
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderList"]]) {
            self.orderInfoListArr = [NSMutableArray array];
            
            NSArray* groupDictList = [dictInfo objectForKey:@"orderList"];
            for (NSDictionary* groupInfoDict in groupDictList) {
                OrderInfoListDTO* orderGroupInfo = [[OrderInfoListDTO alloc]init];
                [orderGroupInfo setDictFrom:groupInfoDict];
                [self.orderInfoListArr addObject:orderGroupInfo];
            }
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
            NSNumber* totalCount = [dictInfo objectForKey:@"totalCount"];
            self.totalCount = totalCount;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

@end

@implementation OrderInfoListDTO

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (!dictInfo) {
            return;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"addressId"]]) {
            NSNumber* addressId = [dictInfo objectForKey:@"addressId"];
            self.addressId =  addressId.integerValue;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
            self.merchantName = [dictInfo objectForKey:@"merchantName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
            self.memberNo = [dictInfo objectForKey:@"memberNo"];
        }
        if ([self checkLegitimacyForData:dictInfo[@"merchantNo"]]) {
            self.merchantNo = dictInfo[@"merchantNo"];
        }
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
            self.orderCode = [dictInfo objectForKey:@"orderCode"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"originalTotalAmount"]]) {
            NSNumber* originalTotalAmount = [dictInfo objectForKey:@"originalTotalAmount"];
            self.originalTotalAmount =  originalTotalAmount;
        }
        if ([self checkLegitimacyForData:dictInfo[@"paidTotalAmount"]]) {
            NSNumber *paidTotalAmountNmb = dictInfo[@"paidTotalAmount"];
            self.paidTotalAmount = paidTotalAmountNmb;
            
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* quantity = [dictInfo objectForKey:@"quantity"];
            self.quantity =  quantity;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* status = [dictInfo objectForKey:@"status"];
            self.status =  status;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
            NSNumber* totalAmount = [dictInfo objectForKey:@"totalAmount"];
            self.totalAmount =  totalAmount;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
            NSNumber* type = [dictInfo objectForKey:@"type"];
            self.type =  type;
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"balanceQuantity"]]) {
            NSNumber *balanceQuantity = [dictInfo objectForKey:@"balanceQuantity"];
            self.balanceQuantity = balanceQuantity;
            
        }
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundNo"]]) {
            self.refundNo = [dictInfo objectForKey:@"refundNo"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundFee"]]) {
            self.refundFee = [dictInfo objectForKey:@"refundFee"];
        }

        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundStatus"]]) {
            self.refundStatus = [dictInfo objectForKey:@"refundStatus"];
        }

        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundCreateTime"]]) {
            self.refundCreateTime = [dictInfo objectForKey:@"refundCreateTime"];
        }

        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundDealTime"]]) {
            self.refundDealTime = [dictInfo objectForKey:@"refundDealTime"];
        }

        

        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderGoodsItems"]]) {
            self.goodsList = [NSMutableArray array];
            
            NSArray* goodsItemDictList = [dictInfo objectForKey:@"orderGoodsItems"];
            for (NSDictionary* goodsItemDict in goodsItemDictList) {
                OrderDetailMesssageDTO* orderGoodsInfo = [[OrderDetailMesssageDTO alloc]init];
                [orderGoodsInfo setDictFrom:goodsItemDict];
                [self.goodsList addObject:orderGoodsInfo];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

@end

@implementation OrderDetailMesssageDTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
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
            self.picUrl = [dictInfo objectForKey:@"picUrl"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
            NSNumber* price = [dictInfo objectForKey:@"price"];
            self.price =  price;
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
            NSNumber* quantity = [dictInfo objectForKey:@"quantity"];
            self.quantity =  quantity;
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

@end