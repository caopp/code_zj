//
//  UserApplyInfo.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "UserApplyInfo.h"

@implementation UserApplyInfo


- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"keyCode"]]) {
                
                self.keyCode = [dictInfo objectForKey:@"keyCode"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"pushCode"]]) {
                
                self.keyCode = [dictInfo objectForKey:@"pushCode"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"mobilePhone"]]) {
                
                self.mobilePhone = [dictInfo objectForKey:@"mobilePhone"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"telephone"]]) {
                
                self.telephone = [dictInfo objectForKey:@"telephone"];
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
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sex"]]) {
                
                self.sex = [dictInfo objectForKey:@"sex"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"identityNo"]]) {
                
                self.identityNo = [dictInfo objectForKey:@"identityNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"identityPicUrl"]]) {
                
                self.identityPicUrl = [dictInfo objectForKey:@"identityPicUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"createDate"]]) {
                
                self.createDate = [dictInfo objectForKey:@"createDate"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"businessLicenseNo"]]) {
                
                self.businessLicenseNo = [dictInfo objectForKey:@"businessLicenseNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"businessLicenseUrl"]]) {
                
                self.businessLicenseUrl = [dictInfo objectForKey:@"businessLicenseUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"businessDesc"]]) {
                
                self.businessDesc = [dictInfo objectForKey:@"businessDesc"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"status"]]) {
                
                self.applyStatus = [dictInfo objectForKey:@"status"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]) {
                
                self.memberName = [dictInfo objectForKey:@"memberName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopType"]]) {
                
                self.shopType = [dictInfo objectForKey:@"shopType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopName"]]) {
                
                self.shopName = [dictInfo objectForKey:@"shopName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"otherPlatform"]]) {
                
                self.otherPlatform = [dictInfo objectForKey:@"otherPlatform"];
            }
           
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
