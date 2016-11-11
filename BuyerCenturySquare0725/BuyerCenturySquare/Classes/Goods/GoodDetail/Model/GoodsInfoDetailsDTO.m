//
//  GoodsInfoDetailsDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GoodsInfoDetailsDTO.h"
#import "ReplenishmentByMerchantDTO.h"
#import "StepListDTO.h"
@implementation GoodsInfoDetailsDTO

- (id)init{
    
    self = [super init];
    
    if (self) {
        
        self.stepList = [[NSMutableArray alloc]init];
        
        self.windowImageList = [[NSMutableArray alloc]init];
        self.objectiveImageList = [[NSMutableArray alloc]init];
        self.referImageList = [[NSMutableArray alloc]init];
        self.skuList = [[NSMutableArray alloc]init];
        
        return self;
    }
    return nil;
}

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsWillNo"]]) {
                
                self.goodsWillNo = [dictInfo objectForKey:@"goodsWillNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsStatus"]]) {
                
                self.goodsStatus = [dictInfo objectForKey:@"goodsStatus"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"details"]]) {
                
                self.details = [dictInfo objectForKey:@"details"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryName"]]) {
                
                self.categoryName = [dictInfo objectForKey:@"categoryName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"brandName"]]) {
                
                self.brandName = [dictInfo objectForKey:@"brandName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"samplePrice"]]) {
                
                self.samplePrice = [dictInfo objectForKey:@"samplePrice"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"onSaleTime"]]) {
                
                self.onSaleTime = [dictInfo objectForKey:@"onSaleTime"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"offSaleTime"]]) {
                
                self.offSaleTime = [dictInfo objectForKey:@"offSaleTime"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isFavorite"]]) {
                
                self.isFavorite = [dictInfo objectForKey:@"isFavorite"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsType"]]) {
                
                self.goodsType = [dictInfo objectForKey:@"goodsType"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopBatchNumLimit"]]) {
                
                self.shopBatchNumLimit = [dictInfo objectForKey:@"shopBatchNumLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopBatchAmountLimit"]]) {
                
                self.shopBatchAmountLimit = [dictInfo objectForKey:@"shopBatchAmountLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsCollectAuth"]]) {
                
                self.goodsCollectAuth = [dictInfo objectForKey:@"goodsCollectAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"windowPicViewAuth"]]) {
                
                self.windowPicViewAuth = [dictInfo objectForKey:@"windowPicViewAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"detailPicViewAuth"]]) {
                
                self.detailPicViewAuth = [dictInfo objectForKey:@"detailPicViewAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"referPicViewAuth"]]) {
                
                self.referPicViewAuth = [dictInfo objectForKey:@"referPicViewAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downloadAuth"]]) {
                
                self.downloadAuth = [dictInfo objectForKey:@"downloadAuth"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shareAuth"]]) {
                
                self.shareAuth = [dictInfo objectForKey:@"shareAuth"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchMsg"]]) {
                
                self.batchMsg = [dictInfo objectForKey:@"batchMsg"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"defaultPicUrl"]]) {
                
                self.defaultPicUrl = [dictInfo objectForKey:@"defaultPicUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sampleSkuInfo"]]) {
                
                self.sampleSkuInfo = [dictInfo objectForKey:@"sampleSkuInfo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"stepList"]]) {
                
                
                NSMutableArray *stepList = [dictInfo objectForKey:@"stepList"];
                NSMutableArray *stepListArr = [[NSMutableArray alloc]init];
                for (NSDictionary *tmpDic in stepList) {
                    
                    StepListDTO *stepListDTO = [[StepListDTO alloc]init];
                    [stepListDTO setDictFrom:tmpDic];
                    [stepListArr addObject:stepListDTO];
                }
                self.stepList = stepListArr;
                
                
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"windowImageList"]]) {
                
                self.windowImageList = [dictInfo objectForKey:@"windowImageList"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"objectiveImageList"]]) {
                
                self.objectiveImageList = [dictInfo objectForKey:@"objectiveImageList"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"referImageList"]]) {
                
                self.referImageList = [dictInfo objectForKey:@"referImageList"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuList"]]) {
                
                NSMutableArray *skuList = [dictInfo objectForKey:@"skuList"];
                NSMutableArray *skuListArr = [[NSMutableArray alloc]init];
                for (NSDictionary *tmpDic in skuList) {
                    
                    DoubleSku *doubleSku = [[DoubleSku alloc]init];
                    [doubleSku setDictFrom:tmpDic];
                    
                    [skuListArr addObject:doubleSku];
                }
                self.skuList = skuListArr;
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"shopLevel"]]) {
                
                self.shopLevel = [dictInfo objectForKey:@"shopLevel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"attrList"]]) {
                
                NSMutableArray *attrList = [dictInfo objectForKey:@"attrList"];
                NSMutableArray *attrListArr = [[NSMutableArray alloc]init];
                for (NSDictionary *tmpDic in attrList) {
                    
                    AttrListDTO *attrListDTO = [[AttrListDTO alloc]init];
                    [attrListDTO setDictFrom:tmpDic];
                    
                    [attrListArr addObject:attrListDTO];
                }
                self.attrList = attrListArr;
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSMutableArray*)skuDictionaryList {
    NSMutableArray* skuDictList = [NSMutableArray array];
    
    for (DoubleSku* skuInfo in self.skuList) {
        if (skuInfo.spotValue > 0) {
            NSMutableDictionary* skuDictionary = [NSMutableDictionary dictionary];
            [skuDictionary setObject:skuInfo.skuNo forKey:@"skuNo"];
            [skuDictionary setObject:skuInfo.skuName forKey:@"skuName"];
            [skuDictionary setObject:[NSNumber numberWithInteger:skuInfo.spotValue] forKey:@"spotQuantity"];
            [skuDictionary setObject:@0 forKey:@"futureQuantity"];
            
            [skuDictList addObject:skuDictionary];
        }
    }
    
    return skuDictList;
}

- (CGFloat)stepPrice {
    NSInteger totalQuantity = [self totalQuantity];
    for (StepListDTO* stepInfo in self.stepList) {
        if (totalQuantity >= [stepInfo.minNum integerValue] && totalQuantity <= [stepInfo.maxNum integerValue]) {
            return [stepInfo.price floatValue];
        }
    }
    return [self.price floatValue];
}

- (NSInteger)totalQuantity {
    NSInteger sum = 0;
    for (DoubleSku* skuValue in self.skuList) {
        sum += skuValue.spotValue;
    }
    
    return sum;
}

- (CGFloat)totalAmount {
    return [self totalQuantity] * [self stepPrice];
}


@end
