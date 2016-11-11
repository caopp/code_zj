//
//  MerchantGetBoughtListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MerchantGetBoughtListDTO.h"
#import "MerchantListDetailsDTO.h"

@implementation MerchantGetBoughtListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.merchantList = [NSMutableArray array];
        self.totalCount = @0;
    }
    return self;
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
                
                self.totalCount = [dictInfo objectForKey:@"totalCount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                NSArray* merchantListDict = [dictInfo objectForKey:@"list"];
                
                self.merchantList = [NSMutableArray array];
                for (NSDictionary* merchantInfoDict in merchantListDict) {
                    MerchantListDetailsDTO* merchantInfo = [[MerchantListDetailsDTO alloc]initWithDictionary:merchantInfoDict];
                    [self.merchantList addObject:merchantInfo];
                }
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
