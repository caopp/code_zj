//
//  MemberInfoDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MemberInfoDTO.h"

@implementation MemberInfoDTO

static MemberInfoDTO *memberInfoDTO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        memberInfoDTO = [[self alloc] init];
    });
    return memberInfoDTO;
}


- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"nickName"]]) {
                
                self.nickName = [dictInfo objectForKey:@"nickName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberName"]]) {
                
                self.memberName = [dictInfo objectForKey:@"memberName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sex"]]) {
                
                self.sex = [dictInfo objectForKey:@"sex"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"mobilePhone"]]) {
                
                self.mobilePhone = [dictInfo objectForKey:@"mobilePhone"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"telephone"]]) {
                
                self.telephone = [dictInfo objectForKey:@"telephone"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"wechatNo"]]) {
                
                self.wechatNo = [dictInfo objectForKey:@"wechatNo"];
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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"postalCode"]]) {
                
                self.postalCode = [dictInfo objectForKey:@"postalCode"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberLevel"]]) {
                
                self.memberLevel = [dictInfo objectForKey:@"memberLevel"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"iconUrl"]]) {
                
                self.iconUrl = [dictInfo objectForKey:@"iconUrl"];
                
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(BOOL)getParameterIsLack
{
    if ([self.nickName  isEqual: @""] || [self.memberName  isEqual: @""] || [self.sex  isEqual: @""] ||
        [self.mobilePhone  isEqual: @""] || [self.telephone  isEqual: @""]|| [self.provinceNo  isEqual: @""]||
        [self.cityNo  isEqual: @""] || [self.countyNo  isEqual: @""]|| [self.detailAddress  isEqual: @""]||
        [self.postalCode  isEqual: @""]){
        
         return YES;
    
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}
@end
