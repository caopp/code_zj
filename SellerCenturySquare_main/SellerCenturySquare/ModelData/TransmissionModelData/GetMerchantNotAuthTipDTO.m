//
//  GetMerchantNotAuthTipDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMerchantNotAuthTipDTO.h"

@implementation GetMerchantNotAuthTipDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"readLevel"]]) {
                
                self.readLevel = [dictInfo objectForKey:@"readLevel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"currentLevel"]]) {
                
                self.currentLevel = [dictInfo objectForKey:@"currentLevel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"integralNum"]]) {
                
                self.integralNum = [dictInfo objectForKey:@"integralNum"];
            }
            
            if ([self.readLevel intValue] <= [self.currentLevel intValue]) {
                
                self.hasAuth = YES;
                
            }else{
                
                self.hasAuth = NO;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
