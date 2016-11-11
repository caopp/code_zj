//
//  MerchantShopDetailDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MerchantShopDetailDTO.h"

@implementation MerchantShopDetailDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryName"]]) {
                
                self.categoryName = [dictInfo objectForKey:@"categoryName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryNo"]]) {
                
                self.categoryNo = [dictInfo objectForKey:@"categoryNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"mobilePhone"]]) {
                
                self.mobilePhone = [dictInfo objectForKey:@"mobilePhone"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"wechatNo"]]) {
                
                self.wechatNo = [dictInfo objectForKey:@"wechatNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"description"]]) {
                
                
                self.merchantDescription = [dictInfo objectForKey:@"description"];
                
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
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stallNo"]]) {
                
                self.stallNo = [dictInfo objectForKey:@"stallNo"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"isFavorite"]]) {
                
                self.isFavorite = dictInfo[@"isFavorite"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"pictureUrl"]]) {
                
                self.pictureUrl = dictInfo[@"pictureUrl"];
                
            }
            
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
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
