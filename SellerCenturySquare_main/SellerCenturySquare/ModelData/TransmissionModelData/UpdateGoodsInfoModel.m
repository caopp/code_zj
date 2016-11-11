//
//  UpdateGoodsInfoModel.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "UpdateGoodsInfoModel.h"

@implementation GoodsInfoSkuDTOModel

- (NSMutableDictionary* )getDictFrom:(GoodsInfoSkuDTOModel *)goodsInfoSkuDTOModel{
    
    NSMutableDictionary *currentNSDictionary = [[NSMutableDictionary alloc] init];
    if (self && goodsInfoSkuDTOModel) {
        
        if (goodsInfoSkuDTOModel.skuNo != nil) {
            
            [currentNSDictionary setObject:goodsInfoSkuDTOModel.skuNo forKey:@"skuNo"];
        }
        
        if (goodsInfoSkuDTOModel.showStockFlag != nil) {
            
            [currentNSDictionary setObject:goodsInfoSkuDTOModel.showStockFlag forKey:@"showStockFlag"];
        }
    }
    
    return currentNSDictionary;
}


@end

@implementation GoodsInfoStepDTOModel

- (NSMutableDictionary* )getDictFrom:(GoodsInfoStepDTOModel *)goodsInfoStepDTOModel{
    
    NSMutableDictionary *currentNSDictionary = [[NSMutableDictionary alloc] init];
    if (self && goodsInfoStepDTOModel) {
        
        if (goodsInfoStepDTOModel.Id != nil) {
            
            [currentNSDictionary setObject:goodsInfoStepDTOModel.Id forKey:@"id"];
        }
        
        if (goodsInfoStepDTOModel.price != nil) {
            
            [currentNSDictionary setObject:goodsInfoStepDTOModel.price forKey:@"price"];
        }
        
        if (goodsInfoStepDTOModel.minNum != nil) {
            
            [currentNSDictionary setObject:goodsInfoStepDTOModel.minNum forKey:@"minNum"];
        }
        
        if (goodsInfoStepDTOModel.maxNum != nil) {
            
            [currentNSDictionary setObject:goodsInfoStepDTOModel.maxNum forKey:@"maxNum"];
        }

    }
    
    return currentNSDictionary;
}

@end

@implementation UpdateGoodsInfoModel

- (id)init{
    self = [super init];
    if (self) {
        self.updateGoodsInfoSkuDTOModelList = [[NSMutableArray alloc]init];
        self.updateGoodsInfoStepDTOModelList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

-(BOOL)getParameterIsLack
{
    if (self.goodsNo == nil || self.goodsStatus == nil || self.goodsName == nil){
        
        return YES;
    }
    
    if (self.sampleFlag != nil && self.samplePrice == nil) {
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}

@end
