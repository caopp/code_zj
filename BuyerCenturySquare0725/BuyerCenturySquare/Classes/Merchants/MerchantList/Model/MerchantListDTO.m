//
//  MerchantListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MerchantListDTO.h"
#import "MerchantListDetailsDTO.h"

@implementation MerchantListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.merchantList = [NSMutableArray array];
        self.totalCount = @0;
        return self;
    }
    return nil;
}
// !重写父类的方法：获得所有的商家数目  把商家显示详情转换成DTO放到数组里面

-(void)setDictFrom:(NSDictionary *)dictInfo{
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
