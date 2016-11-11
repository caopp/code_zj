//
//  MerchantHotLabelDTO.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/28.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MerchantHotLabelDTO.h"

@implementation MerchantHotLabelDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{

    if (dictInfo && [dictInfo isKindOfClass:[NSDictionary class]]) {
        
        if ([self checkLegitimacyForData:dictInfo[@"labelCategory"]]) {
            
            self.labelCategory = dictInfo[@"labelCategory"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"categoryNo"]]) {
            
            self.categoryNo = dictInfo[@"categoryNo"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"list"]]) {
            
            self.list = dictInfo[@"list"];
            
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"sort"]]) {
            
            self.sort = dictInfo[@"sort"];
            
        }
        
    }

}

@end
