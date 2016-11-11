//
//  GetAppVersionDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetAppVersionDTO.h"

@implementation GetAppVersionDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downUrl"]]) {
                
                self.downUrl = [dictInfo objectForKey:@"downUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"version"]]) {
                
                self.version = [dictInfo objectForKey:@"version"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
