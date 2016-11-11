//
//  AttrListDTO.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AttrListDTO.h"

@implementation AttrListDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            
            self.id = [dictInfo objectForKey:@"id"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"attrName"]]) {
            
            self.attrName = [dictInfo objectForKey:@"attrName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"attrValText"]]) {
            
            self.attrValText = [dictInfo objectForKey:@"attrValText"];
        }

    }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


   @end
