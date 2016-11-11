//
//  ShopGoodsDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ShopGoodsDTO.h"

@implementation ShopGoodsDTO

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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.imgUrl = [dictInfo objectForKey:@"picUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imgUrl"]]) {
                
                self.imgUrl = [dictInfo objectForKey:@"imgUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"firstOnsaleTime"]]) {
                
                self.firstOnsaleTime = [dictInfo objectForKey:@"firstOnsaleTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsWillNo"]]) {
                
                self.goodsWillNo = [dictInfo objectForKey:@"goodsWillNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"readLevel"]]) {
                
                self.readLevel = [dictInfo objectForKey:@"readLevel"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsType"]]) {
                
                self.goodsType = [dictInfo objectForKey:@"goodsType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"dayNum"]]) {
                
                self.dayNum = [dictInfo objectForKey:@"dayNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"color"]]) {
                
                self.goodsColor = [dictInfo objectForKey:@"color"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
