//
//  MemberTradeDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MemberTradeDTO.h"

@implementation MemberTradeDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]) {
                
                self.memberName = [dictInfo objectForKey:@"memberName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"mobilePhone"]]) {
                
                self.mobilePhone = [dictInfo objectForKey:@"mobilePhone"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"time"]]) {
                
                self.time = [dictInfo objectForKey:@"time"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"amount"]]) {
                
                self.amount = [dictInfo objectForKey:@"amount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tradeLevel"]]) {
                
                self.tradeLevel = [dictInfo objectForKey:@"tradeLevel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopLevel"]]) {
                
                self.shopLevel = [dictInfo objectForKey:@"shopLevel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"chatAccount"]]) {
                
                self.chatAccount = [dictInfo objectForKey:@"chatAccount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"nickName"]]) {
                
                self.nickName = [dictInfo objectForKey:@"nickName"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
