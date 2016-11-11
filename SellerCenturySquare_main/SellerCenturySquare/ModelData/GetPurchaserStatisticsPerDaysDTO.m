//
//  GetPurchaserStatisticsPerDaysDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-10-19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetPurchaserStatisticsPerDaysDTO.h"

@implementation GetPurchaserStatisticsPerDaysDTO
- (id)init{
    self = [super init];
    if (self) {
        self.salesStatisticsDTOList = [[NSArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"betweenTime"]]) {
                
                self.betweenTime = [dictInfo objectForKey:@"betweenTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNum"]]) {
                
                self.memberNum = [dictInfo objectForKey:@"memberNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                self.salesStatisticsDTOList = [dictInfo objectForKey:@"list"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end

@implementation SalesStatisticsDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]) {
                
                self.memberName = [dictInfo objectForKey:@"memberName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"mobile"]]) {
                
                self.mobile = [dictInfo objectForKey:@"mobile"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"amount"]]) {
                
                self.amount = [dictInfo objectForKey:@"amount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"provinceName"]]) {
                
                self.provinceName = [dictInfo objectForKey:@"provinceName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cityName"]]) {
                
                self.cityName = [dictInfo objectForKey:@"cityName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"countryName"]]) {
                
                self.countryName = [dictInfo objectForKey:@"countryName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"detailAddress"]]) {
                
                self.detailAddress = [dictInfo objectForKey:@"detailAddress"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
