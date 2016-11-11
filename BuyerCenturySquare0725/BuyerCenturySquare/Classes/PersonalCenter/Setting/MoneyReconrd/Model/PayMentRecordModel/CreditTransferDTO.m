//
//  CreditTransferDTO.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CreditTransferDTO.h"

@implementation CreditTransferDTO


-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        
        if (self && dictInfo) {
        
            if ([self checkLegitimacyForData:dictInfo[@"subject"]]) {
                
                self.subject = dictInfo[@"subject"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"auditStatus"]]) {
                
                self.auditStatus = dictInfo[@"auditStatus"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"amount"]]) {
                
                self.amount = [dictInfo[@"amount"] doubleValue];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"createDate"]]) {
                
                self.createDate = dictInfo[@"createDate"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"paymethod"]]) {
                
                self.paymethod = dictInfo[@"paymethod"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"auditNo"]]) {
                
                self.auditNo = dictInfo[@"auditNo"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"bankName"]]) {
                
                self.bankName = dictInfo[@"bankName"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"userName"]]) {
                
                self.userName = dictInfo[@"userName"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"level"]]) {
                
                self.level = dictInfo[@"level"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"tradeNo"]]) {
                
                self.tradeNo = dictInfo[@"tradeNo"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"bankCode"]]) {
                
                self.bankCode = dictInfo[@"bankCode"];
                
            }
        
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
