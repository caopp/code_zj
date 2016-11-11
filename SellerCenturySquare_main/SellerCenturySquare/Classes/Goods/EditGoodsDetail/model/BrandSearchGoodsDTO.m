//
//  BrandSearchGoodsDto.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BrandSearchGoodsDto.h"

@implementation BrandSearchGoodsDTO
 - (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self && dictInfo) {
        @try {
            if ([self checkLegitimacyForData:dictInfo[@"totalCount"]]) {
                self.totalCount = dictInfo[@"totalCount"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"list"]]) {
                self.listGoodsArr = [NSMutableArray array];
                NSArray *goodsArr = dictInfo[@"list"];
                for (NSDictionary *dict in goodsArr) {
                    GoodsListDTO *goodslist = [[GoodsListDTO alloc] init];
                    [goodslist setDictFrom:dict];
                    [self.listGoodsArr addObject:goodslist];
                    
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

        
    }
}

@end

@implementation GoodsListDTO

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self &&dictInfo) {
        @try {
            if ([self checkLegitimacyForData:dictInfo[@"brandNo"]]) {
                self.brandNo = dictInfo[@"brandNo"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"cnName"]]) {
                self.cnName = dictInfo[@"cnName"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"enName"]]) {
                self.enName = dictInfo[@"enName"];
        
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}


@end