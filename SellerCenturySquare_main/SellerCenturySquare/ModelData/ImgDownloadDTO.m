//
//  ImgDownloadDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ImgDownloadDTO.h"

@implementation PictureDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picType"]]) {
                
                self.picType = [dictInfo objectForKey:@"picType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picName"]]) {
                
                self.picName = [dictInfo objectForKey:@"picName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picSize"]]) {
                
                self.picSize = [dictInfo objectForKey:@"picSize"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end

@implementation ImgDownloadDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picType"]]) {
                
                self.picType = [dictInfo objectForKey:@"picType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picSize"]]) {
                
                self.picSize = [dictInfo objectForKey:@"picSize"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"qty"]]) {
                
                self.qty = [dictInfo objectForKey:@"qty"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                self.pictureDTOList = [dictInfo objectForKey:@"list"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
