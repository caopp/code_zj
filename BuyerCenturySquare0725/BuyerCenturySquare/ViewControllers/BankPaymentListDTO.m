//
//  BankPaymentListDTO.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BankPaymentListDTO.h"

@implementation BankPaymentListDTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:dictInfo[@"bankAccList"]]) {
                self.bankAccList = [[NSMutableArray alloc] init];
                
                NSDictionary *dic = [dictInfo[@"bankAccList"] lastObject];
                
                    BankAccListDTO *accList = [[BankAccListDTO alloc] init];
                    [accList setDictFrom:dic];
                    [self.bankAccList  addObject:accList];
                
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"prepayBankList"]]) {
                self.prepayBankList = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in dictInfo[@"prepayBankList"]) {
                    PrepayBankListDTO *perpayBank = [[PrepayBankListDTO alloc] init];
                  [perpayBank setDictFrom:dic];
                    
                    [self.prepayBankList addObject:perpayBank];
                    
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

@implementation BankAccListDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        
        if (self &&dictInfo) {
            if ([self checkLegitimacyForData:dictInfo[@"account"]]) {
                
                self.account = dictInfo[@"account"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"accountName"]]) {
                self.accountName = dictInfo[@"accountName"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"bankName"]]) {
                self.bankName = dictInfo[@"bankName"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"bankPic"]]) {
                self.bankPic = dictInfo[@"bankPic"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"id"]]) {
                self.id = dictInfo[@"id"];
                
            }
        
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end

@implementation PrepayBankListDTO

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:dictInfo[@"bankCode"]]) {
                self.bankCode = dictInfo[@"bankCode"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"bankName"]]) {
                self.bankName = dictInfo[@"bankName"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}



@end