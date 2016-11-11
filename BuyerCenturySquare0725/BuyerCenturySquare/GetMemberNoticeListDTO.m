//
//  GetMemberNoticeListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetMemberNoticeListDTO.h"

@implementation GetMemberNoticeListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.memberNoticeDTOlist = [[NSMutableArray alloc]init];
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
                
                self.memberNoticeDTOlist = [dictInfo objectForKey:@"list"];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end
