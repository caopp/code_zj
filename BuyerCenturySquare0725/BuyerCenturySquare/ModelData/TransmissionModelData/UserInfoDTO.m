//
//  UserInfoDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "UserInfoDTO.h"

@implementation UserInfoDTO

-(BOOL)getParameterIsLack
{
    if ([self.nickName isEqual: @""] || [self.memberName isEqual: @""] ||
        [self.sex isEqual: @""] ||[self.mobilePhone isEqual: @""] ||
        [self.telephone isEqual: @""]|| [self.provinceNo isEqual: @""]||
        [self.cityNo isEqual: @""] || [self.countyNo isEqual: @""]||
        [self.detailAddress isEqual: @""]||[self.postalCode isEqual: @""]){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

@end
