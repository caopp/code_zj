//
//  CSPDownLoadImageDTO.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/15.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPDownLoadImageDTO.h"

@implementation CSPDownLoadImageDTO


- (instancetype)init{
    self = [super init];
    if (self) {
        self.zipsList = [[NSMutableArray alloc]init];
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
            
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    

}

- (NSMutableDictionary *)getLoadUrlWith:(NSMutableArray *)zipsList{
    
    NSMutableDictionary *zipDic = [[NSMutableDictionary alloc]init];
    
    @try {
        for (CSPZipsDTO *zipsDTO in zipsList) {
            
            [zipDic setObject:zipsDTO.zipUrl forKey:zipsDTO.picType];
            
        }

    }
    @catch (NSException *exception) {
    
    }
    @finally {
        
    }
    
    
    return zipDic;
}

- (NSMutableDictionary *)getImageItemsWith:(NSMutableArray *)zipsList{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (CSPZipsDTO *zipsDTO in zipsList) {
        [dic setObject:zipsDTO.qty forKey:zipsDTO.picType];
    }
    
    return dic;
}

@end

@implementation CSPZipsDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"zipUrl"]]) {
                
                self.zipUrl = [dictInfo objectForKey:@"zipUrl"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picType"]]) {
                
                self.picType = [dictInfo objectForKey:@"picType"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"qty"]]) {
                
                self.qty = [dictInfo objectForKey:@"qty"];
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
