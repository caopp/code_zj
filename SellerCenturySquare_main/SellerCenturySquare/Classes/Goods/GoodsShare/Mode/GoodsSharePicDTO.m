//
//  GoodsSharePicDTO.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsSharePicDTO.h"

@implementation GoodsSharePicDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imageUrl"]]) {
                
                self.imageUrl = [dictInfo objectForKey:@"imageUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"imageType"]]) {
                
                self.imageType = [dictInfo objectForKey:@"imageType"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
