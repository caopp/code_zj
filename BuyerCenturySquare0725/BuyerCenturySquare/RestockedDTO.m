//
//  RestockedDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RestockedDTO.h"
#import "BasicSkuDTO.h"

@implementation RestockedDTO

- (id)init{
    self = [super init];
    if (self) {
        self.skuListDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchPrice"]]) {
                
                self.batchPrice = [dictInfo objectForKey:@"batchPrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuList"]]) {
                
                self.skuListDTOList = [dictInfo objectForKey:@"skuList"];
            }
        }
        
        if (self.skuListDTOList.count > 0) {
            self.skuList = [NSMutableArray array];
            for (NSDictionary* dict in self.skuListDTOList) {
                BasicSkuDTO* skuValue = [[BasicSkuDTO alloc]initWithDictionary:dict];
                [self.skuList addObject:skuValue];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
