//
//  CommodityClassificationDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CommodityClassificationDTO.h"

@implementation CommodityClassificationDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.id = [dictInfo objectForKey:@"id"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryNo"]]) {
                
                self.categoryNo = [dictInfo objectForKey:@"categoryNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryName"]]) {
                
                self.categoryName = [dictInfo objectForKey:@"categoryName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"level"]]) {
                
                self.level = [dictInfo objectForKey:@"level"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"structureName"]]) {
                
                self.structureName = [dictInfo objectForKey:@"structureName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"structureNo"]]) {
                
                self.structureNo = [dictInfo objectForKey:@"structureNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"parentId"]]) {
                
                self.parentId = [dictInfo objectForKey:@"parentId"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
