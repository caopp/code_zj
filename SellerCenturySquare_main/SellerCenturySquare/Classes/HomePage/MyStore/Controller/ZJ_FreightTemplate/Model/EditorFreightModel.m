//
//  EditorFreightModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/22.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "EditorFreightModel.h"

@implementation EditorFreightModel
- (void)setDictFrom:(NSDictionary *)dictInfo{
    if (self && dictInfo) {
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            self.Id = [dictInfo objectForKey:@"id"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isWholesale"]]) {
            self.isWholesale = [dictInfo objectForKey:@"isWholesale"];
        }
//        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isRetail"]]) {
//            self.isWholesale = [dictInfo objectForKey:@"isRetail"];
//        }
        
        
    }
}

@end
