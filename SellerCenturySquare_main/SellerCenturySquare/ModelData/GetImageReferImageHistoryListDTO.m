//
//  GetImageReferImageHistoryListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-9-7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetImageReferImageHistoryListDTO.h"

@implementation GetImageReferImageHistoryListDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"uploadDate"]]) {
                
                self.uploadDate = [dictInfo objectForKey:@"uploadDate"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"auditStatus"]]) {
                
                self.auditStatus = [dictInfo objectForKey:@"auditStatus"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"qty"]]) {
                
                self.qty = [dictInfo objectForKey:@"qty"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imageUrls"]]) {
                
                self.imageUrlsList = [dictInfo objectForKey:@"imageUrls"];
            }
            
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
