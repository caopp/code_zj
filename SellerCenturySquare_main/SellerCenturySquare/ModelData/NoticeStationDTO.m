//
//  NoticeStationDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "NoticeStationDTO.h"

@implementation NoticeStationDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id = [dictInfo objectForKey:@"id"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"infoTitle"]]) {
                
                self.infoTitle = [dictInfo objectForKey:@"infoTitle"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"infoContent"]]) {
                
                self.infoContent = [dictInfo objectForKey:@"infoContent"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"readStatus"]]) {
                
                self.readStatus = [dictInfo objectForKey:@"readStatus"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sendTime"]]) {
                
                self.sendTime = [dictInfo objectForKey:@"sendTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createDate"]]) {
                
                self.createDate = [dictInfo objectForKey:@"createDate"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"failTime"]]) {
                
                self.failTime = [dictInfo objectForKey:@"failTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"listPic"]]) {
                
                self.listPic = [dictInfo objectForKey:@"listPic"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"infoType"]]) {
                
                self.infoType = [dictInfo objectForKey:@"infoType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"businessNo"]]) {
                
                self.businessNo = [dictInfo objectForKey:@"businessNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"businessType"]]) {
                
                self.businessType = [dictInfo objectForKey:@"businessType"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
