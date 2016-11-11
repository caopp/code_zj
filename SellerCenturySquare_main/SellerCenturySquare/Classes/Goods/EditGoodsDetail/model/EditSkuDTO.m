//
//  EditSkuDTO.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "EditSkuDTO.h"

@implementation EditSkuDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    if (self && dictInfo) {
        
        @try {
            
            if ([self checkLegitimacyForData:dictInfo[@"skuNo"]]) {
                
                self.skuNo = dictInfo[@"skuNo"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"id"]]) {
                
                self.Id = [dictInfo[@"id"] integerValue];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"skuName"]]) {
                
                self.skuName = dictInfo[@"skuName"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"skuStock"]]) {
                
                self.skuStock = [dictInfo[@"skuStock"] integerValue];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"showStockFlag"]]) {
                
                self.showStockFlag = dictInfo[@"showStockFlag"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"sort"]]) {
                
                self.sort = dictInfo[@"sort"];
                
            }
            
            
        }
        @catch (NSException *exception) {
            
            
        }
        @finally {
            
            
        }
        
        
        
        
    }
    
}


@end
