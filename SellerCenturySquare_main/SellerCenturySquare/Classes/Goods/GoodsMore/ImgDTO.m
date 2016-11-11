//
//  ImgDTO.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/28.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "ImgDTO.h"

@implementation ImgDTO
-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picMax"]]) {
                
                self.picMax = [dictInfo objectForKey:@"picMax"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isRef"]]) {
                
                self.isRef = [dictInfo objectForKey:@"isRef"];
            }
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
