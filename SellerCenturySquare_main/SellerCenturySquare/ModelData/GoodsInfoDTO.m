//
//  SecondGoodsInfoDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GoodsInfoDTO.h"

@implementation StepDTO


-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id = [dictInfo objectForKey:@"id"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"minNum"]]) {
                
                self.minNum = [dictInfo objectForKey:@"minNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"maxNum"]]) {
                
                self.maxNum = [dictInfo objectForKey:@"maxNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


- (NSMutableDictionary* )getDictFrom:(StepDTO *)stepDTO{
    
    NSMutableDictionary *currentNSDictionary = [[NSMutableDictionary alloc] init];
    
    @try {
        if (self && stepDTO) {
            
            if (stepDTO.Id != nil) {
                
                [currentNSDictionary setObject:stepDTO.Id forKey:@"id"];
            }
            
            if (stepDTO.price != nil) {
                
                [currentNSDictionary setObject:stepDTO.price forKey:@"price"];
            }
            
            if (stepDTO.minNum != nil) {
                
                [currentNSDictionary setObject:stepDTO.minNum forKey:@"minNum"];
            }
            
            if (stepDTO.maxNum != nil) {
                
                [currentNSDictionary setObject:stepDTO.maxNum forKey:@"maxNum"];
            }
            if (stepDTO.sort != nil) {
                
                [currentNSDictionary setObject:stepDTO.sort forKey:@"sort"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return currentNSDictionary;
    }
}

@end

@implementation PicDTO


-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picName"]]) {
                
                self.picName = [dictInfo objectForKey:@"picName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picType"]]) {
                
                self.picType = [dictInfo objectForKey:@"picType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picStatus"]]) {
                
                self.picStatus = [dictInfo objectForKey:@"picStatus"];
            }

        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end

@implementation SkuDTO


-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.skuNo = [dictInfo objectForKey:@"skuNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"Id"]]) {
                
                self.Id = [dictInfo objectForKey:@"Id"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuName"]]) {
                
                self.skuName = [dictInfo objectForKey:@"skuName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuStock"]]) {
                
                self.skuStock = [dictInfo objectForKey:@"skuStock"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"showStockFlag"]]) {
                
                self.showStockFlag = [dictInfo objectForKey:@"showStockFlag"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (NSMutableDictionary* )getDictFrom:(SkuDTO *)skuDTO{
    
    NSMutableDictionary *currentNSDictionary = [[NSMutableDictionary alloc] init];
    @try {
        if (self && skuDTO) {
            
            if (skuDTO.skuNo != nil) {
                
                [currentNSDictionary setObject:skuDTO.skuNo forKey:@"skuNo"];
            }
            
            if (skuDTO.showStockFlag != nil) {
                
                [currentNSDictionary setObject:skuDTO.showStockFlag forKey:@"showStockFlag"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return currentNSDictionary;
    }
}
@end