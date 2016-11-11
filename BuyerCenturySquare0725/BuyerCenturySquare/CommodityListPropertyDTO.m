//
//  CommodityListPropertyDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CommodityListPropertyDTO.h"
@implementation CommodityListPropertyDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                //self.price = [[NSNumber alloc] initWithDouble:[[dictInfo objectForKey:@"price"] doubleValue]];
                self.price = [dictInfo objectForKey:@"price"];;
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imgUrl"]]) {
                
                self.imgUrl = [dictInfo objectForKey:@"imgUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sendTime"]]) {
                
                self.sendTime = [dictInfo objectForKey:@"sendTime"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"firstOnsaleTime"]]) {
                
                self.firstOnsaleTime = [dictInfo objectForKey:@"firstOnsaleTime"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"remark"]]) {
                
                self.remark = [dictInfo objectForKey:@"remark"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"readLevel"]]) {
                
                self.readLevel = [dictInfo objectForKey:@"readLevel"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"authFlag"]]) {
                
                self.authFlag = [dictInfo objectForKey:@"authFlag"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsType"]]) {
                
                self.goodsType = [dictInfo objectForKey:@"goodsType"];
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
