//
//  PersonalCenterDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "PersonalCenterDTO.h"

@implementation PersonalCenterDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"notPayOrderNum"]]) {
                
                self.notPayOrderNum = [dictInfo objectForKey:@"notPayOrderNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"unshippedNum"]]) {
                
                self.unshippedNum = [dictInfo objectForKey:@"unshippedNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"untakeOrderNum"]]) {
                
                self.untakeOrderNum = [dictInfo objectForKey:@"untakeOrderNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderNum"]]) {
                
                self.orderNum = [dictInfo objectForKey:@"orderNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"noticeStationNum"]]) {
                
                self.noticeStationNum = [dictInfo objectForKey:@"noticeStationNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picNum"]]) {
                
                self.picNum = [dictInfo objectForKey:@"picNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"replenishNum"]]) {
                
                self.replenishNum = [dictInfo objectForKey:@"replenishNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"subscribeNum"]]) {
                
                self.subscribeNum = [dictInfo objectForKey:@"subscribeNum"];
            }
            
            
            //!采购车数量(类型 int)
            if ([self checkLegitimacyForData:dictInfo[@"cartNum"]]) {
                
                self.cartNum = dictInfo[@"cartNum"];
                
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"availableAmount"]]) {
                
                self.payNum = dictInfo[@"availableAmount"];
            
            }
            if ([self checkLegitimacyForData:dictInfo[@"applyFlag"]]) {
                
                self.applyFlag = dictInfo[@"applyFlag"];
                
            }

            
            
            
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
