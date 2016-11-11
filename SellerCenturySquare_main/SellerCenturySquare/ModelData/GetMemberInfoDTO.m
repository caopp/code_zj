//
//  GetMemberInfoDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMemberInfoDTO.h"

@implementation GetMemberInfoDTO
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
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"provinceNo"]]) {
                
                self.provinceNo = [dictInfo objectForKey:@"provinceNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"provinceName"]]) {
                
                self.provinceName = [dictInfo objectForKey:@"provinceName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cityNo"]]) {
                
                self.cityNo = [dictInfo objectForKey:@"cityNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cityName"]]) {
                
                self.cityName = [dictInfo objectForKey:@"cityName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"countyNo"]]) {
                
                self.countyNo = [dictInfo objectForKey:@"countyNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"countyName"]]) {
                
                self.countyName = [dictInfo objectForKey:@"countyName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"detailAddress"]]) {
                
                self.detailAddress = [dictInfo objectForKey:@"detailAddress"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tradeLevel"]]) {
                
                self.tradeLevel = [dictInfo objectForKey:@"tradeLevel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopLevel"]]) {
                
                self.shopLevel = [dictInfo objectForKey:@"shopLevel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"amount"]]) {
                
                self.amount = [dictInfo objectForKey:@"amount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"weekAmount"]]) {
                
                self.weekAmount = [dictInfo objectForKey:@"weekAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"lastMonthAmount"]]) {
                
                self.lastMonthAmount = [dictInfo objectForKey:@"lastMonthAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderNum"]]) {
                
                self.orderNum = [dictInfo objectForKey:@"orderNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"weekOrderNum"]]) {
                
                self.weekOrderNum = [dictInfo objectForKey:@"weekOrderNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"lastMonthOrderNum"]]) {
                
                self.lastMonthOrderNum = [dictInfo objectForKey:@"lastMonthOrderNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"chatAccount"]]) {
                
                self.chatAccount = [dictInfo objectForKey:@"chatAccount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"nickName"]]) {
                
                self.nickName = [dictInfo objectForKey:@"nickName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"blackListFlag"]]) {
                
                NSString *blackListFlagStr = [dictInfo objectForKey:@"blackListFlag"];
                
                self.blackListFlag = [blackListFlagStr isEqualToString:@"1"]?YES:NO;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
