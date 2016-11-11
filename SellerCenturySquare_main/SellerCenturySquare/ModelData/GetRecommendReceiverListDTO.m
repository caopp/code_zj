//
//  GetRecommendReceiverListDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetRecommendReceiverListDTO.h"
#import "RecommendReceiverDTO.h"

@implementation GetRecommendReceiverListDTO

- (id)init{
    self = [super init];
    if (self) {
        self.recommendReceiverDTOList = [[NSMutableArray alloc]init];
        return self;
    }else{
        return nil;
    }
}
-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"totalCount"]]) {
                
                self.totalCount = [dictInfo objectForKey:@"totalCount"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"list"]]) {
                
                NSMutableArray *recArr = [[NSMutableArray alloc]init];
                
                NSMutableArray *arr = [dictInfo objectForKey:@"list"];
                
                for (NSDictionary *tmpDic in arr) {
                    
                    RecommendReceiverDTO *recommendReceiverDTO = [[RecommendReceiverDTO alloc ]init];
                    
                    [recommendReceiverDTO setDictFrom:tmpDic];
                    
                    [recArr addObject:recommendReceiverDTO];
                }
                
                self.recommendReceiverDTOList = recArr;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

@end
