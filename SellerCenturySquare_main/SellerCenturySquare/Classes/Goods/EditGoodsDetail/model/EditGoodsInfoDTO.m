//
//  EditGoodsInfoDTO.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "EditGoodsInfoDTO.h"

@implementation EditGoodsInfoDTO


-(void)setDictFrom:(NSDictionary *)dictInfo{

    @try {
        
        if (self && dictInfo) {
           
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsName"]]) {
                
                self.goodsName = [dictInfo objectForKey:@"goodsName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }

            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
           
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
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
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"onSaleTime"]]) {
                
                self.onSaleTime = [dictInfo objectForKey:@"onSaleTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"offSaleTime"]]) {
                
                self.onSaleTime = [dictInfo objectForKey:@"offSaleTime"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sampleFlag"]]) {
                
                self.sampleFlag = [dictInfo objectForKey:@"sampleFlag"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"samplePrice"]]) {
                
                self.samplePrice = [dictInfo objectForKey:@"samplePrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsType"]]) {
                
                self.goodsType = [dictInfo objectForKey:@"goodsType"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchNumLimit"]]) {
                
                self.batchNumLimit = [dictInfo objectForKey:@"batchNumLimit"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"defaultPicUrl"]]) {
                
                self.defaultPicUrl = [dictInfo objectForKey:@"defaultPicUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsStatus"]]) {
                
                self.goodsStatus = [dictInfo objectForKey:@"goodsStatus"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"batchMsg"]]) {
                
                self.batchMsg = [dictInfo objectForKey:@"batchMsg"];
            }
            
          
            if ([self checkLegitimacyForData:dictInfo[@"skuList"]]) {
                
                self.skuDTOList = [NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary *skuDic in dictInfo[@"skuList"]) {
                    
                    EditSkuDTO * skuDTO = [[EditSkuDTO alloc]initWithDictionary:skuDic];
                    [self.skuDTOList addObject:skuDTO];
                    
                    
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
