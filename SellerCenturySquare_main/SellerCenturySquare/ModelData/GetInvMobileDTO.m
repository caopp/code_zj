//
//  GetInvMobileDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetInvMobileDTO.h"

@implementation GetInvMobileDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"invOpt"]]) {
                
                self.invOpt = [dictInfo objectForKey:@"invOpt"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberAccount"]]) {
                
                self.memberAccount = [dictInfo objectForKey:@"memberAccount"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end
