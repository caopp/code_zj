//
//  GetOrderDetailDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetOrderDetailDTO.h"

@implementation OrderDeliveryDTO


-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
                
                self.orderCode = [dictInfo objectForKey:@"orderCode"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"deliveryReceiptImage"]]) {
                
                self.deliveryReceiptImage = [dictInfo objectForKey:@"deliveryReceiptImage"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createTime"]]) {
                
                self.createTime = [dictInfo objectForKey:@"createTime"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"type"]]) {
                
                self.type = dictInfo[@"type"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"logisticCode"]]) {
                
                self.logisticCode = dictInfo[@"logisticCode"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"logisticTrackNo"]]) {
                
                self.logisticTrackNo = dictInfo[@"logisticTrackNo"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"logisticName"]]) {
                
                self.logisticName = dictInfo[@"logisticName"];
                
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end

@implementation GetOrderDetailDTO
- (id)init{
    self = [super init];
    if (self) {
        self.goodsList = [[NSMutableArray alloc]init];
        self.orderDeliveryDTOList = [[NSMutableArray alloc]init];
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
            
            if ([self checkLegitimacyForData:dictInfo[@"paidTotalAmount"]]) {
                self.paidTotalAmount = dictInfo[@"paidTotalAmount"];
                
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"dealCancelTime"]]) {
                
                self.dealCancelTime = [dictInfo objectForKey:@"dealCancelTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"nickName"]]) {
                
                self.nickName = [dictInfo objectForKey:@"nickName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"chatAccount"]]) {
                
                self.chatAccount = [dictInfo objectForKey:@"chatAccount"];
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"confirmRemainingTime"]]) {
                
                self.confirmRemainingTime = [dictInfo objectForKey:@"confirmRemainingTime"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"dFee"]]) {
                
                self.dFee = dictInfo[@"dFee"];
                
            }
            //!快递单列表
            if ([self checkLegitimacyForData:dictInfo[@"orderDelivery"]]) {
                
                self.orderDeliveryDTOList = [NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary * dic in dictInfo[@"orderDelivery"]) {
                    
                    OrderDeliveryDTO * deliverDTO = [[OrderDeliveryDTO alloc]initWithDictionary:dic];
                    
                    [self.orderDeliveryDTOList addObject:deliverDTO];
                    
                }
                
                
            }
            //!商品信息列表
            if ([self checkLegitimacyForData:dictInfo[@"orderGoodsItems"]]) {
                
                self.goodsList = [NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary * dic in dictInfo[@"orderGoodsItems"]) {
                    
                    orderGoodsItemDTO * orderGoodsDTO = [[orderGoodsItemDTO alloc]initWithDictionary:dic];
                    
                    [self.goodsList addObject:orderGoodsDTO];
                }
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"oldPaidTotalAmount"]]) {
                
                self.oldPaidTotalAmount = dictInfo[@"oldPaidTotalAmount"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"refundNo"]]) {
                
                self.refundNo = dictInfo[@"refundNo"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"refundFee"]]) {
                
                self.refundFee = dictInfo[@"refundFee"];
            }
           
            if ([self checkLegitimacyForData:dictInfo[@"refundStatus"]]) {
                
                self.refundStatus = dictInfo[@"refundStatus"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"refundCreateTime"]]) {
                
                self.refundCreateTime = dictInfo[@"refundCreateTime"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"refundDealTime"]]) {
                
                self.refundDealTime = dictInfo[@"refundDealTime"];
            }
            
            //!配送方式/运费模板的名称
            if ([self checkLegitimacyForData:dictInfo[@"freightTemplateName"]]) {
                
                self.freightTemplateName = dictInfo[@"freightTemplateName"];
            }
            
            //!积分抵扣金额
            if ([self checkLegitimacyForData:dictInfo[@"integralAmount"]]) {
                
                self.integralAmount = dictInfo[@"integralAmount"];
            }
            
            //!抵扣积分数量
            if ([self checkLegitimacyForData:dictInfo[@"useIntegralNum"]]) {
                
                self.useIntegralNum = dictInfo[@"useIntegralNum"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
   
}

@end
