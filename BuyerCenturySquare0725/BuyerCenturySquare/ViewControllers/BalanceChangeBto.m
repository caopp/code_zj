//
//  BalanceChangeBto.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BalanceChangeBto.h"

@implementation BalanceChangeBto

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (self &&dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"level"]]) {
                self.level = dictInfo[@"level"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"balance"]]) {
                self.balancDic = [NSMutableDictionary dictionary];
                BalanceBTO *balance = [[BalanceBTO alloc] initWithDictionary:dictInfo[@"balance"]];
                [self.balancDic setObject:balance forKey:@"balance"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"prepayList"]]) {
                self.prepayListArr = [NSMutableArray array];
                NSArray *arr = dictInfo[@"prepayList"];
                
                if (arr.count <=1) {
                    PrepayList *preList = [[PrepayList alloc] initWithDictionary:arr[0]];
                    [self.prepayListArr addObject:preList];
                    
                    
                }else
                {
                for (NSDictionary *dic in dictInfo[@"prepayList"]) {
                    PrepayList *preList = [[PrepayList alloc] initWithDictionary:dic];
                    [self.prepayListArr addObject:preList];
                            
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


@implementation BalanceBTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:dictInfo[@"availableAmount"]]) {
                self.availableAmount = dictInfo[@"availableAmount"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"freezeAmount"]]) {
                self.freezeAmount = dictInfo[@"freezeAmount"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"memberNo"]]) {
                self.memberNo = dictInfo[@"memberNo"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"memberType"]]) {
                self.memberType = dictInfo[@"memberType"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"totalAmount"]]) {
                self.totalAmount = dictInfo[@"totalAmount"];
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
 
}


@end

@implementation PrepayList

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:dictInfo[@"level"]]) {
                self.level = dictInfo[@"level"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"advancePayment"]]) {
                self.advancePayment = dictInfo[@"advancePayment"];
    
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"goodsNo"]]) {
                self.goodsNo = dictInfo[@"goodsNo"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"skuNo"]]) {
                self.skuNo = dictInfo[@"skuNo"];
                
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


@end