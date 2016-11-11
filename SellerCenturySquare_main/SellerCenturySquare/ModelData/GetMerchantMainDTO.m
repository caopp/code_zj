//
//  GetMerchantMainDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-21.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMerchantMainDTO.h"

@implementation GetMerchantMainDTO

static GetMerchantMainDTO *getMerchantMainDTO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        getMerchantMainDTO = [[self alloc] init];
    });
    return getMerchantMainDTO;
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"notPayOrderNum"]]) {
                
                self.notPayOrderNum = [dictInfo objectForKey:@"notPayOrderNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"unshippedNum"]]) {
                
                self.unshippedNum = [dictInfo objectForKey:@"unshippedNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"untakeOrderNum"]]) {
                
                self.untakeOrderNum = [dictInfo objectForKey:@"untakeOrderNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"orderNum"]]) {
                
                self.orderNum = [dictInfo objectForKey:@"orderNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"noticeStationNum"]]) {
                
                self.noticeStationNum = [dictInfo objectForKey:@"noticeStationNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picNum"]]) {
                
                self.picNum = [dictInfo objectForKey:@"picNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"unReadGoodsNum"]]) {
                
                self.unReadGoodsNum = [dictInfo objectForKey:@"unReadGoodsNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundOrderNum"]]) {
                self.refundOrderNum = dictInfo[@"refundOrderNum"];
            }
            
            
            
            self.xbGoodsTotalCount = [NSNumber numberWithInteger:self.unshippedNum.integerValue + self.refundOrderNum.integerValue];
            
            
            if ([self checkLegitimacyForData:dictInfo[@"unReadOrderNum"]]) {
                
                self.unReadOrderNum = dictInfo[@"unReadOrderNum"];
                
            }
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"onSaleNum"]]) {
                
                self.onSaleNum = [dictInfo objectForKey:@"onSaleNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sendNum"]]) {
                
                self.sendNum = [dictInfo objectForKey:@"sendNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"offSaleNum"]]) {
                
                self.offSaleNum = [dictInfo objectForKey:@"offSaleNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsTotalCount"]]) {
                
                self.goodsTotalCount = [dictInfo objectForKey:@"goodsTotalCount"];
            }
            
            //c端
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"notPayCOrderNum"]]) {
                
                self.notPayCOrderNum = [dictInfo objectForKey:@"notPayCOrderNum"];
            }

            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"unshippedCNum"]]) {
                
                self.unshippedCNum = [dictInfo objectForKey:@"unshippedCNum"];
            }

            
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"untakeOrderCNum"]]) {
                
                self.untakeOrderCNum = [dictInfo objectForKey:@"untakeOrderCNum"];
            }

            
            
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refundOrderCNum"]]) {
                
                self.refundOrderCNum = [dictInfo objectForKey:@"refundOrderCNum"];
            }
            
            self.xcGoodsTotalCount = [NSNumber numberWithInteger:self.unshippedCNum.integerValue+self.refundOrderCNum.integerValue];
            

        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
