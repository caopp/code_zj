//
//  UpdateMerchantInfoModel.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "UpdateMerchantInfoModel.h"

@implementation UpdateMerchantInfoModel

-(BOOL)getParameterIsLack
{
    if (self.shopkeeper == nil || self.identityNo == nil || self.identityNo == nil || self.provinceNo == nil || self.cityNo == nil || self.countyNo == nil || self.detailAddress == nil || self.contractNo == nil || self.sex == nil || self.mobilePhone == nil || self.Description == nil){
        
        return YES;
    }
    
    
    if ([self isNull:self.shopkeeper] || [self isNull:self.identityNo] || [self isNull:self.provinceNo] || [self isNull:self.cityNo] || [self isNull:self.countyNo] || [self isNull:self.detailAddress] || [self isNull:self.contractNo] || [self isNull:self.sex] || [self isNull:self.mobilePhone] || [self isNull:self.telephone] || [self isNull:self.Description]) {
        
        return YES;
    }
    
    
    return NO;
}
-(BOOL)isNull:(NSObject *)obj{

    if (obj == nil) {
        
        return YES;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        
        if ([obj isEqual:@""]) {
            
            return YES;
        }
    }
    
    return NO;

}

-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

@end
