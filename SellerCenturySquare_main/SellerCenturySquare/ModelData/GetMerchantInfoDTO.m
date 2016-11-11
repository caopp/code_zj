//
//  GetMerchantInfoDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMerchantInfoDTO.h"

@implementation GetMerchantInfoDTO
static GetMerchantInfoDTO *getMerchantInfoDTO = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        getMerchantInfoDTO = [[self alloc] init];
    });
    return getMerchantInfoDTO;
    
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"level"]]) {
                
                self.level = [dictInfo objectForKey:@"level"];
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"pictureUrl"]]) {
                
                self.pictureUrl = [dictInfo objectForKey:@"pictureUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"operateStatus"]]) {
                
                NSString *operateStr = [dictInfo objectForKey:@"operateStatus"];
                
                self.operateStatus = [operateStr isEqualToString:@"0"]?YES:NO;
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantStatus"]]) {
                
                self.merchantStatus = [dictInfo objectForKey:@"merchantStatus"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeStartTime"]]) {
                
                self.closeStartTime = [dictInfo objectForKey:@"closeStartTime"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeEndTime"]]) {
                
                self.closeEndTime = [dictInfo objectForKey:@"closeEndTime"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchAmountFlag"]]) {
                
                self.batchAmountFlag = [dictInfo objectForKey:@"batchAmountFlag"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumFlag"]]) {
                
                self.batchNumFlag = [dictInfo objectForKey:@"batchNumFlag"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchAmountLimit"]]) {
                
                self.batchAmountLimit = [dictInfo objectForKey:@"batchAmountLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"monthIntegralNum"]]) {
                
                self.monthIntegralNum = [dictInfo objectForKey:@"monthIntegralNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"mobilePhone"]]) {
                
                self.mobilePhone = [dictInfo objectForKey:@"mobilePhone"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"telephone"]]) {
                
                self.telephone = [dictInfo objectForKey:@"telephone"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"wechatNo"]]) {
                
                self.wechatNo = [dictInfo objectForKey:@"wechatNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stallNo"]]) {
                
                self.stallNo = [dictInfo objectForKey:@"stallNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"description"]]) {
                
                self.Description = [dictInfo objectForKey:@"description"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downloadNum"]]) {
                
                self.downloadNum = [dictInfo objectForKey:@"downloadNum"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopkeeper"]]) {
                
                self.shopkeeper = [dictInfo objectForKey:@"shopkeeper"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"identityNo"]]) {
                
                self.identityNo = [dictInfo objectForKey:@"identityNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"provinceNo"]]) {
                
                self.provinceNo = [dictInfo objectForKey:@"provinceNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"provinceName"]]) {
                
                self.provinceName = [dictInfo objectForKey:@"provinceName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cityNo"]]) {
                
                self.cityNo = [dictInfo objectForKey:@"cityNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"cityName"]]) {
                
                self.cityName = [dictInfo objectForKey:@"cityName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"countyNo"]]) {
                
                self.countyNo = [dictInfo objectForKey:@"countyNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"countyName"]]) {
                
                self.countyName = [dictInfo objectForKey:@"countyName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"detailAddress"]]) {
                
                self.detailAddress = [dictInfo objectForKey:@"detailAddress"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"contractNo"]]) {
                
                self.contractNo = [dictInfo objectForKey:@"contractNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sex"]]) {
                
                self.sex = [dictInfo objectForKey:@"sex"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isMaster"]]) {
                
                NSString *isMaster = dictInfo[@"isMaster"];
                
                self.isMaster = [isMaster isEqualToString:@"0"]?YES:NO;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downloadLimit7"]]) {
                
                NSString *downloadLimit7Str = [dictInfo objectForKey:@"downloadLimit7"];
                
                if ([downloadLimit7Str isEqualToString:@"0"]) {
                    self.downloadLimit7 = YES;
                }else{
                    self.downloadLimit7 = NO;
                }
                
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"iconUrl"]]) {
                
                self.iconUrl = dictInfo[@"iconUrl"];
                
            }
            
            
            if ([self checkLegitimacyForData:dictInfo[@"categoryName"]]) {
                
                self.categoryName = dictInfo[@"categoryName"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"categoryNo"]]) {
                
                self.categoryNo = dictInfo[@"categoryNo"];
            }
            
            
            if ([self checkLegitimacyForData:dictInfo[@"notPayCOrderNum"]]) {
                
                self.notPayCOrderNum = dictInfo[@"notPayCOrderNum"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"unshippedCNum"]]) {
                
                self.unshippedCNum = dictInfo[@"unshippedCNum"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"untakeOrderCNum"]]) {
                
                self.untakeOrderCNum = dictInfo[@"untakeOrderCNum"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"refundOrderCNum"]]) {
                
                self.refundOrderCNum = dictInfo[@"refundOrderCNum"];
            }

        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (NSString*)convertToCompleteAddress {
    NSMutableString* completeAddress = [NSMutableString string];
    if (self.provinceName) {
        [completeAddress appendString:self.provinceName];
    }

    if (self.cityName) {
        [completeAddress appendString:self.cityName];
    }

    if (self.countyName) {
        [completeAddress appendString:self.countyName];
    }

    if (self.detailAddress) {
        [completeAddress appendString:self.detailAddress];
    }

    return completeAddress;
}
@end
