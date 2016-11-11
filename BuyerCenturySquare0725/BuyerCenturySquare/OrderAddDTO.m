//
//  OrderAddDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "OrderAddDTO.h"

@implementation OrderAddDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tradeNo"]]) {
                
                self.tradeNo = [dictInfo objectForKey:@"tradeNo"];
            }

            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tradeData"]]) {
                
                NSDictionary * tradeData = [dictInfo objectForKey:@"tradeData"];
                self.tradeDto = [[TradeDataDTO alloc] init];
                [self.tradeDto setDictFrom:tradeData];
                self.totalAmount = self.tradeDto.totalAmount;
                self.tradeNo = self.tradeDto.tradeNo;
                
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"canPayOrders"]]) {
                
                NSArray *canOrderArr = [dictInfo objectForKey:@"canPayOrders"];
                self.canPayOrdersArr = [NSMutableArray array];
                for (NSDictionary *dict in canOrderArr) {
                    CanPayOrdersDTO *canPayDto = [[CanPayOrdersDTO alloc] init];
                    [canPayDto setDictFrom:dict];
                    [self.canPayOrdersArr addObject:canPayDto];
                }
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cannotPayOrders"]]) {
                
                NSArray *cannotPayArr = [dictInfo objectForKey:@"cannotPayOrders"];
                self.cannotPayOrdersArr = [NSMutableArray array];
                for (NSDictionary*dict in cannotPayArr) {
                    CannotPayOrdersDTO *orderDto = [[CannotPayOrdersDTO alloc] init];
                    [orderDto setDictFrom:dict];
                    [self.cannotPayOrdersArr addObject:orderDto];
                    
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

@implementation TradeDataDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tradeNo"]]) {
                
                self.tradeNo = [dictInfo objectForKey:@"tradeNo"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


@end

@implementation CanPayOrdersDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
                
                self.orderCode = [dictInfo objectForKey:@"orderCode"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderType"]]) {
                
                self.orderType = [dictInfo objectForKey:@"orderType"];
            }
            
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"typeTitle"]]) {
                
                self.typeTitle = [dictInfo objectForKey:@"typeTitle"];
            }
            
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}



@end

@implementation CannotPayOrdersDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderCode"]]) {
                
                self.orderCode = [dictInfo objectForKey:@"orderCode"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderType"]]) {
                
                self.orderType = [dictInfo objectForKey:@"orderType"];
            }
            
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"typeTitle"]]) {
                
                self.typeTitle = [dictInfo objectForKey:@"typeTitle"];
            }
            
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


@end
