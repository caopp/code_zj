//
//  SearchMerhantDTO.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchMerhantDTO.h"

@implementation SearchMerhantDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{

    
    if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:dictInfo[@"merchantNo"]]) {
            
            self.merchantNo = dictInfo[@"merchantNo"];
    
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"merchantName"]]) {
            
            self.merchantName = dictInfo[@"merchantName"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"stallNo"]]) {
            
            self.stallNo = dictInfo[@"stallNo"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"labelName"]]) {
            
            self.labelName = dictInfo[@"labelName"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"categoryName"]]) {
            
            self.categoryName = dictInfo[@"categoryName"];
            
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"goodsNum"]]) {
            
            self.goodsNum = dictInfo[@"goodsNum"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"pictureUrl"]]) {
            
            self.pictureUrl = dictInfo[@"pictureUrl"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"isFavorite"]]) {
            
            self.isFavorite = dictInfo[@"isFavorite"];
            
        }
        
        
    }

  
    
}

@end

@implementation TenNumGoodsDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{

    
    if (self && dictInfo) {
        
        if ([self checkLegitimacyForData:dictInfo[@"imgUrl"]]) {
            
            self.imgUrl = dictInfo[@"imgUrl"];
            
        }
        if ([self checkLegitimacyForData:dictInfo[@"readLevel"]]) {
            
            self.readLevel = dictInfo[@"readLevel"];
            
        }
        if ([self checkLegitimacyForData:dictInfo[@"memberPirce"]]) {
            
            self.memberPirce = dictInfo[@"memberPirce"];
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"goodsNo"]]) {
            
            self.goodsNo = dictInfo[@"goodsNo"];
            
        }
        
        if ([self checkLegitimacyForData:dictInfo[@"authFlag"]]) {
            
            self.authFlag = dictInfo[@"authFlag"];
            
        }
        
        
        
    }
    

}


@end

