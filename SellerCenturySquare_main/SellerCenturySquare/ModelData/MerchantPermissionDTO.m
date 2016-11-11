//
//  MerchantPermissionDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MerchantPermissionDTO.h"

@implementation MerchantPermissionDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"level"]]) {
                
                self.level = [dictInfo objectForKey:@"level"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopTopFlag"]]) {
                
                self.shopTopFlag = [dictInfo objectForKey:@"shopTopFlag"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"customerMgtAuth"]]) {
                
                self.customerMgtAuth = [dictInfo objectForKey:@"customerMgtAuth"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"blackList"]]) {
                
                self.blackList = [dictInfo objectForKey:@"blackList"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"giveDownloadQty"]]) {
                
                self.giveDownloadQty = [dictInfo objectForKey:@"giveDownloadQty"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"buyDownloadQty"]]) {
                
                self.buyDownloadQty = [dictInfo objectForKey:@"buyDownloadQty"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"buyDownloadPrice"]]) {
                
                self.buyDownloadPrice = [dictInfo objectForKey:@"buyDownloadPrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downloadAuthXb"]]) {
                
                self.downloadAuthXb = [dictInfo objectForKey:@"downloadAuthXb"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"freeSaleQty"]]) {
                
                self.freeSaleQty = [dictInfo objectForKey:@"freeSaleQty"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"paySalePrice"]]) {
                
                self.paySalePrice = [dictInfo objectForKey:@"paySalePrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"startAmount"]]) {
                
                self.startAmount = [dictInfo objectForKey:@"startAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"endAmount"]]) {
                
                self.endAmount = [dictInfo objectForKey:@"endAmount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"warnTip"]]) {
                
                self.warnTip = [dictInfo objectForKey:@"warnTip"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end
