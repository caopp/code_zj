//
//  GetBoughtListDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetBoughtListDTO.h"

@implementation GetBoughtListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.boughtDTOList = [[NSMutableArray alloc]init];
        self.totalCount = @0;
        return self;
    }else{
        return nil;
    }
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                self.boughtDTOList = [dictInfo objectForKey:@"list"];
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
