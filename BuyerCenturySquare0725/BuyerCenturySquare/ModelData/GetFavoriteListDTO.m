//
//  GetFavoriteListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetFavoriteListDTO.h"

@implementation MerchantInfoDTO
- (void)setDictFrom:(NSDictionary *)dictInfo {
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsList"]]) {
                self.goodsList = [dictInfo objectForKey:@"goodsList"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end

@implementation GetFavoriteListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.list = [[NSMutableArray alloc]init];
        self.totalCount = @0;
        return self;
    }else{
        return nil;
    }
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
                
                self.totalCount = [dictInfo objectForKey:@"totalCount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                self.list = [dictInfo objectForKey:@"list"];
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
