//
//  FreightTempModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "FreightTempModel.h"

@implementation FreightTempModel

- (void)setDictFrom:(NSDictionary *)dictInfo{
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id = [dictInfo objectForKey:@"id"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isDefault"]]) {
                
                self.isDefault = [dictInfo objectForKey:@"isDefault"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"templateName"]]) {
                
                self.templateName = [dictInfo objectForKey:@"templateName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isWholesale"]]) {
                
                self.isWholesale = [dictInfo objectForKey:@"isWholesale"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isWholesaleDefault"]]) {
                
                self.isWholesaleDefault = [dictInfo objectForKey:@"isWholesaleDefault"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isRetail"]]) {
                
                self.isRetail = [dictInfo objectForKey:@"isRetail"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isRetailDefault"]]) {
                
                self.isRetailDefault = [dictInfo objectForKey:@"isRetailDefault"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sysDefault"]]) {
                
                self.sysDefault = [dictInfo objectForKey:@"sysDefault"];
            }

            
        }
   }


@end
