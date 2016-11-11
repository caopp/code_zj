//
//  RecommendReceiverDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendReceiverDTO.h"

@implementation RecommendReceiverDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"nickName"]]) {
                
                self.nickName = [dictInfo objectForKey:@"nickName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]) {
                
                self.memberName = [dictInfo objectForKey:@"memberName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberAccount"]]) {
                
                self.memberAccount = [dictInfo objectForKey:@"memberAccount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberLevel"]]) {
                
                self.memberLevel = [dictInfo objectForKey:@"memberLevel"];
            }
            
            self.memberName = self.nickName;
            if (![self.memberName length]) {
                self.memberName = self.memberName;

            }
            if (![self.memberName length]) {
                NSString *nickAccount = [self.memberAccount  stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                self.memberName = nickAccount;
                
            }
            if([self.memberName isEqualToString:self.memberAccount]){
                NSString *nickAccount = [self.memberAccount  stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                self.memberName = nickAccount;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
