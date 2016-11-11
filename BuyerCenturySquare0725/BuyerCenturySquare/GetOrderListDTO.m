//
//  GetOrderListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetOrderListDTO.h"


@implementation GetOrderDTO

- (id)init{
    self = [super init];
    if (self) {
        self.orderGoodsItemsList = [[NSMutableArray alloc]init];
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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
                
                self.orderCode = [dictInfo objectForKey:@"orderCode"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"status"]]) {
                
                self.status = [dictInfo objectForKey:@"status"];
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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"balanceQuantity"]]) {
                
                self.balanceQuantity = [dictInfo objectForKey:@"balanceQuantity"];
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

@implementation GetOrderListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.getOrderDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
@end
