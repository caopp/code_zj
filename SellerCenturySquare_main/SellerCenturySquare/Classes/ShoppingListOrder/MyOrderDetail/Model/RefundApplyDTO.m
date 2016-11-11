//
//  RefundApplyDTO.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "RefundApplyDTO.h"

@implementation RefundApplyDTO

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (!dictInfo) {
            return;
        }
        if ([self checkLegitimacyForData:dictInfo[@"orderCode"]]) {
            
            self.orderCode = dictInfo[@"orderCode"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"refundType"]]) {
            
            self.refundType = dictInfo[@"refundType"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"refundReason"]]) {
            
            self.refundReason = dictInfo[@"refundReason"];
        }
        if ([self checkLegitimacyForData:dictInfo[@"goodsStatus"]]) {
            
            self.goodsStatus = dictInfo[@"goodsStatus"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"refundFee"]]) {
            
            self.refundFee = dictInfo[@"refundFee"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"remark"]]) {
            
            self.remark = dictInfo[@"remark"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"pics"]]) {
            
            self.pics = dictInfo[@"pics"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"refundStatus"]]) {
            
            self.refundStatus = dictInfo[@"refundStatus"];
        }
        
        
        
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


@end
