//
//  GetOrderDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetOrderDTO.h"
#import "orderGoodsItemDTO.h"
@implementation OrderListAllDTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (self &&dictInfo) {
            if ([self checkLegitimacyForData:dictInfo[@"totalCount"]]) {
                self.totalCount = [dictInfo[@"totalCount"] integerValue];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"orderList"]]) {
                self.orderListArr = [NSMutableArray array];
                NSArray *orders = dictInfo[@"orderList"];
                if (orders.count>0) {
                    for (NSDictionary *getDict in orders) {
                        GetOrderDTO *orderDto = [[GetOrderDTO alloc] init];
                        orderDto.channelType = self.channelType;
                        [orderDto setDictFrom:getDict];
                        [self.orderListArr addObject:orderDto];
                        
                    }
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end


@implementation GetOrderDTO

- (id)init{
    self = [super init];
    if (self) {
        self.goodsList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"consigneePhone"]]) {
                
                self.consigneePhone = [dictInfo objectForKey:@"consigneePhone"];
            }

            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"consigneeName"]]) {
                
                self.consigneeName = [dictInfo objectForKey:@"consigneeName"];
            }
 
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"addressId"]]) {
                
                self.addressId = [dictInfo objectForKey:@"addressId"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]) {
                
                self.memberName = [dictInfo objectForKey:@"memberName"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"nickName"]]) {
                
                self.nickName = [dictInfo objectForKey:@"nickName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberPhone"]]) {
                
                self.memberPhone = [dictInfo objectForKey:@"memberPhone"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
                
                self.orderCode = [dictInfo objectForKey:@"orderCode"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"status"]]) {
                
                self.status = [dictInfo objectForKey:@"status"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
                
                self.quantity = [dictInfo objectForKey:@"quantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"originalTotalAmount"]]) {
                
                self.originalTotalAmount = [dictInfo objectForKey:@"originalTotalAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"paidTotalAmount"]]) {
                self.paidTotalAmount = dictInfo[@"paidTotalAmount"];
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
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
            
            self.markStatus = @"no";
            
    
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"chatAccount"]]) {
                
                self.chatAccount = [dictInfo objectForKey:@"chatAccount"];
            }
            
                    if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderGoodsItems"]]) {
                        
                       NSArray *array = [dictInfo objectForKey:@"orderGoodsItems"];
                        self.goodsList = [NSMutableArray array];
                        
                        for (NSDictionary *dict in array) {
                            orderGoodsItemDTO *orderDto = [[orderGoodsItemDTO alloc] init];
                            [orderDto setDictFrom:dict];
                            [self.goodsList addObject:orderDto];
                        }
                    }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
