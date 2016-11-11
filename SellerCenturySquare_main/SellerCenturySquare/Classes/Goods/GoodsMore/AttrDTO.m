//
//  AttrDTO.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/28.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "AttrDTO.h"

@implementation AttrDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.attrId = [dictInfo objectForKey:@"id"];
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
