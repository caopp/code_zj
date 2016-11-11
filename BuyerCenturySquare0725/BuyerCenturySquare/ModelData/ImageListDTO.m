//
//  ImageListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ImageListDTO.h"

@implementation ImageListDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picName"]]) {
                
                self.picName = [dictInfo objectForKey:@"picName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picType"]]) {
                
                self.picType = [dictInfo objectForKey:@"picType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
