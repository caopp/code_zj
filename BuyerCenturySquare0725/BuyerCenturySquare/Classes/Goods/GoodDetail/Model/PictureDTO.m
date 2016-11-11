//
//  PictureDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "PictureDTO.h"

@implementation PictureDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"zipUrl"]]) {
                
                self.zipUrl = [dictInfo objectForKey:@"zipUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picType"]]) {
                
                self.picType = [dictInfo objectForKey:@"picType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"qty"]]) {
                
                self.qty = [dictInfo objectForKey:@"qty"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picSize"]]) {
                
                self.picSize = [dictInfo objectForKey:@"picSize"];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
