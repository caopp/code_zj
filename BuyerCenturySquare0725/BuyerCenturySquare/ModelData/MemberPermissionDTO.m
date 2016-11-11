//
//  MemberPermissionDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MemberPermissionDTO.h"

@implementation MemberPermissionDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"level"]]) {
                
                self.level = [dictInfo objectForKey:@"level"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"amountLow"]]) {
                
                self.amountLow = [dictInfo objectForKey:@"amountLow"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"amountUp"]]) {
                
                self.amountUp = [dictInfo objectForKey:@"amountUp"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"advancePayment"]]) {
                
                self.advancePayment = [dictInfo objectForKey:@"advancePayment"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsBrowse"]]) {
                
                self.goodsBrowse = [dictInfo objectForKey:@"goodsBrowse"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsBrowse3"]]) {
                
                self.goodsBrowse3 = [dictInfo objectForKey:@"goodsBrowse3"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsBrowse5"]]) {
                
                self.goodsBrowse5 = [dictInfo objectForKey:@"goodsBrowse5"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsBrowse7"]]) {
                
                self.goodsBrowse7 = [dictInfo objectForKey:@"goodsBrowse7"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsBrowse10"]]) {
                
                self.goodsBrowse10 = [dictInfo objectForKey:@"goodsBrowse10"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsCollectAuth"]]) {
                
                self.goodsCollectAuth = [dictInfo objectForKey:@"goodsCollectAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"windowPicViewAuth"]]) {
                
                self.windowPicViewAuth = [dictInfo objectForKey:@"windowPicViewAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"detailPicViewAuth"]]) {
                
                self.detailPicViewAuth = [dictInfo objectForKey:@"detailPicViewAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"referPicViewAuth"]]) {
                
                self.referPicViewAuth = [dictInfo objectForKey:@"referPicViewAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downloadAuth"]]) {
                
                self.downloadAuth = [dictInfo objectForKey:@"downloadAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"freeDownloadQty"]]) {
                
                self.freeDownloadQty = [dictInfo objectForKey:@"freeDownloadQty"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"buyDownloadQty"]]) {
                
                self.buyDownloadQty = [dictInfo objectForKey:@"buyDownloadQty"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"buyDownloadPrice"]]) {
                
                self.buyDownloadPrice = [dictInfo objectForKey:@"buyDownloadPrice"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shareAuth"]]) {
                
                self.shareAuth = [dictInfo objectForKey:@"shareAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"supplierRecommendAuth"]]) {
                
                self.supplierRecommendAuth = [dictInfo objectForKey:@"supplierRecommendAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"openShopInstructionAuth"]]) {
                
                self.openShopInstructionAuth = [dictInfo objectForKey:@"openShopInstructionAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"buyersRecommendAuth"]]) {
                
                self.buyersRecommendAuth = [dictInfo objectForKey:@"buyersRecommendAuth"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.skuNo = [dictInfo objectForKey:@"skuNo"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
  }
@end
