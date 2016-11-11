//
//  WeChatMobilePayDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "WeChatMobilePayDTO.h"

@implementation WeChatMobilePayDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"appid"]]) {
                
                self.appId = [dictInfo objectForKey:@"appid"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"noncestr"]]) {
                
                self.nonceStr = [dictInfo objectForKey:@"noncestr"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"package"]]) {
                
                self.package = [dictInfo objectForKey:@"package"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"partnerid"]]) {
                
                self.partnerId = [dictInfo objectForKey:@"partnerid"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"prepayid"]]) {
                
                self.prepayId = [dictInfo objectForKey:@"prepayid"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sign"]]) {
                
                self.sign = [dictInfo objectForKey:@"sign"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"timestamp"]]) {
                
                self.timeStamp = [dictInfo objectForKey:@"timestamp"];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
