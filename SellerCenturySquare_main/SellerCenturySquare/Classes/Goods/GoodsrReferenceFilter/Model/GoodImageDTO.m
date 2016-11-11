//
//  GoodImageDTO.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodImageDTO.h"

@implementation GoodImageDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
            
            self.Id = [dictInfo objectForKey:@"id"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"userName"]]) {
            
            self.userName = [dictInfo objectForKey:@"userName"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imageUrl"]]) {
            
            self.imageUrl = [dictInfo objectForKey:@"imageUrl"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createDate"]]) {
            
            self.createDate = [dictInfo objectForKey:@"createDate"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isDefault"]]) {
            
            self.isDefault = [dictInfo objectForKey:@"isDefault"];
        }

    }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}



@end
