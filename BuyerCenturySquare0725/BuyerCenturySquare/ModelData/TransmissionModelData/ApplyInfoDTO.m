//
//  ApplyInfoDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ApplyInfoDTO.h"

@implementation ApplyInfoDTO

-(BOOL)getParameterIsLack
{
    if ([self.mobilePhone isEqual: @""]  || [self.provinceNo isEqual: @""] ||
        [self.cityNo isEqual: @""] ||[self.countyNo isEqual: @""] ||
        [self.detailAddress isEqual: @""] || [self.sex isEqual: @""]||
        [self.identityNo isEqual: @""] || [self.identityPicUrl isEqual: @""] ||
        [self.joinType isEqual: @""]||[self.businessLicenseNo isEqual: @""] || [self.businessLicenseUrl isEqual: @""] || [self.businessDesc isEqual: @""] ){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}





-(BOOL)getParameter{
    if ([self.mobilePhone isEqual: @""]  || [self.provinceNo isEqual: @""] ||
        [self.cityNo isEqual: @""] ||[self.countyNo isEqual: @""] ||
        [self.detailAddress isEqual: @""] || [self.sex isEqual: @""] ){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsParameter
{
    return  [self getParameter];
}




@end
