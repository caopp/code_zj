//
//  GetPaymentsRecordsDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetPaymentsRecordsDTO.h"

@implementation PaymentsRecordsDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"amount"]]) {
                
                self.amount = [dictInfo objectForKey:@"amount"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createTime"]]) {
                
                self.createTime = [dictInfo objectForKey:@"createTime"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"outBizNo"]]) {
                
                self.outBizNo = [dictInfo objectForKey:@"outBizNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"recordId"]]) {
                
                self.recordId = [dictInfo objectForKey:@"recordId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"businessType"]]) {
                
                self.businessType = [dictInfo objectForKey:@"businessType"];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end

@implementation GetPaymentsRecordsDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"balance"]]) {
                
                self.balance = [dictInfo objectForKey:@"balance"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
                
                self.totalCount = [dictInfo objectForKey:@"totalCount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"items"]]) {
                
                self.paymentsRecordsDTOList = [dictInfo objectForKey:@"items"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
