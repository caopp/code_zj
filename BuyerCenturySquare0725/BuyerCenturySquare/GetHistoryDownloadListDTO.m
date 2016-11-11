//
//  GetHistoryDownloadListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetHistoryDownloadListDTO.h"

@implementation GetHistoryDownloadListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.historyDownloadDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
                
                self.totalCount = [dictInfo objectForKey:@"totalCount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                self.historyDownloadDTOList = [dictInfo objectForKey:@"list"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
