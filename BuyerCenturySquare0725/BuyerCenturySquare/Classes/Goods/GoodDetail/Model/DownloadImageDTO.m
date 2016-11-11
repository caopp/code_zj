//
//  DownloadImageDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "DownloadImageDTO.h"

@implementation DownloadImageDTO

- (id)init{
   
    self = [super init];
    
    if (self) {
    
        self.pictureDTOList = [[NSMutableArray alloc]init];
        return self;
    
    }else{
        
        return nil;
        
    }
    
}

-(void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"zips"]]) {
                
                self.pictureDTOList = [dictInfo objectForKey:@"zips"];
            }
            
            
        }
    }
    @catch (NSException *exception) {
        
        
    }
    @finally {
        
        
    }
    
}

@end
