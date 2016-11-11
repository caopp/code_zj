//
//  ImageHistoryDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ImageHistoryDTO.h"

@implementation HistoryPictureDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picType"]]) {
                
                self.picType = [dictInfo objectForKey:@"picType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picNum"]]) {
                
                self.picNum = [dictInfo objectForKey:@"picNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picSize"]]) {
                
                self.picSize = [dictInfo objectForKey:@"picSize"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"count"]]) {
                
                self.count = [dictInfo objectForKey:@"count"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end

@implementation ImageHistoryDTO

- (instancetype)init{
    self = [super init];
    if (self) {
        self.historyPictureDTOList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"picUrl"]]) {
                
                self.picUrl = [dictInfo objectForKey:@"picUrl"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            //        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
            //
            //            self.historyPictureDTOList = [dictInfo objectForKey:@"list"];
            //        }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end

@implementation DownloadHistoryDTO

- (instancetype)init{
    self = [super init];
    if (self) {
        self.list = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    if (self && dictInfo) {
        
        
        if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
            
            self.totalCount = [dictInfo objectForKey:@"totalCount"];
        }
    }
}

@end
