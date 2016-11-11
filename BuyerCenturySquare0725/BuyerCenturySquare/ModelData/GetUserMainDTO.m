//
//  GetUserMainDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetUserMainDTO.h"

@implementation GetUserMainDTO


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
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
