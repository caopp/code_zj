//
//  ConsigneeAddressDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ConsigneeAddressDTO.h"

@implementation ConsigneeAddressDTO

-(BOOL)getParameterIsLack
{
    if ([self.consigneeName isEqual: @""] || [self.consigneePhone isEqual: @""] ||
        [self.provinceNo isEqual: @""] ||[self.cityNo isEqual: @""] ||
        [self.countyNo isEqual: @""]|| [self.detailAddress isEqual: @""]||
        [self.defaultFlag isEqual: @""] || [self.tokenId isEqual:@""] ||[self.merberNo isEqual:@""]){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}
@end
