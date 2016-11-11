//
//  GetOrderSalesPerDaysDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetOrderSalesPerDaysDTO.h"

@implementation GetOrderSalesPerDaysDTO

- (id)init{
    self = [super init];
    if (self) {
        self.salesDTOList = [[NSArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"beginTime"]]) {
                
                self.beginTime = [dictInfo objectForKey:@"beginTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"endTime"]]) {
                
                self.endTime = [dictInfo objectForKey:@"endTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalNum"]]) {
                
                self.totalNum = [dictInfo objectForKey:@"totalNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                self.salesDTOList = [dictInfo objectForKey:@"list"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end

@implementation SalesDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createTime"]]) {
                
                self.createTime = [dictInfo objectForKey:@"createTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalAmount"]]) {
                
                self.totalAmount = [dictInfo objectForKey:@"totalAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orders"]]) {
                
                self.orders = [dictInfo objectForKey:@"orders"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end