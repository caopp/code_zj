//
//  EditGoodsDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "EditGoodsDTO.h"

@implementation EditGoodsDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imgUrl"]]) {
                
                self.imgUrl = [dictInfo objectForKey:@"imgUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsWillNo"]]) {
                
                self.goodsWillNo = [dictInfo objectForKey:@"goodsWillNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.color = [dictInfo objectForKey:@"color"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsType"]]) {
                
                self.goodsType = [dictInfo objectForKey:@"goodsType"];
            }
            
            if ([self checkLegitimacyForData:dictInfo[@"firstOnsaleTime"]]) {
                
                self.firstOnsaleTime = dictInfo[@"firstOnsaleTime"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"price1"]]) {
                self.price1 = dictInfo[@"price1"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"price2"]]) {
                
                self.price2 = dictInfo[@"price2"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"price3"]]) {
                
                self.price3 =dictInfo[@"price3"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"price4"]]) {
                
                self.price4 = dictInfo[@"price4"];
            }
            if ([self checkLegitimacyForData:dictInfo[@"price5"]]) {
                
                self.price5 = dictInfo[@"price5"];
                
            }
            if ([self checkLegitimacyForData:dictInfo[@"price6"]]) {
                
                self.price6 = dictInfo[@"price6"];
            }

            
            
            
            if ([self checkLegitimacyForData:dictInfo[@"goodsStatus"]]) {
                
                self.goodsStatus  = dictInfo[@"goodsStatus"];
            }
            
            //!销售渠道
            if ([self checkLegitimacyForData:dictInfo[@"channelList"]]) {
                
                self.channelList = dictInfo[@"channelList"];
                
            }
            //!零售价格
            if ([self checkLegitimacyForData:dictInfo[@"retailPrice"]]) {
                
                self.retailPrice = dictInfo[@"retailPrice"];
                
            }
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
