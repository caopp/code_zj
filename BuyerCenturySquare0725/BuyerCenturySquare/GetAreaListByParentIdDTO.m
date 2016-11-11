//
//  GetAreaListByParentIdDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetAreaListByParentIdDTO.h"

@implementation GetAreaListByParentIdDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id  = [dictInfo objectForKey:@"id"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"parentId"]]) {
                
                self.parentId = [dictInfo objectForKey:@"parentId"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"name"]]) {
                
                self.name = [dictInfo objectForKey:@"name"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
