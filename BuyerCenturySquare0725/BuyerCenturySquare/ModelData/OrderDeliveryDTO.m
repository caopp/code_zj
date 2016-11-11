//
//  OrderDeliveryDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "OrderDeliveryDTO.h"

@implementation OrderDeliveryDTO
- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([dictInfo checkLegitimacyForData:dictInfo[@"orderCode"]]) {
                self.orderCode = dictInfo[@"orderCode"];
            }
            
            if ([dictInfo checkLegitimacyForData:dictInfo[@"deliveryReceiptImage"]]) {
                self.deliveryReceiptImage = dictInfo[@"deliveryReceiptImage"];
            }
            
            if ([dictInfo checkLegitimacyForData:dictInfo[@"createTime"]]) {
                self.createTime = dictInfo[@"createTime"];
                
            }
            
            if ([dictInfo checkLegitimacyForData:dictInfo[@"type"]]) {
                self.type = dictInfo[@"type"];
                
            }
            
            if ([dictInfo checkLegitimacyForData:dictInfo[@"logisticCode"]]) {
                self.logisticCode = dictInfo[@"logisticCode"];
                
            }
            
            
            if ([dictInfo checkLegitimacyForData:dictInfo[@"logisticTrackNo"]]) {
                
                self.logisticTrackNo = dictInfo[@"logisticTrackNo"];
            }
            
            if ([dictInfo checkLegitimacyForData:dictInfo[@"logisticName"]]) {
                self.logisticName = dictInfo[@"logisticName"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
