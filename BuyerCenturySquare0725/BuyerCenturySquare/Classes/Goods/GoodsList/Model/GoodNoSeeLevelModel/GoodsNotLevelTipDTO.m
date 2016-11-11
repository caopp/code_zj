//
//  GoodsNotLevelTipDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GoodsNotLevelTipDTO.h"

@implementation GoodsNotLevelTipDTO


-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"readLevel"]]) {
                
                self.readLevel = [dictInfo objectForKey:@"readLevel"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"currentLevel"]]) {
                
                self.currentLevel = [dictInfo objectForKey:@"currentLevel"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"integralNum"]]) {
                
                self.integralNum = [dictInfo objectForKey:@"integralNum"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
