//
//  SelectedAreaModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SelectedAreaModel.h"

@implementation SelectedAreaModel

- (void)setDictFrom:(NSDictionary *)dictInfo{
    if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            
            self.Id = [dictInfo objectForKey:@"id"];
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

@end
