//
//  OrderListDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "OrderListDTO.h"

@implementation OrderListDTO

- (id)init{
    
    self = [super init];
    
    if (self) {
        
        self.list = [[NSMutableArray alloc]init];
    }
    
    return self;
}


-(void)setDictFrom:(NSDictionary *)dictInfo{
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
