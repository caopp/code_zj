//
//  GetSetPasswordDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetSetPasswordDTO.h"

@implementation GetSetPasswordDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tokenId"]]) {
                
                self.tokenId = [dictInfo objectForKey:@"tokenId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
