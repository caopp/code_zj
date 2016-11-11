//
//  GetAreaListByParentIdListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetAreaListByParentIdListDTO.h"

@implementation GetAreaListByParentIdListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.getAreaListByParentIdDTOList = [[NSMutableArray alloc]init];
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
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
     
    }
    
}
@end
