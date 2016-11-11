//
//  GetMemberApplyInfoDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMemberApplyInfoDTO.h"

@implementation GetMemberApplyInfoDTO

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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sex"]]) {
                
                NSString *sex = [dictInfo objectForKey:@"sex"];
                
                sex = [sex isEqualToString:@"1"]?@"男":@"女";
                
                self.sex = sex;
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberTel"]]) {
                
                self.memberTel = [dictInfo objectForKey:@"memberTel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"identityNo"]]) {
                
                self.identityNo = [dictInfo objectForKey:@"identityNo"];
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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"businessLicenseNo"]]) {
                
                self.businessLicenseNo = [dictInfo objectForKey:@"businessLicenseNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"businessLicenseUrl"]]) {
                
                self.businessLicenseUrl = [dictInfo objectForKey:@"businessLicenseUrl"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end
