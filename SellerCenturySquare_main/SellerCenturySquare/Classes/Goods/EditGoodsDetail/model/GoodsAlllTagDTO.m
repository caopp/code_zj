//
//  GoodsAlllTagDTO.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsAlllTagDTO.h"

@implementation GoodsAlllTagDTO
- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self && dictInfo) {
        @try {
            
            if ([self checkLegitimacyForData:dictInfo[@"fixed"]]) {
                self.fixedArr = [NSMutableArray array];
                NSArray *fixedTags = dictInfo[@"fixed"];
                for (NSDictionary *dict in fixedTags) {
                    FixedTagDTO *fixed = [[FixedTagDTO alloc] init];
                    [fixed setDictFrom:dict];
                    [self.fixedArr addObject:fixed];
                    
                }
               
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"other"]]) {
                self.otherArr = [NSMutableArray array];
                NSArray *otherTags = dictInfo[@"other"];
                for (NSDictionary *dict in otherTags) {
                    FixedTagDTO *fixedOther = [[FixedTagDTO alloc] init];
                    [fixedOther setDictFrom:dict];
                    [self.otherArr addObject:fixedOther];
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


@implementation FixedTagDTO

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self && dictInfo) {
        @try {
            
            if ([self checkLegitimacyForData:dictInfo[@"labelCategory"]]) {
                self.labelCategory = dictInfo[@"labelCategory"];
                
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"list"]]) {
                self.listArr = [NSMutableArray array];
                NSArray *listTagArr = dictInfo[@"list"];
                for (NSDictionary *dict in listTagArr) {
                    ListTagDTO *listTag = [[ListTagDTO alloc] init];
                    [listTag setDictFrom:dict];
                    [self.listArr addObject:listTag];
                    
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


@implementation ListTagDTO

- (void)setDictFrom:(NSDictionary *)dictInfo
{
    if (self && dictInfo) {
        @try {
            if ([self checkLegitimacyForData:dictInfo[@"labelName"]]) {
                self.labelName = dictInfo[@"labelName"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"id"]]) {
                self.ids = dictInfo[@"id"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"flag"]]) {
                self.flag = dictInfo[@"flag"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}


@end