//
//  AdressListModel.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AdressListModel.h"

@implementation AdressListModel
- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id = [dictInfo objectForKey:@"id"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"consigneeName"]]) {
                
                self.consigneeName = [dictInfo objectForKey:@"consigneeName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"consigneePhone"]]) {
                
                self.consigneePhone = [dictInfo objectForKey:@"consigneePhone"];
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
            
            //            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"postalCode"]]) {
            //
            //                self.postalCode = [dictInfo objectForKey:@"postalCode"];
            //            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"defaultFlag"]]) {
                
                self.defaultFlag = [dictInfo objectForKey:@"defaultFlag"];
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
    if ([self.Id isEqual: @""] || [self.consigneeName isEqual: @""] ||
        [self.consigneePhone isEqual: @""] ||[self.provinceNo isEqual: @""] ||
        [self.cityNo isEqual: @""]|| [self.countyNo isEqual: @""]||
        [self.detailAddress isEqual: @""] || [self.defaultFlag isEqual: @""]){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

- (NSString*)addressDescription {
    NSMutableString* addressString = [NSMutableString string];
    
    if (self.provinceName) {
        [addressString appendString:self.provinceName];
    }
    if (self.cityName) {
        [addressString appendString:self.cityName];
    }
    if (self.countyName) {
        [addressString appendString:self.countyName];
    }
    
    if (self.detailAddress) {
        [addressString appendString:self.detailAddress];
    }
    
    return addressString;
}


@end
