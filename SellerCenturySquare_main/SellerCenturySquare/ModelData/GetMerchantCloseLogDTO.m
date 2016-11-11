//
//  GetMerchantCloseLogDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMerchantCloseLogDTO.h"

@implementation GetMerchantCloseLogDTO

- (id)init{
    self = [super init];
    if (self) {
        self.MerchantCloseLogDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isSetClose"]]) {
                
                self.isSetClose = [dictInfo objectForKey:@"isSetClose"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"closeLogList"]]) {
                
                self.MerchantCloseLogDTOList = [dictInfo objectForKey:@"closeLogList"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
