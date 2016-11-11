//
//  GetCartConfirmDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetCartConfirmDTO.h"

@implementation GoodsDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsType"]]) {
                
                self.goodsType = [dictInfo objectForKey:@"goodsType"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"samplePrice"]]) {
                
                self.samplePrice = [dictInfo objectForKey:@"samplePrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isSample"]]) {
                
                self.isSample = [dictInfo objectForKey:@"isSample"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"price"]]) {
                
                self.price = [dictInfo objectForKey:@"price"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"quantity"]]) {
                
                self.quantity = [dictInfo objectForKey:@"quantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sizes"]]) {
                
                self.sizes = [dictInfo objectForKey:@"sizes"];
            }
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end

@implementation MerchantDTO

- (id)init{
    self = [super init];
    if (self) {
        self.goodsDTOList = [[NSMutableArray alloc]init];
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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [dictInfo objectForKey:@"type"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsList"]]) {
                
                self.goodsDTOList = [dictInfo objectForKey:@"goodsList"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end

@implementation GetCartConfirmDTO

- (id)init{
    self = [super init];
    if (self) {
        self.merchantDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalPrice"]]) {
                
                self.totalPrice = [dictInfo objectForKey:@"totalPrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalQuantity"]]) {
                
                self.totalQuantity = [dictInfo objectForKey:@"totalQuantity"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantList"]]) {
                
                self.merchantDTOList = [dictInfo objectForKey:@"merchantList"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
