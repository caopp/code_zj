//
//  GetImageHistoryListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetImageHistoryListDTO.h"

@implementation GetImageHistoryListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.imageHistoryDTOList = [[NSMutableArray alloc]init];
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
                
                self.imageHistoryDTOList = [dictInfo objectForKey:@"list"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
@end
