//
//  NewAndModifyTemplateModel.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "NewAndModifyTemplateModel.h"

@implementation NewAndModifyTemplateModel


- (void)setDictFrom:(NSDictionary *)dictInfo{
    
    
    
    if (self && dictInfo) {
        
//        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"expressAreaId"]]) {
//            
//            self.expressAreaId = [dictInfo objectForKey:@"expressAreaId"];
//        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"frontFreight"]]) {
            
            self.frontFreight = [dictInfo objectForKey:@"frontFreight"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"afterFreight"]]) {
            
            self.afterFreight = [dictInfo objectForKey:@"afterFreight"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"frontWeight"]]) {
            
            self.frontWeight = [dictInfo objectForKey:@"frontWeight"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"afterWeight"]]) {
            
            self.afterWeight = [dictInfo objectForKey:@"afterWeight"];
        }
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"frontQuantity"]]) {
            
            self.frontQuantity = [dictInfo objectForKey:@"frontQuantity"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"afterQuantity"]]) {
            
            self.afterQuantity = [dictInfo objectForKey:@"afterQuantity"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"expressArea"]]) {
            
            self.expressArea = [dictInfo objectForKey:@"expressArea"];
        }
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isDefault"]]) {
            
            self.isDefault = [dictInfo objectForKey:@"isDefault"];
        }

        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
            
            self.sort = [dictInfo objectForKey:@"sort"];
        }
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"templateId"]]) {
            
            self.templateId = [dictInfo objectForKey:@"templateId"];
        }
        
    }

}



@end
