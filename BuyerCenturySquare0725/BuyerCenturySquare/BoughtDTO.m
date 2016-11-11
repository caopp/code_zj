//
//  BoughtDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BoughtDTO.h"

@implementation BoughtDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
                
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryNo"]]) {
                
                self.categoryNo = [dictInfo objectForKey:@"categoryNo"];
                
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryName"]]) {
                
                self.categoryName = [dictInfo objectForKey:@"categoryName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNum"]]) {
                
                self.goodsNum = [dictInfo objectForKey:@"goodsNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stallNo"]]) {
                self.stallNo = [dictInfo objectForKey:@"stallNo"];
            }
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
