//
//  RecommendRecordDetailsDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendRecordDetailsDTO.h"



@implementation RecommendMemberDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
             if ([self checkLegitimacyForData:[dictInfo objectForKey:@"nickName"]]) {
                 self.memberName = [dictInfo objectForKey:@"nickName"];
             }
           
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]&&![self.memberName length]) {
                
                self.memberName = [dictInfo objectForKey:@"memberName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberAccount"]]&&![self.memberName length]) {
                NSString *nickAccount = [[dictInfo objectForKey:@"memberAccount"]  stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
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
