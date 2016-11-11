//
//  RetailModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "RetailModel.h"

@implementation RetailModel
- (void)setDictFrom:(NSDictionary *)dictInfo{
    if (self && dictInfo) {
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            self.Id = [dictInfo objectForKey:@"id"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isRetail"]]) {
            self.isRetail = [dictInfo objectForKey:@"isRetail"];
        }
        
        
    }
}

@end
