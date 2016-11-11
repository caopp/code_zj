//
//  CourierModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CourierModel.h"

@implementation CourierModel

- (void)setDictFrom:(NSDictionary *)dictInfo{
    if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            
            self.Id = [dictInfo objectForKey:@"id"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"acceptTime"]]) {
            
            self.acceptTime = [dictInfo objectForKey:@"acceptTime"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"acceptStation"]]) {
            
            self.acceptStation = [dictInfo objectForKey:@"acceptStation"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"remark"]]) {
            
            self.remark = [dictInfo objectForKey:@"remark"];
        }
        
    }
}

@end
